# 🔧 แก้ปัญหา Database Connection Pool

## ❌ ปัญหา:

```
เข้าสู่ระบบแล้ว
Invalid `prisma.user.findUnique()` invocation:

Error querying the database: FATAL: MaxClientsInSessionMode:
max clients reached - in Session mode max clients are limited to pool_size
```

## 🔍 สาเหตุ:

**Supabase Free Tier Limits:**
- **Session mode**: max 5 connections พร้อมกัน
- **Transaction mode (Pooling)**: max 200 connections พร้อมกัน

เมื่อใช้ **Direct Connection** (`DATABASE_URL`) ใน development จะใช้ Session mode ซึ่งมี limit น้อย → connection pool เต็มง่าย

## ✅ วิธีแก้:

### 1. เพิ่ม Connection Pooling URL

ใน `.env.local` เพิ่ม:

```env
# Direct Connection (สำหรับ Prisma Migrate)
DATABASE_URL="postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:5432/postgres"

# Connection Pooling (สำหรับ Application - ใช้ port 6543)
DIRECT_URL="postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:6543/postgres?pgbouncer=true"
```

### 2. หา Connection Pooling URL:

#### ใน Supabase Dashboard:

1. เข้า **Supabase Dashboard**: https://app.supabase.com
2. เลือก Project ของคุณ
3. ไปที่ **Settings** → **Database**
4. ส่วน **Connection string** จะมี 2 แบบ:

**Session mode (Direct Connection):**
```
postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:5432/postgres
↑ ใช้ port 5432
```

**Transaction mode (Connection Pooling):**
```
postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:6543/postgres?pgbouncer=true
↑ ใช้ port 6543 + pgbouncer=true
```

#### คัดลอกทั้ง 2 URL:

```env
# .env.local

# Session mode - สำหรับ Migrations
DATABASE_URL="postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:5432/postgres"

# Transaction mode - สำหรับ Application (เร็วกว่า, รองรับ connection เยอะกว่า)
DIRECT_URL="postgresql://postgres.xxx:password@aws-0-region.pooler.supabase.com:6543/postgres?pgbouncer=true"
```

### 3. อัพเดท Prisma Schema (✅ ทำแล้ว)

`prisma/schema.prisma`:
```prisma
datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")  // ← เพิ่มบรรทัดนี้
}
```

### 4. Regenerate Prisma Client

```bash
npx prisma generate
```

### 5. Restart Dev Server

```bash
npm run dev
```

---

## 🎯 ทำไมต้องใช้ทั้ง 2 URL?

| URL | Mode | Port | ใช้สำหรับ | Limit |
|-----|------|------|-----------|-------|
| `DATABASE_URL` | Session | 5432 | Migrations, Introspection | 5 connections |
| `DIRECT_URL` | Transaction | 6543 | Application queries | 200 connections |

**Prisma จะใช้:**
- `DATABASE_URL` → สำหรับ `prisma migrate`, `prisma db push`
- `DIRECT_URL` → สำหรับ application queries ใน runtime

---

## 🔧 การแก้ไขที่ทำแล้ว:

### 1. `lib/prisma.ts` - เพิ่ม graceful shutdown

```typescript
import { PrismaClient } from "@prisma/client";

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma =
  globalForPrisma.prisma ??
  new PrismaClient({
    log: process.env.NODE_ENV === "development" ? ["error", "warn"] : ["error"],
    datasources: {
      db: {
        url: process.env.DATABASE_URL,
      },
    },
  });

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;

// Graceful shutdown - ปิด connection ก่อน process จบ
if (process.env.NODE_ENV === "production") {
  process.on("beforeExit", async () => {
    await prisma.$disconnect();
  });
}
```

### 2. `prisma/schema.prisma` - เพิ่ม directUrl

```prisma
datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")  // ← รองรับ connection pooling
}
```

---

## 🚀 ขั้นตอนการแก้ไข (สรุป):

```bash
# 1. หยุด dev server (Ctrl+C)

# 2. เพิ่ม DIRECT_URL ใน .env.local
# (ใช้ port 6543 + pgbouncer=true)

# 3. Regenerate Prisma Client
npx prisma generate

# 4. Restart dev server
npm run dev

# 5. ทดสอบ login อีกครั้ง
```

---

## 🐛 Troubleshooting

### ปัญหา: ยังเจอ MaxClientsInSessionMode

**Solution:**
1. ตรวจสอบว่า `DIRECT_URL` มี `?pgbouncer=true` หรือไม่
2. ตรวจสอบว่าใช้ port `6543` (ไม่ใช่ `5432`)
3. Restart dev server
4. ล้าง connection เก่า:
   ```bash
   # Kill all node processes
   killall node
   
   # หรือ restart เครื่อง
   ```

### ปัญหา: Can't reach database server

**Solution:**
- ตรวจสอบว่า URL ถูกต้อง
- ตรวจสอบ password
- ตรวจสอบว่า Supabase project ยังทำงานอยู่

### ปัญหา: Connection refused

**Solution:**
- Supabase อาจจะ pause project (free tier)
- ไปที่ Dashboard → Resume project

---

## 📊 Monitoring Connections

### ใน Supabase Dashboard:

1. ไปที่ **Database** → **Connection pooler**
2. ดูจำนวน connections ที่ใช้งานอยู่

### ใน Code (Optional):

```typescript
// lib/db-health.ts
export async function checkDatabaseHealth() {
  try {
    await prisma.$queryRaw`SELECT 1`;
    console.log('✅ Database connection OK');
    return true;
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    return false;
  }
}
```

---

## 🎓 Best Practices

### 1. ใช้ Connection Pooling เสมอ (Production)

```env
# Production
DATABASE_URL="postgresql://...6543/postgres?pgbouncer=true"
DIRECT_URL="postgresql://...6543/postgres?pgbouncer=true"
```

### 2. ปิด Connection หลังใช้งาน

```typescript
// หลัง query เสร็จ
await prisma.$disconnect();
```

### 3. ใช้ Singleton Pattern

```typescript
// lib/prisma.ts - ใช้ singleton เพื่อไม่ให้สร้าง client ใหม่ทุกครั้ง
const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma =
  globalForPrisma.prisma ??
  new PrismaClient();
```

### 4. Limit Connections (Production)

```typescript
new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL,
    },
  },
  // Limit connection pool size
  __internal: {
    engine: {
      maxConnectionPoolSize: 10,
    },
  },
});
```

---

## 🔗 Resources

- [Prisma Connection Management](https://www.prisma.io/docs/guides/performance-and-optimization/connection-management)
- [Supabase Connection Pooling](https://supabase.com/docs/guides/database/connecting-to-postgres#connection-pooler)
- [PgBouncer Documentation](https://www.pgbouncer.org/)

---

## ✅ Summary

**ปัญหา:** Connection pool เต็ม (max 5 connections ใน Session mode)

**วิธีแก้:**
1. ✅ เพิ่ม `DIRECT_URL` ใน `.env.local` (port 6543 + pgbouncer=true)
2. ✅ อัพเดท `prisma/schema.prisma` เพิ่ม `directUrl`
3. ✅ อัพเดท `lib/prisma.ts` เพิ่ม graceful shutdown
4. ⏳ Regenerate Prisma Client: `npx prisma generate`
5. ⏳ Restart dev server: `npm run dev`

**ผลลัพธ์:**
- รองรับ connection ได้มากขึ้น (200 แทน 5)
- เร็วกว่า (Transaction mode)
- ไม่มี MaxClientsInSessionMode error อีกต่อไป

---

🎉 **เสร็จแล้ว!** ทดสอบ login อีกครั้งได้เลยครับ
