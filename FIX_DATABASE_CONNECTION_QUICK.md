# 🚨 แก้ไข Database Connection Pool Error - Quick Fix

## ❌ Error ที่เจอ:
```
Invalid `prisma.user.findUnique()` invocation:
Error querying the database: FATAL: MaxClientsInSessionMode:
max clients reached
```

---

## ✅ การแก้ไขที่ทำแล้ว:

### 1. แก้ไข `prisma/schema.prisma` ✅
เพิ่ม `directUrl` สำหรับ connection pooling

### 2. แก้ไข `lib/prisma.ts` ✅
เพิ่ม graceful shutdown และ optimize logging

---

## 🔧 ขั้นตอนที่คุณต้องทำ (3 ขั้นตอน):

### 📝 ขั้นตอนที่ 1: เพิ่ม Connection Pooling URL

แก้ไขไฟล์ `.env.local` (หรือ `.env`):

```env
# เดิม (Session mode - port 5432)
DATABASE_URL="postgresql://postgres.xxxxx:password@aws-0-region.pooler.supabase.com:5432/postgres"

# เพิ่มใหม่ (Transaction mode - port 6543 + pgbouncer)
DIRECT_URL="postgresql://postgres.xxxxx:password@aws-0-region.pooler.supabase.com:6543/postgres?pgbouncer=true"
```

**วิธีหา URL:**
1. เข้า https://app.supabase.com
2. Settings → Database
3. ส่วน "Connection string" → เลือก "Transaction"
4. คัดลอก URL (จะเป็น port 6543)
5. เพิ่ม `?pgbouncer=true` ท้าย URL

### ⚙️ ขั้นตอนที่ 2: Regenerate Prisma Client

```bash
npx prisma generate
```

### 🚀 ขั้นตอนที่ 3: Restart Server

```bash
# หยุด server (Ctrl+C)
# แล้วรันใหม่
npm run dev
```

---

## 🎯 เปรียบเทียบ 2 โหมด:

| | Session Mode | Transaction Mode (Pooling) |
|---|---|---|
| **Port** | 5432 | 6543 |
| **Max Connections** | 5 | 200 |
| **Speed** | ช้ากว่า | เร็วกว่า |
| **ใช้สำหรับ** | Migrations | Application |
| **Parameter** | ไม่มี | `?pgbouncer=true` |

---

## 📋 Checklist:

- [ ] เพิ่ม `DIRECT_URL` ใน `.env.local`
- [ ] ตรวจสอบว่าใช้ port **6543** (ไม่ใช่ 5432)
- [ ] ตรวจสอบว่ามี `?pgbouncer=true` ท้าย URL
- [ ] รัน `npx prisma generate`
- [ ] Restart dev server
- [ ] ทดสอบ login อีกครั้ง

---

## 🔍 Example URL:

### ❌ เดิม (Session mode - จะเจอ error):
```env
DATABASE_URL="postgresql://postgres.abc123:mypassword@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres"
```

### ✅ ใหม่ (เพิ่ม Transaction mode):
```env
DATABASE_URL="postgresql://postgres.abc123:mypassword@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres"

DIRECT_URL="postgresql://postgres.abc123:mypassword@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true"
```

**สังเกต:**
- ต่าง port: `5432` vs `6543`
- DIRECT_URL มี `?pgbouncer=true`

---

## 💡 Tips:

### ถ้าไม่มี `.env.local`:
1. Copy จาก `.env`
2. เพิ่ม `DIRECT_URL`
3. `.env.local` จะ override `.env` อัตโนมัติ

### ถ้าใช้ Vercel/Production:
เพิ่ม `DIRECT_URL` ใน Environment Variables ของ hosting ด้วย

---

## 🐛 ถ้ายังเจอ Error:

### 1. ตรวจสอบ URL ถูกต้องหรือไม่:
```bash
# ใน terminal
echo $DIRECT_URL
```

### 2. ล้าง connection เก่า:
```bash
# Kill all node processes
killall node

# หรือ
pkill -f node
```

### 3. Clear cache และ restart:
```bash
rm -rf .next
npm run dev
```

---

## 📚 อ่านเพิ่มเติม:

- `FIX_DATABASE_CONNECTION_POOL.md` - คู่มือละเอียด
- [Supabase Docs: Connection Pooling](https://supabase.com/docs/guides/database/connecting-to-postgres#connection-pooler)

---

## ✅ สรุป:

**ทำอะไรไปบ้าง:**
1. ✅ แก้ไข Prisma schema
2. ✅ แก้ไข Prisma client config
3. ⏳ รอคุณเพิ่ม `DIRECT_URL` ใน `.env.local`

**ทำไมต้องแก้:**
- Supabase free tier จำกัด 5 connections ใน Session mode
- ใช้ Transaction mode (pooling) จะได้ 200 connections
- แก้ปัญหา "max clients reached" ถาวร

**เวลาที่ใช้:** ~2 นาที

---

🎉 **เสร็จแล้ว!** เพิ่ม `DIRECT_URL` แล้วทดสอบ login ใหม่ได้เลยครับ
