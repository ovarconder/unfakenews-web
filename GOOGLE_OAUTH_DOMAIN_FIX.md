# 🔧 แก้ปัญหา Google OAuth ไม่ทำงานบนโดเมนใหม่

## ปัญหา
พอเชื่อมต่อโดเมนแล้ว กดปุ่ม "Sign in with Google" แล้วไม่ไปหน้า Google

---

## สาเหตุ

1. **Middleware redirect ทุก route** รวมถึง `/api/auth/*` ทำให้ NextAuth OAuth callback ใช้งานไม่ได้
2. **Google OAuth Redirect URI ไม่ match** กับโดเมนใหม่
3. **Environment Variable `NEXTAUTH_URL`** ยังเป็น localhost หรือ URL เก่า

---

## ✅ แก้ไขแล้ว (โดย AI)

### 1. แก้ไข Middleware
ผมได้แก้ไข `middleware.ts` ให้ skip `/api/auth/*` และ `/auth/*` routes:

```typescript
// Skip NextAuth API routes
if (pathname.startsWith("/api/auth") || pathname.startsWith("/auth")) {
  return;
}
```

### 2. สร้าง `/app/auth/signin/page.tsx`
ผมได้สร้าง signin page ที่ path `/auth/signin` (ไม่มี `[lang]`) เพื่อให้ NextAuth ทำงานได้ปกติ

---

## 📝 TODO: สิ่งที่ต้องทำต่อ

### 1. เพิ่ม Redirect URI ใน Google Cloud Console

1. **ไปที่ Google Cloud Console:**
   ```
   https://console.cloud.google.com/apis/credentials
   ```

2. **เลือก Project** ที่ใช้งาน

3. **Edit OAuth 2.0 Client ID** ที่ใช้อยู่

4. **เพิ่ม Authorized redirect URIs:**
   ```
   https://your-new-domain.com/api/auth/callback/google
   ```
   
   ตัวอย่าง:
   ```
   https://unfakenews.asia/api/auth/callback/google
   https://www.unfakenews.asia/api/auth/callback/google
   ```

5. **Save**

---

### 2. ตั้งค่า Environment Variables ใน Vercel

1. **ไปที่ Vercel Dashboard:**
   ```
   https://vercel.com/[your-account]/[project-name]/settings/environment-variables
   ```

2. **อัพเดท/เพิ่มตัวแปรเหล่านี้:**

   ```env
   # NextAuth URL (ต้อง match กับโดเมนที่ใช้งาน)
   NEXTAUTH_URL=https://your-new-domain.com
   
   # Google OAuth (ถ้ายังไม่มี)
   GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=GOCSPX-your-client-secret
   
   # NextAuth Secret (generate ใหม่ถ้ายังไม่มี)
   NEXTAUTH_SECRET=your-random-secret-here
   
   # Public Base URL
   NEXT_PUBLIC_BASE_URL=https://your-new-domain.com
   ```

3. **Generate NEXTAUTH_SECRET** (ถ้ายังไม่มี):
   ```bash
   openssl rand -base64 32
   ```

4. **Save** และ **Redeploy**

---

### 3. ตรวจสอบการตั้งค่า

#### ✅ Checklist:

- [ ] Google Cloud Console มี redirect URI สำหรับโดเมนใหม่
  - `https://yourdomain.com/api/auth/callback/google`
- [ ] Vercel มี `NEXTAUTH_URL` ที่ถูกต้อง
- [ ] Vercel มี `GOOGLE_CLIENT_ID` 
- [ ] Vercel มี `GOOGLE_CLIENT_SECRET`
- [ ] Vercel มี `NEXTAUTH_SECRET`
- [ ] Redeploy Vercel
- [ ] ทดสอบ Google Sign In

---

## 🧪 วิธีทดสอบ

### 1. ไปที่หน้า Sign In:
```
https://your-domain.com/auth/signin
```

### 2. คลิก "Sign in with Google"

### 3. ควรเห็น:
- ✅ หน้าจอ Google Sign In popup
- ✅ เลือก Google Account ได้
- ✅ Redirect กลับมาที่ `/auth/callback`
- ✅ จากนั้นไปที่ `/admin` หรือ `/th`

---

## 🔍 Troubleshooting

### ปัญหา: "redirect_uri_mismatch"

**Error:**
```
Error 400: redirect_uri_mismatch
The redirect URI in the request, https://yourdomain.com/api/auth/callback/google, does not match the ones authorized for the OAuth client.
```

**แก้:**
1. ไปที่ Google Cloud Console → Credentials
2. Edit OAuth Client ID
3. เพิ่ม redirect URI ที่ error บอก (exact match)
4. Save
5. รอ 1-2 นาที
6. ลองใหม่

---

### ปัญหา: กด Google แล้วไม่เกิดอะไร

**แก้:**
1. เปิด Browser Console (F12)
2. ดู Network tab
3. คลิก "Sign in with Google"
4. ดูว่า request ไปที่ไหน

**เช็คว่า:**
- URL ควรเป็น `/api/auth/signin/google`
- ควรได้ redirect (302) ไปที่ Google

**ถ้าไม่ได้ redirect:**
- เช็ค NEXTAUTH_URL ใน Vercel
- เช็ค GOOGLE_CLIENT_ID ใน Vercel
- Redeploy Vercel

---

### ปัญหา: หลัง Google Auth แล้ว redirect loop

**แก้:**
```typescript
// lib/auth-options.ts
callbacks: {
  async redirect({ url, baseUrl }) {
    // Fix redirect loop
    if (url.startsWith("/")) return `${baseUrl}${url}`;
    else if (new URL(url).origin === baseUrl) return url;
    return baseUrl;
  },
}
```

---

### ปัญหา: "Configuration" error

**แก้:**
1. เช็คว่า Environment Variables ครบ
2. Redeploy Vercel
3. Clear browser cookies/cache
4. ลองใหม่

---

## 📋 Quick Reference

### Google Cloud Console URLs:
```
Credentials: https://console.cloud.google.com/apis/credentials
OAuth Consent: https://console.cloud.google.com/apis/credentials/consent
```

### Vercel Settings:
```
Environment Variables: https://vercel.com/[account]/[project]/settings/environment-variables
Deployments: https://vercel.com/[account]/[project]
```

### Local Testing:
```bash
# ดู environment variables
vercel env pull .env.local

# Deploy preview
vercel

# Deploy production
vercel --prod
```

---

## 🎯 ตัวอย่าง Environment Variables (Production)

```env
# Database
DATABASE_URL="postgresql://..."

# Google OAuth
GOOGLE_CLIENT_ID="123456789-abcdefg.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="GOCSPX-abc123def456"

# NextAuth
NEXTAUTH_URL="https://unfakenews.asia"
NEXTAUTH_SECRET="super-secret-key-here-32-chars-long"

# Public URLs
NEXT_PUBLIC_BASE_URL="https://unfakenews.asia"
NEXT_PUBLIC_GA_ID="G-XXXXXXXXXX"

# Gemini AI
GEMINI_API_KEY="AIzaSy..."
```

---

## ✅ สรุป

1. ✅ **Code แก้แล้ว** - Middleware skip auth routes
2. ⏳ **ต้องทำเอง** - เพิ่ม redirect URI ใน Google Cloud Console
3. ⏳ **ต้องทำเอง** - อัพเดท NEXTAUTH_URL ใน Vercel
4. ⏳ **ต้องทำเอง** - Redeploy Vercel

**หลังจากทำครบแล้ว Google OAuth จะใช้งานได้ปกติ!** 🎉
