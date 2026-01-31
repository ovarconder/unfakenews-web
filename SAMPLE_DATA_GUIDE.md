# 📝 Sample Data - Multiple Languages Guide

## 🎯 Overview

This SQL script creates **3 sample articles** with translations in **10 primary languages**:
- 🇹🇭 Thai (th)
- 🇬🇧 English (en)
- 🇯🇵 Japanese (ja)
- 🇨🇳 Chinese (zh)
- 🇰🇷 Korean (ko)
- 🇪🇸 Spanish (es)
- 🇲🇾 Malay (ms)
- 🇮🇩 Indonesian (id)
- 🇻🇳 Vietnamese (vi)
- 🇵🇭 Filipino (tl)

---

## 📚 Sample Articles

### 1. Breaking Tech News (Technology)
- **Slug:** `breaking-tech-news-2026`
- **Featured:** ✅ Yes
- **Languages:** All 10 languages
- **Topic:** Google's new AI technology

### 2. Global Economy (Business)
- **Slug:** `global-economy-2026`
- **Featured:** ❌ No
- **Languages:** All 10 languages
- **Topic:** Economic growth forecast

### 3. Climate Summit (Politics)
- **Slug:** `climate-summit-2026`
- **Featured:** ✅ Yes
- **Languages:** All 10 languages
- **Topic:** Climate change agreements

---

## 🚀 How to Use

### Option 1: Via Supabase Dashboard

1. **Go to Supabase Dashboard:**
   ```
   https://supabase.com/dashboard/project/[YOUR-PROJECT-ID]
   ```

2. **Open SQL Editor:**
   - Click "SQL Editor" in the left menu
   - Click "New Query"

3. **Paste SQL:**
   - Copy contents from `sample-data-multilang.sql`
   - Paste into the editor
   - Click "Run"

4. **Verify:**
   ```sql
   SELECT COUNT(*) FROM "Post";           -- Should show 3
   SELECT COUNT(*) FROM "PostTranslation"; -- Should show 30
   ```

---

### Option 2: Via Command Line

```bash
# Using psql
psql $DATABASE_URL -f sample-data-multilang.sql

# Or using Supabase CLI
supabase db push < sample-data-multilang.sql
```

---

## ✅ What Gets Created

### User (Admin):
- **Email:** `admin@unfakenews.com`
- **Password:** `admin123` (hashed)
- **Role:** ADMIN
- **Note:** Use this to login and create more posts

### Posts (3):
Each post has:
- Unique slug
- Category (Technology, Business, Politics)
- Featured image
- Published status
- View count

### Translations (30):
Each translation includes:
- **title** - Translated headline
- **excerpt** - Translated summary (for homepage)
- **content** - Basic HTML content
- **seoTitle** - SEO optimized title
- **seoDesc** - SEO description
- **readTime** - Localized read time

---

## 🔍 Testing

### 1. Homepage Test:
```
http://localhost:3000/th    → See Thai articles
http://localhost:3000/en    → See English articles
http://localhost:3000/ja    → See Japanese articles
```

### 2. Language Switch Test:
- Go to Thai homepage
- Click language switcher
- Select English
- ✅ Articles should show in English

### 3. Article Page Test:
```
http://localhost:3000/th/breaking-tech-news-2026
http://localhost:3000/en/breaking-tech-news-2026
http://localhost:3000/ja/breaking-tech-news-2026
```

---

## 📊 Database Structure

```
Post (3 records)
├─ breaking-tech-news-2026
│  ├─ PostTranslation (10 languages)
│  │  ├─ th: "ปัญญาประดิษฐ์ล้ำยุค..."
│  │  ├─ en: "Revolutionary AI..."
│  │  ├─ ja: "革命的AI..."
│  │  └─ ... (7 more)
│
├─ global-economy-2026
│  └─ PostTranslation (10 languages)
│
└─ climate-summit-2026
   └─ PostTranslation (10 languages)
```

---

## 🎨 Customization

### To Add More Languages:

```sql
INSERT INTO "PostTranslation" ("postId", lang, title, content, excerpt, "seoTitle", "seoDesc", "readTime")
VALUES 
  ('post-1', 'fr',  -- French
   'IA Révolutionnaire: Google Dévoile la Prochaine Génération d''IA pour 2026',
   '<p>Google a dévoilé sa dernière technologie d''IA...</p>',
   'Google dévoile sa dernière technologie d''IA...',
   'IA Révolutionnaire: Google Dévoile la Prochaine Génération d''IA',
   'Google dévoile sa dernière technologie d''IA',
   '5 min de lecture', NOW(), NOW());
```

### To Add More Posts:

1. Create a new Post entry
2. Add translations for all languages
3. Use consistent slug format: `topic-name-2026`

---

## 💡 Notes

### Full Content:
- Sample data includes **basic content** only
- When users click to read → Full content will **auto-translate** using Gemini
- This saves database space while ensuring complete translations

### On-Demand Translation:
- **Primary languages (10):** Pre-translated ✅
- **Secondary languages (5):** Auto-translate on first visit 🔄
  - French (fr)
  - German (de)
  - Russian (ru)
  - Portuguese (pt)
  - Arabic (ar)

### Password:
- Admin password is `admin123`
- Change it immediately after first login!

---

## 🔧 Troubleshooting

### "User already exists" error:
```sql
-- Update existing user's role
UPDATE "User" 
SET role = 'ADMIN' 
WHERE email = 'admin@unfakenews.com';
```

### "Post slug already exists":
```sql
-- Delete existing posts first
DELETE FROM "PostTranslation" WHERE "postId" IN ('post-1', 'post-2', 'post-3');
DELETE FROM "Post" WHERE id IN ('post-1', 'post-2', 'post-3');
```

### No articles showing:
```sql
-- Check if posts are published
SELECT id, slug, published FROM "Post";

-- Check translations
SELECT "postId", lang, title FROM "PostTranslation";
```

---

## 🎉 After Running

You should now have:
- ✅ 3 articles visible on homepage
- ✅ Each article available in 10 languages
- ✅ Working language switcher
- ✅ No more empty pages when switching languages!

**Enjoy your multilingual news site!** 🌍
