# 🚀 Quick Start - Create Sample Data WITHOUT OAuth

## 📝 สำหรับคนที่ยังไม่ได้ตั้ง Google OAuth

ถ้าคุณยังไม่พร้อมตั้ง Google OAuth สามารถสร้าง User และ Sample Data แบบง่ายๆ ได้เลย!

---

## ✅ Method 1: สร้าง User Manual + Sample Data

### Step 1: สร้าง User

ใน **Supabase SQL Editor** รัน:

```sql
-- สร้าง Admin User
INSERT INTO "User" (id, name, email, role, "createdAt", "updatedAt")
VALUES 
  (
    'admin-user-1', 
    'Admin User', 
    'admin@example.com', 
    'ADMIN', 
    NOW(), 
    NOW()
  );
```

### Step 2: สร้าง Sample Post + Translations

```sql
-- สร้าง Post
INSERT INTO "Post" (id, slug, "authorId", category, image, published, featured, views, "createdAt", "updatedAt")
VALUES 
  (
    'post-1', 
    'breaking-tech-news-2026',
    'admin-user-1',  -- ใช้ User ID จาก Step 1
    'Technology',
    'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200&h=800&fit=crop',
    true,
    true,
    0,
    NOW(),
    NOW()
  );

-- สร้าง Translations (10 ภาษา)
INSERT INTO "PostTranslation" ("postId", lang, title, excerpt, content, "seoTitle", "seoDesc", "readTime")
VALUES 
  -- Thai
  ('post-1', 'th', 
   'ข่าวเทคโนโลยีล่าสุด: AI ที่ทรงพลัง',
   'เทคโนโลยี AI ใหม่ที่จะเปลี่ยนโลก',
   '<p>เนื้อหาบทความภาษาไทย...</p>',
   'ข่าวเทคโนโลยีล่าสุด: AI ที่ทรงพลัง',
   'เทคโนโลยี AI ใหม่ที่จะเปลี่ยนโลก',
   '5 min read'),
   
  -- English
  ('post-1', 'en', 
   'Latest Tech News: Powerful AI',
   'New AI technology that will change the world',
   '<p>Article content in English...</p>',
   'Latest Tech News: Powerful AI',
   'New AI technology that will change the world',
   '5 min read'),
   
  -- Japanese
  ('post-1', 'ja', 
   '最新テクノロジーニュース：強力なAI',
   '世界を変える新しいAI技術',
   '<p>日本語の記事内容...</p>',
   '最新テクノロジーニュース：強力なAI',
   '世界を変える新しいAI技術',
   '5分で読める'),
   
  -- Chinese
  ('post-1', 'zh', 
   '最新科技新闻：强大的AI',
   '将改变世界的新AI技术',
   '<p>中文文章内容...</p>',
   '最新科技新闻：强大的AI',
   '将改变世界的新AI技术',
   '5分钟阅读'),
   
  -- Korean
  ('post-1', 'ko', 
   '최신 기술 뉴스: 강력한 AI',
   '세상을 바꿀 새로운 AI 기술',
   '<p>한국어 기사 내용...</p>',
   '최신 기술 뉴스: 강력한 AI',
   '세상을 바꿀 새로운 AI 기술',
   '5분 소요'),
   
  -- Spanish
  ('post-1', 'es', 
   'Últimas Noticias Tecnológicas: IA Poderosa',
   'Nueva tecnología de IA que cambiará el mundo',
   '<p>Contenido del artículo en español...</p>',
   'Últimas Noticias Tecnológicas: IA Poderosa',
   'Nueva tecnología de IA que cambiará el mundo',
   '5 min de lectura'),
   
  -- Malay
  ('post-1', 'ms', 
   'Berita Teknologi Terkini: AI Yang Berkuasa',
   'Teknologi AI baharu yang akan mengubah dunia',
   '<p>Kandungan artikel dalam Bahasa Melayu...</p>',
   'Berita Teknologi Terkini: AI Yang Berkuasa',
   'Teknologi AI baharu yang akan mengubah dunia',
   '5 min bacaan'),
   
  -- Indonesian
  ('post-1', 'id', 
   'Berita Teknologi Terbaru: AI yang Kuat',
   'Teknologi AI baru yang akan mengubah dunia',
   '<p>Konten artikel dalam Bahasa Indonesia...</p>',
   'Berita Teknologi Terbaru: AI yang Kuat',
   'Teknologi AI baru yang akan mengubah dunia',
   '5 menit baca'),
   
  -- Vietnamese
  ('post-1', 'vi', 
   'Tin Công Nghệ Mới Nhất: AI Mạnh Mẽ',
   'Công nghệ AI mới sẽ thay đổi thế giới',
   '<p>Nội dung bài viết bằng tiếng Việt...</p>',
   'Tin Công Nghệ Mới Nhất: AI Mạnh Mẽ',
   'Công nghệ AI mới sẽ thay đổi thế giới',
   '5 phút đọc'),
   
  -- Filipino
  ('post-1', 'tl', 
   'Pinakabagong Balita sa Teknolohiya: Malakas na AI',
   'Bagong teknolohiya ng AI na magbabago sa mundo',
   '<p>Nilalaman ng artikulo sa Filipino...</p>',
   'Pinakabagong Balita sa Teknolohiya: Malakas na AI',
   'Bagong teknolohiya ng AI na magbabago sa mundo',
   '5 minuto basahin');

-- Success!
SELECT 'User and Sample Data created!' as status;
```

---

## ✅ Method 2: ใช้ Script ที่เตรียมไว้

### Option A: สร้าง User ก่อน

```sql
-- 1. สร้าง User
INSERT INTO "User" (id, name, email, role, "createdAt", "updatedAt")
VALUES ('user-123', 'Your Name', 'you@email.com', 'ADMIN', NOW(), NOW());
```

### Option B: แล้วรัน sample-data-simple.sql

มันจะหา User ที่คุณสร้างอัตโนมัติ!

---

## 🎯 Verify

### 1. Check User:
```sql
SELECT id, email, name, role FROM "User";
```

### 2. Check Posts:
```sql
SELECT id, slug, published FROM "Post";
```

### 3. Check Translations:
```sql
SELECT "postId", lang, title FROM "PostTranslation";
```

### 4. Visit Homepage:
```
http://localhost:3000/th
http://localhost:3000/en
http://localhost:3000/ja
```

---

## 📦 All-in-One Script

ใช้ script นี้ครั้งเดียว สร้างทั้ง User + Post + Translations:

```sql
-- Create User
INSERT INTO "User" (id, name, email, role, "createdAt", "updatedAt")
VALUES ('admin-1', 'Admin', 'admin@example.com', 'ADMIN', NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Create Post
INSERT INTO "Post" (id, slug, "authorId", category, image, published, featured, "createdAt", "updatedAt")
VALUES ('p1', 'tech-news-2026', 'admin-1', 'Technology', 
        'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200&h=800', 
        true, true, NOW(), NOW())
ON CONFLICT (slug) DO NOTHING;

-- Create Translations (10 languages)
INSERT INTO "PostTranslation" ("postId", lang, title, excerpt, content, "seoTitle", "seoDesc", "readTime")
VALUES 
  ('p1', 'th', 'ข่าวเทคโนโลยี', 'สรุปข่าว...', '<p>เนื้อหา...</p>', 'ข่าวเทคโนโลยี', 'สรุป...', '5 min'),
  ('p1', 'en', 'Tech News', 'Summary...', '<p>Content...</p>', 'Tech News', 'Summary...', '5 min'),
  ('p1', 'ja', 'テクニュース', '要約...', '<p>内容...</p>', 'テクニュース', '要約...', '5分'),
  ('p1', 'zh', '科技新闻', '摘要...', '<p>内容...</p>', '科技新闻', '摘要...', '5分钟'),
  ('p1', 'ko', '기술 뉴스', '요약...', '<p>내용...</p>', '기술 뉴스', '요약...', '5분'),
  ('p1', 'es', 'Noticias', 'Resumen...', '<p>Contenido...</p>', 'Noticias', 'Resumen...', '5 min'),
  ('p1', 'ms', 'Berita', 'Ringkasan...', '<p>Kandungan...</p>', 'Berita', 'Ringkasan...', '5 min'),
  ('p1', 'id', 'Berita', 'Ringkasan...', '<p>Konten...</p>', 'Berita', 'Ringkasan...', '5 min'),
  ('p1', 'vi', 'Tin tức', 'Tóm tắt...', '<p>Nội dung...</p>', 'Tin tức', 'Tóm tắt...', '5 phút'),
  ('p1', 'tl', 'Balita', 'Buod...', '<p>Nilalaman...</p>', 'Balita', 'Buod...', '5 min')
ON CONFLICT DO NOTHING;

SELECT 'Done! Visit http://localhost:3000/th' as result;
```

---

## 💡 Summary

| Method | Pros | Time |
|--------|------|------|
| **Manual SQL (Recommended)** | Simple, No OAuth needed | 2 min ⚡ |
| Google OAuth Setup | Production-ready | 15 min |
| sample-data-simple.sql | Complete data | 5 min |

---

**ใช้ Manual SQL ก็พอ ไม่ต้องตั้ง OAuth ก่อนก็ได้!** ✅
