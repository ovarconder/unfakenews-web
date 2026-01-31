# ✅ Google OAuth Callback - Complete Setup

## 🎯 What's Created

### 1. **Callback Page** - `/app/auth/callback/page.tsx`
แสดงสถานะการ sign in แบบสวยงาม:
- ⏳ **Loading state** - ขณะกำลัง authenticate
- ✅ **Success state** - เข้าสู่ระบบสำเร็จ
- ❌ **Error state** - เกิดข้อผิดพลาด

### 2. **Error Page** - `/app/auth/error/page.tsx`
แสดงข้อผิดพลาดที่เกิดขึ้น พร้อม:
- รายละเอียด error แต่ละประเภท
- ปุ่มลองใหม่
- ปุ่มกลับหน้าแรก

### 3. **Updated Auth Options** - `/lib/auth-options.ts`
เพิ่ม callbacks:
- `signIn` callback
- `redirect` callback
- Debug mode สำหรับ development
- Session timeout (30 days)

---

## 🔄 How It Works

### Flow Diagram:

```
1. User clicks "Sign in with Google"
   ↓
2. Redirect to Google OAuth
   ↓
3. User grants permission
   ↓
4. Google redirects to: /api/auth/callback/google
   ↓
5. NextAuth processes callback
   ↓
6. Success → Redirect based on role:
   - Admin/Editor → /admin
   - User → /th (homepage)
   
   Error → /auth/error?error=...
```

---

## 📋 URLs in Google Console

### Authorized JavaScript Origins:
```
http://localhost:3000
https://unfakenews.asia
```

### Authorized Redirect URIs:
```
http://localhost:3000/api/auth/callback/google
https://unfakenews.asia/api/auth/callback/google
```

**หมายเหตุ:** 
- NextAuth จัดการ `/api/auth/callback/google` อัตโนมัติ
- ไม่ต้องสร้างไฟล์เพิ่ม
- แค่เพิ่ม URI ใน Google Console

---

## 🎨 Features

### Callback Page:
- ✨ Smooth animations (Framer Motion)
- 🔄 Loading spinner
- ✅ Success checkmark
- ❌ Error icon
- 🎯 Auto-redirect based on role
- 📱 Responsive design

### Error Page:
- 🚨 Error details with descriptions
- 🔄 Retry button
- 🏠 Back to home button
- 📧 Support contact link
- 💡 User-friendly messages

---

## 🔐 Redirect Logic

### After Successful Sign In:

```typescript
// Admin/Editor → Dashboard
if (role === "ADMIN" || role === "SUPER_ADMIN" || role === "EDITOR") {
  redirect("/admin");
}

// Regular User → Homepage
else {
  redirect("/th");
}

// Custom callback URL
if (callbackUrl) {
  redirect(callbackUrl);
}
```

---

## 🧪 Testing

### 1. Test Sign In Flow:

```
1. Go to: http://localhost:3000/auth/signin
2. Click "Sign in with Google"
3. Select Google account
4. Allow permissions
5. Should see callback page with loading
6. Then redirect to /admin or /th
```

### 2. Test Error Handling:

```
# Simulate error
http://localhost:3000/auth/error?error=OAuthSignin

# Try different errors:
- OAuthCallback
- OAuthAccountNotLinked
- AccessDenied
- etc.
```

---

## 📁 File Structure

```
app/
├── auth/
│   ├── callback/
│   │   ├── page.tsx ✨ NEW - Loading/Success page
│   │   └── layout.tsx ✨ NEW - SessionProvider
│   ├── error/
│   │   └── page.tsx ✨ NEW - Error page
│   └── signin/
│       └── page.tsx ✅ Existing
│
├── api/
│   └── auth/
│       └── [...nextauth]/
│           └── route.ts ✅ Existing (handles callback)
│
lib/
└── auth-options.ts 🔄 UPDATED
```

---

## ⚙️ Environment Variables

Make sure you have these in `.env`:

```env
# Google OAuth
GOOGLE_CLIENT_ID="123456789-abc.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="GOCSPX-abc123..."

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-random-secret"

# Database
DATABASE_URL="postgresql://..."
```

---

## 🐛 Debugging

### Enable Debug Mode:

Already enabled in development:
```typescript
debug: process.env.NODE_ENV === "development"
```

### Check NextAuth logs:

```bash
# In terminal where you run npm run dev
# You'll see NextAuth debug logs
```

### Common Issues:

#### 1. "redirect_uri_mismatch"
**Fix:** Add this to Google Console:
```
http://localhost:3000/api/auth/callback/google
```

#### 2. "Configuration error"
**Fix:** Check `.env` file:
```bash
# Make sure these are set:
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
NEXTAUTH_SECRET=...
```

#### 3. "Cannot read properties of undefined"
**Fix:** Restart dev server:
```bash
npm run dev
```

---

## 💡 Customization

### Change Redirect After Sign In:

Edit `/lib/auth-options.ts`:

```typescript
async redirect({ url, baseUrl }) {
  // Always go to dashboard
  return `${baseUrl}/admin`;
  
  // Or homepage
  return `${baseUrl}/th`;
  
  // Or custom logic
  if (user.role === "ADMIN") return `${baseUrl}/admin`;
  return `${baseUrl}/th`;
}
```

### Change Callback Page Design:

Edit `/app/auth/callback/page.tsx`:
- Update colors
- Change icons
- Modify animations
- Add your logo

---

## 🚀 Production Checklist

- [ ] Add production URI to Google Console
- [ ] Set `NEXTAUTH_URL` in Vercel
- [ ] Set `NEXTAUTH_SECRET` in Vercel
- [ ] Set `GOOGLE_CLIENT_ID` in Vercel
- [ ] Set `GOOGLE_CLIENT_SECRET` in Vercel
- [ ] Test sign in on production
- [ ] Test error pages
- [ ] Verify redirects work

---

## 📊 Callback States

| State | Icon | Message | Action |
|-------|------|---------|--------|
| Loading | 🔄 Spinner | "กำลังเข้าสู่ระบบ..." | Wait |
| Success | ✅ Check | "เข้าสู่ระบบสำเร็จ!" | Auto-redirect |
| Error | ❌ X | Error message | Show retry button |

---

## ✅ Summary

**What You Get:**
- ✨ Beautiful callback page with animations
- 🚨 Comprehensive error handling
- 🎯 Smart redirects based on user role
- 📱 Mobile-friendly design
- 🔐 Secure authentication flow
- 🐛 Debug mode for development

**Ready to Use:**
1. Just add URIs to Google Console
2. Set environment variables
3. Test with `npm run dev`
4. Deploy to production!

---

**OAuth callback is now complete and ready to use!** 🎉
