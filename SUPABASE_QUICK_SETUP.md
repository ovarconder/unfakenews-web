# ⚡ Quick Fix - อัพโหลดรูปไม่ทำงาน

## 🎯 ทำ 3 ขั้นตอน:

### 1️⃣ หา Supabase Credentials

1. เข้า https://app.supabase.com
2. Settings → API
3. คัดลอก 2 อันนี้:
   - **Project URL**
   - **anon public** (ในส่วน Project API keys)

### 2️⃣ เพิ่มใน `.env.local`

```env
NEXT_PUBLIC_SUPABASE_URL="https://xxxxxxxxxxxxx.supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### 3️⃣ สร้าง Bucket

1. Supabase → Storage → New bucket
2. Name: `post-images`
3. ✅ Public bucket
4. Create

### 4️⃣ Restart

```bash
npm run dev
```

---

## ✅ เสร็จแล้ว!

ลองอัพโหลดรูปอีกครั้ง ควรเห็น:
- ✅ "อัพโหลดสำเร็จ!"
- รูปภาพ Preview

---

## 🔍 เช็คว่าติดตั้งถูก:

เปิด Browser Console (F12):
- ถ้าเห็น `⚠️ Supabase credentials not found` = ยังไม่ได้เพิ่ม env
- ถ้าไม่มี warning = OK

---

📚 **อ่านเพิ่ม:** `FIX_IMAGE_UPLOAD_SILENT.md`
