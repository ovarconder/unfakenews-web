"use client";

import { useEditor, EditorContent } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';
import Image from '@tiptap/extension-image';
import Placeholder from '@tiptap/extension-placeholder';
import TextAlign from '@tiptap/extension-text-align';
import Underline from '@tiptap/extension-underline';
import { EditorToolbar } from './editor-toolbar';
import { supabase } from '@/lib/supabase';
import './editor-styles.css';

interface RichTextEditorProps {
  content: string;
  onChange: (html: string) => void;
  placeholder?: string;
}

export function RichTextEditor({ content, onChange, placeholder = 'เริ่มเขียนบทความ...' }: RichTextEditorProps) {
  const editor = useEditor({
    extensions: [
      StarterKit.configure({
        heading: {
          levels: [1, 2, 3],
        },
      }),
      Image.configure({
        HTMLAttributes: {
          class: 'rounded-lg max-w-full my-4',
        },
        inline: false,
      }),
      Placeholder.configure({
        placeholder,
      }),
      TextAlign.configure({
        types: ['heading', 'paragraph'],
      }),
      Underline,
    ],
    content,
    editorProps: {
      attributes: {
        class: 'prose prose-sm sm:prose lg:prose-lg xl:prose-xl focus:outline-none max-w-none p-6 min-h-[500px]',
      },
    },
    onUpdate: ({ editor }) => {
      onChange(editor.getHTML());
    },
  });

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !editor) return;

    try {
      // Validate
      if (file.size > 5 * 1024 * 1024) {
        alert('⚠️ ไฟล์ใหญ่เกิน 5MB');
        return;
      }

      if (!file.type.startsWith('image/')) {
        alert('⚠️ อัพโหลดได้เฉพาะรูปภาพ');
        return;
      }

      // Upload to Supabase
      const fileExt = file.name.split('.').pop();
      const fileName = `${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
      const filePath = `posts/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('post-images')
        .upload(filePath, file);

      if (uploadError) throw uploadError;

      // Get public URL
      const { data: { publicUrl } } = supabase.storage
        .from('post-images')
        .getPublicUrl(filePath);

      // Insert image into editor
      editor.chain().focus().setImage({ src: publicUrl }).run();
    } catch (error) {
      console.error('Upload error:', error);
      alert('❌ อัพโหลดล้มเหลว');
    }
  };

  const handleMultipleImagesUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || !editor) return;

    const imageFiles = Array.from(files).filter(file => file.type.startsWith('image/'));
    
    if (imageFiles.length === 0) {
      alert('⚠️ กรุณาเลือกไฟล์รูปภาพ');
      return;
    }

    try {
      // Upload all images
      const uploadPromises = imageFiles.map(async (file) => {
        const fileExt = file.name.split('.').pop();
        const fileName = `${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
        const filePath = `posts/${fileName}`;

        await supabase.storage.from('post-images').upload(filePath, file);
        
        const { data: { publicUrl } } = supabase.storage
          .from('post-images')
          .getPublicUrl(filePath);
        
        return publicUrl;
      });

      const urls = await Promise.all(uploadPromises);

      // Insert gallery (multiple images in a row)
      urls.forEach(url => {
        editor.chain().focus().setImage({ src: url }).run();
      });

      alert(`✅ อัพโหลด ${urls.length} รูปสำเร็จ!`);
    } catch (error) {
      console.error('Gallery upload error:', error);
      alert('❌ อัพโหลดบางรูปล้มเหลว');
    }
  };

  if (!editor) {
    return null;
  }

  return (
    <div className="border rounded-lg overflow-hidden bg-white">
      <EditorToolbar 
        editor={editor} 
        onImageUpload={handleImageUpload}
        onGalleryUpload={handleMultipleImagesUpload}
      />
      <EditorContent editor={editor} />
    </div>
  );
}
