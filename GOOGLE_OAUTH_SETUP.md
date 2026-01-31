# 🔐 Google OAuth Setup Guide

## 📝 Overview
ตั้งค่า Google OAuth เพื่อให้ผู้ใช้สามารถ Sign In ด้วย Google ได้

---

## 🚀 Step-by-Step Guide

### Step 1: สร้าง Google Cloud Project

1. **ไปที่ Google Cloud Console:**
   ```
   https://console.cloud.google.com/
   ```

2. **สร้าง Project ใหม่:**
   - คลิก "Select a project" ที่มุมบนซ้าย
   - คลิก "NEW PROJECT"
   - ตั้งชื่อ: "UnfakeNews" (หรือชื่อที่ต้องการ)
   - คลิก "CREATE"

---

### Step 2: เปิดใช้งาน Google+ API

1. **ไปที่ API & Services:**
   ```
   https://console.cloud.google.com/apis/library
   ```

2. **ค้นหา "Google+ API":**
   - พิมพ์ "Google+" ในช่องค้นหา
   - คลิกที่ "Google+ API"
   - คลิก "ENABLE"

---

### Step 3: สร้าง OAuth 2.0 Credentials

1. **ไปที่ Credentials:**
   ```
   https://console.cloud.google.com/apis/credentials
   ```

2. **สร้าง OAuth consent screen:**
   - คลิก "OAuth consent screen" (ซ้ายมือ)
   - เลือก "External"
   - คลิก "CREATE"

3. **กรอกข้อมูล OAuth consent screen:**
   ```
   App name: UnfakeNews
   User support email: your@email.com
   Developer contact: your@email.com
   ```
   - คลิก "SAVE AND CONTINUE"
   - Scopes: กด "SAVE AND CONTINUE" (ไม่ต้องเพิ่มอะไร)
   - Test users: กด "SAVE AND CONTINUE"
   - คลิก "BACK TO DASHBOARD"

4. **สร้าง OAuth Client ID:**
   - กลับไปที่ "Credentials"
   - คลิก "+ CREATE CREDENTIALS"
   - เลือก "OAuth client ID"
   - Application type: "Web application"
   - Name: "UnfakeNews Web"

5. **เพิ่ม Authorized redirect URIs:**
   ```
   Development (localhost):
   http://localhost:3000/api/auth/callback/google
   
   Production (your domain):
   https://yourdomain.com/api/auth/callback/google
   ```

6. **คลิก "CREATE"**
   - จะได้ **Client ID** และ **Client Secret**
   - **บันทึกไว้!** จะใช้ในขั้นตอนถัดไป

---

### Step 4: เพิ่ม Environment Variables

1. **เปิดไฟล์ `.env` (ที่ project root):**
   ```bash
   code .env
   ```

2. **เพิ่ม Google OAuth credentials:**
   ```env
   # Google OAuth
   GOOGLE_CLIENT_ID="your-client-id.apps.googleusercontent.com"
   GOOGLE_CLIENT_SECRET="your-client-secret"
   
   # NextAuth
   NEXTAUTH_URL="http://localhost:3000"
   NEXTAUTH_SECRET="your-random-secret-here"
   
   # Database
   DATABASE_URL="your-database-url"
   
   # Gemini AI
   GEMINI_API_KEY="your-gemini-key"
   ```

3. **Generate NEXTAUTH_SECRET:**
   ```bash
   # ใช้คำสั่งนี้
   openssl rand -base64 32
   
   # หรือ
   node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
   ```

---

### Step 5: Restart Development Server

```bash
# Kill server เดิม (Ctrl + C)
# Start ใหม่
npm run dev
```

---

## 🎯 Testing

### 1. ไปที่หน้า Sign In:
```
http://localhost:3000/auth/signin
```

### 2. คลิก "Sign in with Google"

### 3. เลือก Google Account

### 4. Allow permissions

### 5. จะถูก redirect กลับมาที่:
```
http://localhost:3000/admin
```

---

## 📋 Checklist

- [ ] สร้าง Google Cloud Project
- [ ] เปิดใช้งาน Google+ API
- [ ] สร้าง OAuth consent screen
- [ ] สร้าง OAuth Client ID
- [ ] เพิ่ม Authorized redirect URIs
- [ ] Copy Client ID และ Client Secret
- [ ] เพิ่มใน `.env`
- [ ] Generate NEXTAUTH_SECRET
- [ ] Restart dev server
- [ ] Test sign in

---

## 🔍 Troubleshooting

### Error: "redirect_uri_mismatch"

**Problem:** Redirect URI ไม่ตรงกับที่ตั้งไว้ใน Google Console

**Fix:**
1. ไปที่ Google Cloud Console → Credentials
2. Edit OAuth Client ID
3. เพิ่ม redirect URI:
   ```
   http://localhost:3000/api/auth/callback/google
   ```
4. Save

---

### Error: "Access blocked: This app's request is invalid"

**Problem:** OAuth consent screen ยังไม่ complete

**Fix:**
1. ไปที่ OAuth consent screen
2. กรอกข้อมูลให้ครบ:
   - App name
   - User support email
   - Developer contact
3. Save

---

### Error: "Cannot find GOOGLE_CLIENT_ID"

**Problem:** Environment variables ไม่ถูก load

**Fix:**
```bash
# ตรวจสอบ .env file
cat .env

# Restart server
npm run dev
```

---

## 📦 Alternative: สร้าง User แบบ Manual

ถ้ายังไม่พร้อมตั้ง Google OAuth สามารถสร้าง User แบบ manual:

```sql
-- Via Supabase SQL Editor
INSERT INTO "User" (id, name, email, role, "createdAt", "updatedAt")
VALUES 
  (
    'manual-user-1', 
    'Admin User', 
    'admin@unfakenews.com', 
    'ADMIN', 
    NOW(), 
    NOW()
  );
```

จากนั้นรัน `sample-data-simple.sql` ได้เลย!

---

## 🚀 For Production (Vercel)

### 1. เพิ่ม Production Redirect URI:
```
https://yourdomain.com/api/auth/callback/google
```

### 2. เพิ่ม Environment Variables ใน Vercel:
```
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
NEXTAUTH_URL=https://yourdomain.com
NEXTAUTH_SECRET=...
```

### 3. Redeploy

---

## 📝 Complete .env Example

```env
# Database
DATABASE_URL="postgresql://..."

# Google OAuth
GOOGLE_CLIENT_ID="123456789-abc.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="GOCSPX-abc123..."

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-32-char-random-string"

# Gemini AI
GEMINI_API_KEY="AIza..."

# Public URLs
NEXT_PUBLIC_BASE_URL="http://localhost:3000"
NEXT_PUBLIC_GA_ID="G-XXXXXXXXXX"
```

---

## 💡 Quick Alternative

ถ้าไม่อยากตั้ง Google OAuth ตอนนี้:

**Option 1: สร้าง User manual:**
```sql
INSERT INTO "User" (id, name, email, role, "createdAt", "updatedAt")
VALUES ('user-1', 'Your Name', 'your@email.com', 'ADMIN', NOW(), NOW());
```

**Option 2: ข้ามขั้นตอนนี้:**
- รัน `sample-data-simple.sql` ได้เลย
- มันจะใช้ User คนแรกที่เจอในระบบ

---

**ตั้งค่า Google OAuth ตามขั้นตอนนี้แล้วจะใช้งานได้ครับ!** 🎉
