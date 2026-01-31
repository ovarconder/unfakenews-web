# 🚨 Fix: Error 500 - Internal Server Error

## ปัญหา
```
POST /api/auth/signin/google → 500 (Internal Server Error)
SyntaxError: Failed to execute 'json' on 'Response': Unexpected end of JSON input
```

## ✅ ความคืบหน้า
- ✅ INVALID_REQUEST_METHOD แก้แล้ว (ลบ rewrite rule ใน vercel.json)
- ✅ Request ไปถึง NextAuth API ได้แล้ว
- ❌ แต่ NextAuth throw error 500

---

## 🔍 สาเหตุที่เป็นไปได้

### 1. Environment Variables ไม่ครบ ⚠️ (สาเหตุหลัก)

**ตรวจสอบใน Vercel:**
```
Settings → Environment Variables
```

**ต้องมีครบทั้งหมด:**
```env
# Database (จำเป็น)
DATABASE_URL=postgresql://...

# Google OAuth (จำเป็น)
GOOGLE_CLIENT_ID=123456789-xxx.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-xxx

# NextAuth (จำเป็น)
NEXTAUTH_URL=https://yourdomain.com
NEXTAUTH_SECRET=xxx (ความยาวอย่างน้อย 32 characters)

# Gemini (optional สำหรับ auth)
GEMINI_API_KEY=AIzaXXX
```

---

## 🛠️ วิธีแก้ไข (ทำตามลำดับ)

### Step 1: ตรวจสอบ Environment Variables ใน Vercel

1. **ไปที่ Vercel Dashboard:**
   ```
   https://vercel.com/[your-account]/[project-name]/settings/environment-variables
   ```

2. **เช็คว่ามีครบไหม:**
   - [ ] `DATABASE_URL`
   - [ ] `GOOGLE_CLIENT_ID`
   - [ ] `GOOGLE_CLIENT_SECRET`
   - [ ] `NEXTAUTH_URL` (ต้อง match กับโดเมน production)
   - [ ] `NEXTAUTH_SECRET`

3. **ถ้าไม่มี `NEXTAUTH_SECRET` ให้ generate:**
   ```bash
   openssl rand -base64 32
   ```
   แล้วเอาผลลัพธ์ไปใส่ใน Vercel

---

### Step 2: ตรวจสอบค่าที่ถูกต้อง

#### ✅ NEXTAUTH_URL ต้องเป็น:
```env
# Production
NEXTAUTH_URL=https://yourdomain.com

# ⚠️ ไม่ใช่:
NEXTAUTH_URL=http://localhost:3000  ❌
NEXTAUTH_URL=https://yourdomain.com/  ❌ (ไม่มี trailing slash)
```

#### ✅ GOOGLE_CLIENT_ID ต้องลงท้ายด้วย:
```
.apps.googleusercontent.com
```

#### ✅ GOOGLE_CLIENT_SECRET ต้องขึ้นต้นด้วย:
```
GOCSPX-
```

#### ✅ NEXTAUTH_SECRET ต้อง:
- ความยาวอย่างน้อย 32 characters
- Generate ด้วย `openssl rand -base64 32`

---

### Step 3: เพิ่ม/อัพเดท Environment Variables

**ใน Vercel Dashboard:**

1. คลิก **Add New**
2. กรอก:
   ```
   Name: NEXTAUTH_SECRET
   Value: [ผลลัพธ์จาก openssl rand -base64 32]
   Environment: Production
   ```
3. คลิก **Save**

4. ทำซ้ำสำหรับตัวแปรอื่นๆ ที่ขาด

5. **Redeploy**:
   ```
   Deployments → Latest → Redeploy
   ```

---

### Step 4: ดู Vercel Logs แบบละเอียด

1. **ไปที่:**
   ```
   https://vercel.com/[account]/[project]/logs
   ```

2. **Filter:**
   - เลือก "All logs"
   - เลือก "Errors"

3. **ค้นหา error message:**
   - หา `/api/auth/signin/google`
   - ดู full stack trace
   - error message น่าจะบอกว่าขาด env variable ตัวไหน

**ตัวอย่าง error ที่อาจเจอ:**
```
Error: GOOGLE_CLIENT_ID is not defined
Error: NEXTAUTH_SECRET is not defined
Error: Database connection failed
```

---

## 🧪 ทดสอบ Environment Variables

### Test 1: ดู Providers API
เปิด browser ไปที่:
```
https://yourdomain.com/api/auth/providers
```

**ถ้าเห็น:**
```json
{
  "google": {
    "id": "google",
    "name": "Google",
    ...
  }
}
```
= Environment variables ถูกต้อง ✅

**ถ้าเห็น:**
```
500 Internal Server Error
```
= Environment variables ผิดหรือขาด ❌

---

### Test 2: ตรวจสอบ Database Connection

เปิด browser console แล้วรัน:
```javascript
fetch('/api/test-db')
  .then(r => r.json())
  .then(d => console.log(d))
  .catch(e => console.error(e));
```

(ถ้าไม่มี endpoint นี้ ไม่ต้องทดสอบ)

---

## 📋 Checklist

### Environment Variables:
- [ ] `GOOGLE_CLIENT_ID` มีค่าและลงท้ายด้วย `.apps.googleusercontent.com`
- [ ] `GOOGLE_CLIENT_SECRET` มีค่าและขึ้นต้นด้วย `GOCSPX-`
- [ ] `NEXTAUTH_URL` = `https://yourdomain.com` (ไม่มี trailing slash)
- [ ] `NEXTAUTH_SECRET` มีความยาว 32+ characters
- [ ] `DATABASE_URL` มีค่าและถูกต้อง
- [ ] ทุกตัวแปรตั้งค่าเป็น **Production** environment
- [ ] **Redeploy** หลังจากเพิ่ม/แก้ env variables

### Google Cloud Console:
- [ ] เพิ่ม Redirect URI: `https://yourdomain.com/api/auth/callback/google`
- [ ] OAuth Consent Screen กรอกข้อมูลครบ
- [ ] Client ID และ Secret copy ถูกต้อง

---

## 🎯 Quick Fix Commands

### 1. Generate NEXTAUTH_SECRET:
```bash
openssl rand -base64 32
```

### 2. ตรวจสอบ env variables (ถ้ารัน local):
```bash
# Pull env variables from Vercel
vercel env pull .env.local

# ตรวจสอบ
cat .env.local | grep NEXTAUTH
cat .env.local | grep GOOGLE
```

### 3. Test Providers API:
```bash
curl https://yourdomain.com/api/auth/providers
```

---

## 💡 ตัวอย่าง Environment Variables ที่ถูกต้อง

```env
# Database
DATABASE_URL="postgresql://user:pass@host:5432/db?schema=public"

# Google OAuth
GOOGLE_CLIENT_ID="123456789-abcdefghijklmnop.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="GOCSPX-abcdefghijklmnopqrstuvwx"

# NextAuth (Production)
NEXTAUTH_URL="https://unfakenews.asia"
NEXTAUTH_SECRET="abcdefghijklmnopqrstuvwxyz123456789ABCDEFGH="

# Public
NEXT_PUBLIC_BASE_URL="https://unfakenews.asia"

# Optional
GEMINI_API_KEY="AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

---

## 🚀 หลังจากแก้แล้ว

1. **Redeploy Vercel**
2. **Clear Browser Cache/Cookies**
3. **ทดสอบ:**
   ```
   https://yourdomain.com/auth/signin
   ```
4. **คลิก "Sign in with Google"**
5. **ควรไปหน้า Google Sign In ได้**

---

## 🔍 ยังไม่ได้?

**ส่งข้อมูลเหล่านี้มา:**

1. **Screenshot หน้า Vercel Environment Variables**
   - (ซ่อน secret values ได้ แค่ต้องการเห็นว่ามีตัวแปรอะไรบ้าง)

2. **Full error log จาก Vercel:**
   - Vercel Dashboard → Logs → filter by `/api/auth`

3. **ผลลัพธ์จาก:**
   ```
   https://yourdomain.com/api/auth/providers
   ```

แล้วผมจะช่วยแก้ต่อครับ!
