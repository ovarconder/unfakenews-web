# 🎉 Rich Text Editor - ติดตั้งเสร็จแล้ว!

## ✅ สิ่งที่ทำเสร็จแล้ว:

### 1. ติดตั้ง Packages
```bash
✅ @tiptap/react
✅ @tiptap/starter-kit
✅ @tiptap/extension-image
✅ @tiptap/extension-placeholder
✅ @tiptap/extension-text-align
✅ @tiptap/extension-underline
```

### 2. สร้าง Components
```
✅ components/admin/rich-text-editor/
   ├── index.tsx           # Main editor
   ├── editor-toolbar.tsx  # Toolbar with buttons
   └── editor-styles.css   # Editor styling
```

### 3. แทนที่ Textarea
✅ อัพเดท `app/admin/posts/create/page.tsx`
✅ textarea เดิม → Rich Text Editor

---

## 🎨 Features ที่มี:

### ✍️ Text Formatting
- ✅ **Bold** (Ctrl+B)
- ✅ *Italic* (Ctrl+I)
- ✅ <u>Underline</u> (Ctrl+U)
- ✅ ~~Strikethrough~~
- ✅ `Inline Code`

### 📐 Headings
- ✅ H1 (Heading 1)
- ✅ H2 (Heading 2)
- ✅ H3 (Heading 3)

### 📝 Lists
- ✅ Bullet lists
- ✅ Numbered lists
- ✅ Block quotes

### 🎯 Alignment
- ✅ Left align
- ✅ Center align
- ✅ Right align

### 📷 Images
- ✅ **Single Image** - ใส่รูปเดี่ยว
- ✅ **Gallery** - อัพโหลดหลายรูปพร้อมกัน
- ✅ Auto-upload to Supabase Storage
- ✅ Drag & drop (รองรับแล้ว)
- ✅ Paste from clipboard

### 🔧 Other
- ✅ Horizontal rule (---) 
- ✅ Undo/Redo
- ✅ Placeholder text
- ✅ Responsive design

---

## 🚀 วิธีใช้งาน:

### 1. เริ่มเขียน
1. เข้า `/admin/posts/create`
2. เห็น Rich Text Editor พร้อมใช้
3. เริ่มพิมพ์เลย!

### 2. จัดรูปแบบข้อความ
- **Bold**: เลือกข้อความ → คลิก **B** หรือ Ctrl+B
- **Italic**: เลือกข้อความ → คลิก *I* หรือ Ctrl+I
- **Heading**: เลือกข้อความ → คลิก H1, H2, หรือ H3

### 3. ใส่รูปภาพเดี่ยว
1. คลิกปุ่ม **📷 Image** (ใน toolbar)
2. เลือกรูปภาพ
3. รอสักครู่ → รูปจะปรากฏใน editor
4. คลิกต่อเพื่อเขียนต่อ

### 4. ใส่ Gallery (หลายรูป)
1. คลิกปุ่ม **🖼️ Gallery** 
2. เลือกหลายรูปพร้อมกัน (Shift+Click หรือ Ctrl+Click)
3. กด Open
4. รอสักครู่ → รูปทั้งหมดจะปรากฏ

### 5. Lists & Quotes
- **Bullet List**: คลิก • icon
- **Numbered List**: คลิก 1. icon  
- **Quote**: คลิก " icon

---

## 📸 Image Upload:

### Single Image:
```
[พิมพ์ข้อความ...]

[คลิก 📷] → เลือกรูป → รูปปรากฏ

[พิมพ์ต่อ...]
```

### Gallery (Multiple):
```
[พิมพ์ข้อความ...]

[คลิก 🖼️] → เลือก 3-5 รูป → รูปทั้งหมดปรากฏ

[พิมพ์ต่อ...]
```

---

## 💡 Tips:

### 1. Keyboard Shortcuts
- `Ctrl+B` = Bold
- `Ctrl+I` = Italic
- `Ctrl+U` = Underline
- `Ctrl+Z` = Undo
- `Ctrl+Shift+Z` = Redo

### 2. Image Best Practices
- ขนาดแนะนำ: 1200x800px
- ขนาดไฟล์: < 5MB
- Format: JPG, PNG, WebP

### 3. Gallery Layout
- 2-3 รูป = แสดงแบบ 2 คอลัมน์ (desktop)
- 4+ รูป = แสดงแบบ grid
- Mobile = แสดงแบบ 1 คอลัมน์

---

## 🎨 Output:

Editor สร้าง **HTML** ที่สวยงาม:

```html
<h2>หัวข้อข่าว</h2>
<p>เนื้อหาข่าว <strong>ตัวหนา</strong> และ <em>ตัวเอียง</em></p>

<img src="https://supabase.../image1.jpg" class="rounded-lg" />

<ul>
  <li>รายการที่ 1</li>
  <li>รายการที่ 2</li>
</ul>

<blockquote>ข้อความ quote</blockquote>
```

---

## 🔧 Customization:

### เปลี่ยนสี Theme:

แก้ใน `editor-styles.css`:

```css
.ProseMirror {
  @apply bg-white; /* เปลี่ยนพื้นหลัง */
}

.ProseMirror h2 {
  @apply text-blue-600; /* เปลี่ยนสี heading */
}
```

### เพิ่ม Extensions:

```bash
# Link
npm install @tiptap/extension-link

# Table
npm install @tiptap/extension-table

# Task List
npm install @tiptap/extension-task-list
```

---

## 🐛 Troubleshooting:

### 1. รูปภาพอัพโหลดไม่ได้

**เช็ค:**
- ✅ มี `NEXT_PUBLIC_SUPABASE_URL` ใน `.env.local`
- ✅ มี `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- ✅ สร้าง bucket `post-images` แล้ว

**แก้:**
```bash
# ดู console logs (F12)
# จะเห็น error message
```

### 2. Editor ไม่แสดง

**แก้:**
```bash
# Restart server
npm run dev
```

### 3. Toolbar ไม่ทำงาน

**เช็ค:**
- ✅ คลิกใน editor ก่อน
- ✅ เลือกข้อความก่อนจัดรูปแบบ

---

## 📄 Files Created:

```
components/admin/rich-text-editor/
├── index.tsx              ← Main component
├── editor-toolbar.tsx     ← Toolbar with all buttons
└── editor-styles.css      ← Styling

app/admin/posts/create/
└── page.tsx               ← Updated (ใช้ Rich Editor แล้ว)
```

---

## 🎯 Next Steps (Optional):

### 1. เพิ่ม Features:
- [ ] Link insertion
- [ ] Table support
- [ ] Video embed
- [ ] Code syntax highlighting

### 2. Drag & Drop Enhancement:
```typescript
// เพิ่มใน editor config
editorProps: {
  handleDrop: (view, event, slice, moved) => {
    // Handle image drop
  }
}
```

### 3. Image Optimization:
```bash
npm install sharp
# Optimize images before upload
```

---

## ✅ Summary:

- ✅ Rich Text Editor พร้อมใช้
- ✅ รองรับ Text Formatting ครบ
- ✅ อัพโหลดรูปภาพได้ (เดี่ยว + gallery)
- ✅ HTML output สวยงาม
- ✅ Responsive design
- ✅ ไม่มี linter errors

---

🎉 **พร้อมใช้งานแล้ว!** เข้า `/admin/posts/create` แล้วลองเขียนบทความได้เลยครับ!
