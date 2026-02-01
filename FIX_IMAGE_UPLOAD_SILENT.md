# 🚨 แก้: อัพโหลดรูปนิ่งเงียบ

## ปัญหา:
กดปุ่ม "เลือกรูปภาพจากเครื่อง" แล้วไม่มีอะไรเกิดขึ้น

## 🔍 สาเหตุ:
ยังไม่ได้ setup Supabase Storage:
1. ไม่มี `NEXT_PUBLIC_SUPABASE_URL` ใน `.env`
2. หรือยังไม่สร้าง bucket `post-images`

---

## ✅ แก้ไข (2 ขั้นตอน):

### ขั้นที่ 1: เพิ่ม Supabase Credentials

#### 1. หา Credentials จาก Supabase

1. เข้า https://app.supabase.com
2. เลือก Project
3. ไปที่ **Settings** (เมนูซ้าย)
4. คลิก **API**
5. คัดลอก:
   - **Project URL** (ด้านบน)
   - **anon public** key (ส่วน Project API keys)

#### 2. เพิ่มใน `.env.local`

สร้าง/แก้ไข `.env.local`:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL="https://xxxxxxxxxxxxx.supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Database (ที่มีอยู่แล้ว)
DATABASE_URL="postgresql://..."
```

### ขั้นที่ 2: สร้าง Storage Bucket

#### 1. เข้า Supabase Storage

1. ใน Supabase Dashboard
2. คลิก **Storage** (เมนูซ้าย)
3. คลิก **"New bucket"** (ปุ่มสีเขียว)

#### 2. ตั้งค่า Bucket

```
Name: post-images
Public bucket: ✅ (เปิด)
File size limit: 5242880 (5MB)
Allowed MIME types: image/jpeg, image/png, image/webp, image/gif
```

#### 3. คลิก "Create bucket"

### ขั้นที่ 3: Restart Server

```bash
npm run dev
```

---

## 🧪 ทดสอบ:

1. เข้า `/admin/posts/create`
2. คลิก "เลือกรูปภาพจากเครื่อง"
3. เลือกรูปภาพ
4. ควรเห็น:
   - 📤 "กำลังอัพโหลด..."
   - ✅ "อัพโหลดสำเร็จ!"
   - รูปภาพ Preview

---

## 🔍 เช็คว่า Setup ถูกต้อง:

### เช็ค Console (Browser F12):

```javascript
// เปิด console ใน browser
console.log('Supabase URL:', process.env.NEXT_PUBLIC_SUPABASE_URL)
```

ถ้าเป็น `undefined` = ยังไม่ได้เพิ่ม env variables

### เช็ค Network Tab:

1. กด F12 → Network
2. เลือกรูปภาพ
3. ดู request ไป Supabase
4. ถ้า error → ดู error message

---

## 🐛 Common Errors:

### 1. "Bucket not found"

**แก้:**
- ตรวจสอบว่าสร้าง bucket ชื่อ `post-images`
- ใน `lib/supabase.ts` ใช้ชื่อ `post-images`

### 2. "Invalid API key"

**แก้:**
- คัดลอก **anon public** key (ไม่ใช่ service_role)
- ตรวจสอบว่าไม่มีช่องว่างหรือตัวอักษรเกิน

### 3. "The resource you are looking for could not be found"

**แก้:**
- Project URL ต้องตรงกับ project ที่สร้าง bucket
- ลองสร้าง bucket ใหม่

### 4. Console แสดง Warning

```
⚠️ Supabase credentials not found. Image upload will not work.
```

**แก้:**
- เพิ่ม `NEXT_PUBLIC_SUPABASE_URL` ใน `.env.local`
- Restart server

---

## 📋 Checklist:

- [ ] สร้าง/เปิดไฟล์ `.env.local`
- [ ] เพิ่ม `NEXT_PUBLIC_SUPABASE_URL`
- [ ] เพิ่ม `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- [ ] สร้าง bucket ชื่อ `post-images`
- [ ] ตั้ง bucket เป็น Public
- [ ] Restart dev server
- [ ] ทดสอบอัพโหลดรูป

---

## 💡 ทางเลือกอื่น (ถ้าไม่อยากใช้ Supabase):

### ใช้ URL ภายนอกแทน:

ในหน้า create post ยังมีช่อง **"ใส่ URL รูปภาพ"** ให้:

1. อัพโหลดรูปที่ Unsplash.com
2. คลิกขวา → Copy Image Address
3. วางใน URL field

**แหล่งรูปฟรี:**
- https://unsplash.com - รูปคุณภาพสูง
- https://pixabay.com - รูปฟรี
- https://pexels.com - รูปฟรี

---

## 🎯 ตัวอย่าง `.env.local` ที่สมบูรณ์:

```env
# Database
DATABASE_URL="postgresql://postgres.abc:pass@aws-0-region.pooler.supabase.com:6543/postgres?pgbouncer=true"

# NextAuth
NEXTAUTH_URL="https://www.unfakenews.asia"
NEXTAUTH_SECRET="your-secret-here"

# Gemini AI
GEMINI_API_KEY="your-gemini-key"

# Supabase Storage
NEXT_PUBLIC_SUPABASE_URL="https://xxxxxxxxxxxxx.supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

🚀 **ทำตามขั้นตอนแล้ว restart server ครับ!**
