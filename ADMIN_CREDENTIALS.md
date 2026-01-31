# 🔐 Admin Credentials

## Default Admin Account

```
Email: admin@unfakenews.asia
Password: admin123
```

## การเข้าสู่ระบบ

### Easter Egg Access:
1. ไปที่หน้าแรก: `https://www.unfakenews.asia`
2. **คลิกโลโก้ "UnfakeNews" 5 ครั้ง** (ภายใน 2 วินาที)
3. จะเด้งไปหน้า login อัตโนมัติ

### Direct Access:
```
https://www.unfakenews.asia/auth/signin
```

---

## สร้าง Admin User ใหม่

### ผ่าน Supabase SQL Editor:

```sql
-- สร้าง admin user ใหม่
INSERT INTO "User" (
  id, 
  email, 
  name, 
  password, 
  role, 
  "createdAt", 
  "updatedAt"
)
VALUES (
  gen_random_uuid()::text,
  'your-email@example.com',
  'Your Name',
  'your-password',  -- ⚠️ ในการใช้งานจริงควร hash ด้วย bcrypt
  'ADMIN',
  NOW(),
  NOW()
);
```

### Role Types:
- `SUPER_ADMIN` - สิทธิ์สูงสุด
- `ADMIN` - จัดการเนื้อหาได้ทั้งหมด
- `EDITOR` - แก้ไขบทความ
- `USER` - ผู้ใช้ทั่วไป

---

## ⚠️ สำคัญ!

### ก่อน Deploy Production:

1. **เปลี่ยนรหัสผ่าน default:**
   ```sql
   UPDATE "User" 
   SET password = 'new-strong-password'
   WHERE email = 'admin@unfakenews.asia';
   ```

2. **ใช้ bcrypt สำหรับ password hashing:**
   - ตอนนี้ password เก็บเป็น plain text (ไม่ปลอดภัย)
   - ควรเพิ่ม bcrypt hashing ใน `lib/auth-options.ts`

3. **ลบ demo credentials:**
   - ลบ comment ที่บอก email/password ออกจาก signin page

---

## 🔒 Security Best Practices

### 1. Hash Passwords:
```bash
npm install bcryptjs
npm install --save-dev @types/bcryptjs
```

### 2. Update auth-options.ts:
```typescript
import bcrypt from "bcryptjs";

// In authorize function:
const isValid = await bcrypt.compare(
  credentials.password, 
  user.password
);

if (!user || !isValid) {
  throw new Error("Invalid credentials");
}
```

### 3. Hash existing passwords:
```sql
-- ใช้ bcrypt online tool เพื่อ hash password
-- https://bcrypt-generator.com/
-- แล้ว update:
UPDATE "User" 
SET password = '$2a$10$...' -- hashed password
WHERE email = 'admin@unfakenews.asia';
```

---

## 📝 Notes

- Login link ถูกซ่อนจากเมนู (Easter egg: คลิกโลโก้ 5 ครั้ง)
- Google OAuth ถูกปิดการใช้งาน (ใช้ email/password เท่านั้น)
- Admin เท่านั้นที่สามารถเข้าถึง `/admin` dashboard
