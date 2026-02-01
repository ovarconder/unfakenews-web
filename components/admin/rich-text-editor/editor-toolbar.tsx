"use client";

import { Editor } from '@tiptap/react';
import { Button } from '@/components/ui/button';
import {
  Bold,
  Italic,
  Underline as UnderlineIcon,
  Strikethrough,
  Code,
  Heading1,
  Heading2,
  Heading3,
  List,
  ListOrdered,
  Quote,
  Undo,
  Redo,
  AlignLeft,
  AlignCenter,
  AlignRight,
  Image as ImageIcon,
  Images,
  Minus,
} from 'lucide-react';

interface EditorToolbarProps {
  editor: Editor;
  onImageUpload: (e: React.ChangeEvent<HTMLInputElement>) => void;
  onGalleryUpload: (e: React.ChangeEvent<HTMLInputElement>) => void;
}

export function EditorToolbar({ editor, onImageUpload, onGalleryUpload }: EditorToolbarProps) {
  const ToolbarButton = ({ 
    onClick, 
    isActive = false, 
    icon: Icon, 
    title 
  }: { 
    onClick: () => void; 
    isActive?: boolean; 
    icon: any; 
    title: string;
  }) => (
    <Button
      type="button"
      variant={isActive ? 'default' : 'ghost'}
      size="sm"
      onClick={onClick}
      title={title}
      className="h-8 w-8 p-0"
    >
      <Icon className="h-4 w-4" />
    </Button>
  );

  return (
    <div className="border-b bg-gray-50 p-2 flex flex-wrap gap-1">
      {/* Text Formatting */}
      <div className="flex gap-1 pr-2 border-r">
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleBold().run()}
          isActive={editor.isActive('bold')}
          icon={Bold}
          title="Bold (Ctrl+B)"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleItalic().run()}
          isActive={editor.isActive('italic')}
          icon={Italic}
          title="Italic (Ctrl+I)"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleUnderline().run()}
          isActive={editor.isActive('underline')}
          icon={UnderlineIcon}
          title="Underline (Ctrl+U)"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleStrike().run()}
          isActive={editor.isActive('strike')}
          icon={Strikethrough}
          title="Strikethrough"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleCode().run()}
          isActive={editor.isActive('code')}
          icon={Code}
          title="Inline Code"
        />
      </div>

      {/* Headings */}
      <div className="flex gap-1 pr-2 border-r">
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()}
          isActive={editor.isActive('heading', { level: 1 })}
          icon={Heading1}
          title="Heading 1"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()}
          isActive={editor.isActive('heading', { level: 2 })}
          icon={Heading2}
          title="Heading 2"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()}
          isActive={editor.isActive('heading', { level: 3 })}
          icon={Heading3}
          title="Heading 3"
        />
      </div>

      {/* Lists */}
      <div className="flex gap-1 pr-2 border-r">
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleBulletList().run()}
          isActive={editor.isActive('bulletList')}
          icon={List}
          title="Bullet List"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleOrderedList().run()}
          isActive={editor.isActive('orderedList')}
          icon={ListOrdered}
          title="Numbered List"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().toggleBlockquote().run()}
          isActive={editor.isActive('blockquote')}
          icon={Quote}
          title="Block Quote"
        />
      </div>

      {/* Alignment */}
      <div className="flex gap-1 pr-2 border-r">
        <ToolbarButton
          onClick={() => editor.chain().focus().setTextAlign('left').run()}
          isActive={editor.isActive({ textAlign: 'left' })}
          icon={AlignLeft}
          title="Align Left"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().setTextAlign('center').run()}
          isActive={editor.isActive({ textAlign: 'center' })}
          icon={AlignCenter}
          title="Align Center"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().setTextAlign('right').run()}
          isActive={editor.isActive({ textAlign: 'right' })}
          icon={AlignRight}
          title="Align Right"
        />
      </div>

      {/* Insert */}
      <div className="flex gap-1 pr-2 border-r">
        <input
          type="file"
          accept="image/*"
          onChange={onImageUpload}
          className="hidden"
          id="image-upload-editor"
        />
        <label htmlFor="image-upload-editor">
          <Button
            type="button"
            variant="ghost"
            size="sm"
            title="Insert Image"
            className="h-8 w-8 p-0 cursor-pointer"
            asChild
          >
            <span>
              <ImageIcon className="h-4 w-4" />
            </span>
          </Button>
        </label>

        <input
          type="file"
          accept="image/*"
          multiple
          onChange={onGalleryUpload}
          className="hidden"
          id="gallery-upload-editor"
        />
        <label htmlFor="gallery-upload-editor">
          <Button
            type="button"
            variant="ghost"
            size="sm"
            title="Insert Gallery (Multiple Images)"
            className="h-8 w-8 p-0 cursor-pointer"
            asChild
          >
            <span>
              <Images className="h-4 w-4" />
            </span>
          </Button>
        </label>

        <ToolbarButton
          onClick={() => editor.chain().focus().setHorizontalRule().run()}
          icon={Minus}
          title="Horizontal Rule"
        />
      </div>

      {/* History */}
      <div className="flex gap-1">
        <ToolbarButton
          onClick={() => editor.chain().focus().undo().run()}
          icon={Undo}
          title="Undo (Ctrl+Z)"
        />
        <ToolbarButton
          onClick={() => editor.chain().focus().redo().run()}
          icon={Redo}
          title="Redo (Ctrl+Shift+Z)"
        />
      </div>
    </div>
  );
}
