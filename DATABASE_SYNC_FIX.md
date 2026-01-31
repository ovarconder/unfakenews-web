# 🔧 Database Schema Sync Guide

## ⚠️ Problem
The database schema is out of sync with your Prisma schema. The `password` column doesn't exist in the database yet.

## ✅ Solution

### Option 1: Push Schema to Database (Recommended)

```bash
# This will sync your database with Prisma schema
npx prisma db push
```

**What it does:**
- Creates missing tables
- Adds missing columns (like `password`)
- Updates existing schema
- **Does NOT create migrations** (good for development)

---

### Option 2: Create and Run Migration

```bash
# Create a migration
npx prisma migrate dev --name add_password_column

# This will:
# 1. Create migration file
# 2. Apply it to database
# 3. Generate Prisma Client
```

---

## 📋 Step-by-Step Instructions

### 1. Sync Database Schema:

```bash
cd /Users/Over-Data/WEB/UnfakeNews
npx prisma db push
```

Expected output:
```
✔ Database schema in sync with Prisma schema
✔ Generated Prisma Client
```

---

### 2. Verify Schema:

```bash
# Check if password column exists
npx prisma studio
```

Or via SQL:
```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'User';
```

---

### 3. Run Sample Data:

Now you can run the sample data SQL:

#### Via Supabase Dashboard:
1. Go to SQL Editor
2. Paste `sample-data-multilang.sql`
3. Click "Run"

#### Via Command Line:
```bash
psql $DATABASE_URL -f sample-data-multilang.sql
```

---

## 🔍 Common Issues

### Issue 1: "Column doesn't exist"

**Cause:** Database schema not synced

**Fix:**
```bash
npx prisma db push
```

---

### Issue 2: "Migration failed"

**Cause:** Database has conflicting data

**Fix:**
```bash
# Reset database (WARNING: Deletes all data)
npx prisma migrate reset

# Or manually drop and recreate
# Then run: npx prisma db push
```

---

### Issue 3: "User already exists"

**Cause:** User with same email already in database

**Fix:** Delete existing user first:
```sql
DELETE FROM "User" WHERE email = 'admin@unfakenews.com';
```

Or skip user creation and just create posts.

---

## 📊 Full Schema Sync Command

```bash
# 1. Push schema
npx prisma db push

# 2. Generate client
npx prisma generate

# 3. Verify with studio
npx prisma studio
```

---

## 🎯 Quick Fix for Your Issue

Run these commands in order:

```bash
# 1. Navigate to project
cd /Users/Over-Data/WEB/UnfakeNews

# 2. Sync database schema
npx prisma db push

# 3. Wait for success message
# ✔ Database schema in sync

# 4. Now run SQL in Supabase Dashboard
# Copy sample-data-multilang.sql and run it
```

---

## ✅ Verification

After syncing, verify with:

```sql
-- Check User table columns
SELECT column_name FROM information_schema.columns 
WHERE table_name = 'User';

-- Should include:
-- id, name, email, emailVerified, image, password, role, createdAt, updatedAt
```

---

## 💡 Notes

- **`prisma db push`** is for development (fast, no migrations)
- **`prisma migrate dev`** is for production (creates migration history)
- Always sync schema before inserting data
- The SQL script now works **with or without** password column

---

**Run `npx prisma db push` first, then run the SQL script!** ✅
