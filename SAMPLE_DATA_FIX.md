# 🔧 Sample Data - Quick Fix Guide

## ⚠️ Problem
Foreign key error: User with id 'sample-author-1' doesn't exist in database.

## ✅ Solution: Use Existing User

### Option 1: Simple Script (Recommended)

Use **`sample-data-simple.sql`** which automatically uses your existing user:

```sql
-- Uses first user in database automatically
(SELECT id FROM "User" LIMIT 1)
```

**Steps:**
1. Open Supabase SQL Editor
2. Copy & paste `sample-data-simple.sql`
3. Click "Run"
4. Done! ✅

---

### Option 2: Create User First

If you don't have any users yet:

#### Via Admin Panel:
```
1. Go to: http://localhost:3000/auth/signin
2. Sign in with Google
3. Your user will be created
4. Then run the SQL script
```

#### Via SQL:
```sql
-- Create a user manually
INSERT INTO "User" (id, name, email, role, "createdAt", "updatedAt")
VALUES 
  ('user-123', 'Your Name', 'your@email.com', 'ADMIN', NOW(), NOW());
```

---

### Option 3: Check Existing Users

Find your existing user ID:

```sql
-- See all users
SELECT id, email, name, role FROM "User";
```

Then use that ID in the sample data script.

---

## 📁 Files

### 1. `sample-data-simple.sql` ⭐ NEW
- **1 article** with **10 languages**
- **Auto-detects existing user**
- No user creation needed
- Quick & simple

### 2. `sample-data-multilang.sql`
- **3 articles** with **10 languages each**
- Tries to create or update user
- More complete sample

---

## 🚀 Quick Start

### Method A: Use Simple Script (Easiest)

```bash
# 1. Make sure you have at least one user
#    (Sign in via Google OAuth first)

# 2. Run simple script
# Copy sample-data-simple.sql to Supabase SQL Editor
# Click "Run"
```

### Method B: Create User Then Use Full Script

```bash
# 1. Create user via Admin panel
http://localhost:3000/auth/signin

# 2. Run full script
# Copy sample-data-multilang.sql to Supabase SQL Editor
# Click "Run"
```

---

## 🔍 Troubleshooting

### Issue: "No user found"

**Check if you have users:**
```sql
SELECT COUNT(*) FROM "User";
```

**If 0:** Sign in first via Google OAuth:
```
http://localhost:3000/auth/signin
```

**If > 0:** Use `sample-data-simple.sql` which auto-detects users

---

### Issue: "User doesn't have ADMIN role"

**Fix:**
```sql
-- Make your user an admin
UPDATE "User" 
SET role = 'ADMIN' 
WHERE email = 'your@email.com';
```

---

### Issue: "Slug already exists"

**Fix:**
```sql
-- Delete existing posts first
DELETE FROM "PostTranslation" WHERE "postId" LIKE 'post-%';
DELETE FROM "Post" WHERE slug LIKE '%-2026';
```

---

## ✅ Verification

After running SQL:

```sql
-- Check posts
SELECT id, slug, published FROM "Post";

-- Check translations
SELECT "postId", lang, title FROM "PostTranslation";

-- Should see:
-- 1 post: breaking-tech-news-2026
-- 10 translations: th, en, ja, zh, ko, es, ms, id, vi, tl
```

---

## 💡 Recommended Flow

```
1. Sign in via Google OAuth
   → http://localhost:3000/auth/signin

2. Your user is created automatically
   → Check: SELECT * FROM "User"

3. Run sample-data-simple.sql
   → In Supabase SQL Editor

4. Verify data
   → Visit: http://localhost:3000/th

5. Done! 🎉
```

---

## 🎯 Summary

| Script | Articles | Languages | User Creation |
|--------|----------|-----------|---------------|
| **sample-data-simple.sql** | 1 | 10 | Auto-detect ✅ |
| sample-data-multilang.sql | 3 | 10 | Tries to create |

**Use `sample-data-simple.sql` for easiest setup!** ⭐

---

**Just sign in first, then run the simple SQL script!** ✅
