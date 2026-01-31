# 🔐 Google OAuth URIs Configuration

## For Domain: https://unfakenews.asia

---

## 📝 Authorized JavaScript origins

เพิ่ม **2 URLs** นี้:

```
Development:
http://localhost:3000

Production:
https://unfakenews.asia
```

**คำเตือน:**
- ✅ ใช้ `https://unfakenews.asia` (ไม่มี www)
- ❌ ไม่ใส่ trailing slash: ~~`https://unfakenews.asia/`~~

---

## 📝 Authorized redirect URIs

เพิ่ม **2 URLs** นี้:

```
Development:
http://localhost:3000/api/auth/callback/google

Production:
https://unfakenews.asia/api/auth/callback/google
```

**คำเตือน:**
- ✅ ต้องมี `/api/auth/callback/google` ท้าย URL
- ✅ เขียนเป๊ะทุกตัวอักษร (case-sensitive)
- ❌ ห้ามมี trailing slash ท้าย

---

## 🖼️ ตัวอย่างใน Google Console

### Authorized JavaScript origins:
```
┌─────────────────────────────────────────┐
│ http://localhost:3000                   │ [×]
├─────────────────────────────────────────┤
│ https://unfakenews.asia                 │ [×]
└─────────────────────────────────────────┘
          [+ Add URI]
```

### Authorized redirect URIs:
```
┌──────────────────────────────────────────────────────┐
│ http://localhost:3000/api/auth/callback/google      │ [×]
├──────────────────────────────────────────────────────┤
│ https://unfakenews.asia/api/auth/callback/google    │ [×]
└──────────────────────────────────────────────────────┘
          [+ Add URI]
```

---

## 🎯 Step-by-Step

### 1. ไปที่ Google Cloud Console:
```
https://console.cloud.google.com/apis/credentials
```

### 2. เลือก OAuth 2.0 Client ID ของคุณ

### 3. ใส่ JavaScript origins:
```
- คลิก "+ ADD URI" ใน Authorized JavaScript origins
- ใส่: http://localhost:3000
- คลิก "+ ADD URI" อีกครั้ง
- ใส่: https://unfakenews.asia
```

### 4. ใส่ Redirect URIs:
```
- คลิก "+ ADD URI" ใน Authorized redirect URIs
- ใส่: http://localhost:3000/api/auth/callback/google
- คลิก "+ ADD URI" อีกครั้ง
- ใส่: https://unfakenews.asia/api/auth/callback/google
```

### 5. คลิก "SAVE"

---

## 📋 Environment Variables

### Local Development (.env):
```env
GOOGLE_CLIENT_ID="your-client-id.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="GOCSPX-your-secret"
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-random-32-char-string"
```

### Production (Vercel):
```env
GOOGLE_CLIENT_ID="same-as-above"
GOOGLE_CLIENT_SECRET="same-as-above"
NEXTAUTH_URL="https://unfakenews.asia"
NEXTAUTH_SECRET="same-as-above"
```

---

## ⚠️ Important Notes

### 1. **ใช้ Client ID และ Secret ตัวเดียวกัน**
- Development และ Production ใช้ credentials เดียวกัน
- ไม่ต้องสร้างใหม่

### 2. **www vs non-www**
ถ้าคุณใช้ทั้ง `www.unfakenews.asia` และ `unfakenews.asia`:

**JavaScript origins:**
```
https://unfakenews.asia
https://www.unfakenews.asia
```

**Redirect URIs:**
```
https://unfakenews.asia/api/auth/callback/google
https://www.unfakenews.asia/api/auth/callback/google
```

### 3. **Vercel Redirect**
ถ้าใช้ Vercel, ให้ตั้งค่า redirect www → non-www:

```json
// vercel.json
{
  "redirects": [
    {
      "source": "/:path*",
      "has": [
        {
          "type": "host",
          "value": "www.unfakenews.asia"
        }
      ],
      "destination": "https://unfakenews.asia/:path*",
      "permanent": true
    }
  ]
}
```

---

## 🔍 Troubleshooting

### Error: "redirect_uri_mismatch"

**ปัญหา:** URL ที่ใส่ไม่ตรงกับที่ Google ตั้งไว้

**ตรวจสอบ:**
```
1. ใน Google Console มี:
   https://unfakenews.asia/api/auth/callback/google

2. ใน Vercel Environment Variables มี:
   NEXTAUTH_URL=https://unfakenews.asia

3. ไม่มี trailing slash (/)

4. Protocol ถูกต้อง (https://)
```

---

### Error: "origin_mismatch"

**ปัญหา:** JavaScript origin ไม่ตรง

**แก้ไข:**
```
เพิ่ม https://unfakenews.asia ใน Authorized JavaScript origins
(ไม่ใช่ http://)
```

---

## ✅ Checklist

- [ ] เพิ่ม `http://localhost:3000` ใน JavaScript origins
- [ ] เพิ่ม `https://unfakenews.asia` ใน JavaScript origins
- [ ] เพิ่ม `http://localhost:3000/api/auth/callback/google` ใน Redirect URIs
- [ ] เพิ่ม `https://unfakenews.asia/api/auth/callback/google` ใน Redirect URIs
- [ ] คลิก "SAVE" ใน Google Console
- [ ] รอ 5-10 นาที ให้ Google update
- [ ] ตั้งค่า Environment Variables ใน Vercel
- [ ] Deploy to Vercel
- [ ] Test sign in

---

## 🚀 Complete Setup Summary

```
┌─────────────────────────────────────────────────────┐
│              Google OAuth Client ID                  │
├─────────────────────────────────────────────────────┤
│                                                      │
│ Authorized JavaScript origins:                       │
│   • http://localhost:3000                           │
│   • https://unfakenews.asia                         │
│                                                      │
│ Authorized redirect URIs:                            │
│   • http://localhost:3000/api/auth/callback/google │
│   • https://unfakenews.asia/api/auth/callback/google│
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

## 🎯 Testing

### Local:
```bash
npm run dev
# Visit: http://localhost:3000/auth/signin
# Click "Sign in with Google"
```

### Production:
```
https://unfakenews.asia/auth/signin
Click "Sign in with Google"
```

---

**ตั้งค่าตามนี้แล้วจะใช้ได้ทั้ง development และ production!** ✅
