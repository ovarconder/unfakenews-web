# 🔧 Fix Google OAuth redirect_uri_mismatch

## ปัญหาที่เจอ:
NextAuth ใช้ Vercel Preview URL แทนที่จะใช้ production domain (`www.unfakenews.asia`)

```
redirect_uri=https://unfakenews-71erslcew-overs-projects-dfca36a0.vercel.app/api/auth/callback/google
```

## ✅ การแก้ไข

### 1. เพิ่ม Environment Variables ใน Vercel

**ไปที่:** Vercel Dashboard → Project → Settings → Environment Variables

**เพิ่ม/อัพเดท:**

```env
NEXTAUTH_URL=https://www.unfakenews.asia
NEXTAUTH_URL_INTERNAL=https://www.unfakenews.asia
NEXT_PUBLIC_BASE_URL=https://www.unfakenews.asia
```

**Environment:** เลือก **All** (Production, Preview, Development)

### 2. อัพเดท auth-options.ts

✅ เพิ่ม `useSecureCookies` แล้ว

### 3. Redeploy

```
Deployments → Latest → Redeploy
```

### 4. ทดสอบ

**ต้องเข้าผ่าน production domain:**
```
https://www.unfakenews.asia/auth/signin
```

**ไม่ใช่ preview URL:**
```
❌ https://unfakenews-71erslcew-....vercel.app
```

---

## 🔍 วิธีตรวจสอบ

### Test redirect_uri ที่ NextAuth กำลังใช้:

```bash
# ใน browser console, กดปุ่ม Google Sign In
# แล้วดู Network tab
# หา request ไปที่ accounts.google.com
# ดู query parameter: redirect_uri

# หรือใช้ curl:
curl -v "https://www.unfakenews.asia/api/auth/signin/google" 2>&1 | grep -i location
```

**ต้องเห็น:**
```
redirect_uri=https%3A%2F%2Fwww.unfakenews.asia%2Fapi%2Fauth%2Fcallback%2Fgoogle
```

**ไม่ใช่:**
```
redirect_uri=https%3A%2F%2Funfakenews-71erslcew-...vercel.app%2F...
```

---

## 📋 Environment Variables ที่ต้องมีครบ

```env
# Database
DATABASE_URL=postgresql://...

# Google OAuth
GOOGLE_CLIENT_ID=791150204849-5hb2k2jcv84mn99adjo5mf7pi0krq1jn.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-...

# NextAuth (สำคัญ!)
NEXTAUTH_URL=https://www.unfakenews.asia
NEXTAUTH_URL_INTERNAL=https://www.unfakenews.asia
NEXTAUTH_SECRET=... (32+ characters)

# Public
NEXT_PUBLIC_BASE_URL=https://www.unfakenews.asia
```

---

## 🎯 Google OAuth Redirect URIs

**ใน Google Cloud Console ต้องมี:**

```
https://unfakenews.asia/api/auth/callback/google
https://www.unfakenews.asia/api/auth/callback/google
```

---

## 💡 Tips

### ถ้ายังใช้ preview URL อยู่:

1. **Clear Vercel cache:**
   ```
   Settings → General → Clear Build Cache → Redeploy
   ```

2. **Clear browser:**
   - Clear cookies
   - Hard reload (Cmd+Shift+R)
   - ลอง Incognito mode

3. **เช็คว่าเข้า production domain จริงๆ:**
   - ใน browser address bar ต้องเป็น `www.unfakenews.asia`
   - ไม่ใช่ `unfakenews-71erslcew-...vercel.app`

4. **เช็ค Vercel deployment:**
   - Deployments tab
   - ดูว่า latest deployment เป็น production (ไม่ใช่ preview)
   - Preview deployments จะไม่ใช้ production env variables

---

## 🚀 ขั้นตอนสุดท้าย

1. ✅ เพิ่ม `NEXTAUTH_URL_INTERNAL` ใน Vercel
2. ✅ Redeploy
3. ✅ รอ 1-2 นาที
4. ✅ Clear browser cache
5. ✅ เข้า `https://www.unfakenews.asia/auth/signin`
6. ✅ คลิก "Sign in with Google"
7. ✅ ควรทำงานได้!

---

**หลังจากทำครบแล้ว Google OAuth จะใช้งานได้!** 🎉
