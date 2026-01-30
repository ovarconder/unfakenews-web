# Multi-Language Translation System

## Overview

UnfakeNews features an elite multi-language system powered by Google Gemini AI, supporting 11 languages with on-demand translation, intelligent caching, and advanced SEO optimization.

## Supported Languages

1. **Thai (ไทย)** - `th`
2. **English** - `en` (default)
3. **Chinese (中文)** - `zh`
4. **Japanese (日本語)** - `ja`
5. **Spanish (Español)** - `es`
6. **French (Français)** - `fr`
7. **German (Deutsch)** - `de`
8. **Korean (한국어)** - `ko`
9. **Russian (Русский)** - `ru`
10. **Portuguese (Português)** - `pt`
11. **Arabic (العربية)** - `ar`

## Architecture

### 1. Database Schema (Prisma)

```prisma
model Post {
  id            String            @id @default(cuid())
  slug          String            @unique
  authorId      String
  category      String
  image         String
  published     Boolean           @default(false)
  featured      Boolean           @default(false)
  views         Int               @default(0)
  translations  PostTranslation[]
  createdAt     DateTime          @default(now())
  updatedAt     DateTime          @updatedAt
}

model PostTranslation {
  id        String   @id @default(cuid())
  postId    String
  lang      String   // ISO language code
  title     String
  content   String   @db.Text
  excerpt   String   @db.Text
  seoTitle  String
  seoDesc   String   @db.Text
  readTime  String
  @@unique([postId, lang])
}
```

### 2. Translation Flow

```
User visits article
      ↓
Check DB for translation in requested language
      ↓
Translation exists? → Return from cache
      ↓
Translation missing? → Call Gemini AI
      ↓
Gemini translates with elite editorial standards
      ↓
Save to database (persistent cache)
      ↓
Return translated content
```

### 3. Gemini Translation Engine

Located in `lib/gemini.ts`, the translation engine uses:

- **Model**: `gemini-2.0-flash-exp`
- **System Prompt**: Elite multilingual editor with sophisticated, formal, objective tone
- **Output**: JSON format with title, content, excerpt, seoTitle, seoDesc
- **Quality**: Maintains journalistic standards, preserves HTML, adapts cultural references

### 4. SEO Features

#### Hreflang Tags
Every article page includes proper hreflang tags for all 11 languages:

```typescript
<link rel="alternate" hreflang="th" href="https://domain.com/th/posts/slug" />
<link rel="alternate" hreflang="en" href="https://domain.com/en/posts/slug" />
// ... for all languages
<link rel="alternate" hreflang="x-default" href="https://domain.com/en/posts/slug" />
```

#### Dynamic Sitemap
- Located at `/sitemap.xml`
- Automatically generated from database
- Includes all languages for every post
- Updates with post modification dates
- Supports proper alternate language declarations

#### Metadata
Each translated page includes:
- SEO-optimized title and description
- Open Graph tags for social sharing
- Twitter Card metadata
- Canonical URLs with language alternates
- Proper locale declarations

## Setup Instructions

### 1. Environment Variables

Create `.env` file:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/unfakenews"

# Google Gemini API
GEMINI_API_KEY="your_gemini_api_key_here"

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your_nextauth_secret_here"

# Base URL (production)
NEXT_PUBLIC_BASE_URL="https://yourdomain.com"
```

### 2. Database Setup

```bash
# Generate Prisma client
npx prisma generate

# Run migrations
npx prisma migrate dev --name init

# Optional: Open Prisma Studio
npx prisma studio
```

### 3. Create Initial Content

Create a post with at least one translation (English or Thai):

```typescript
// Example: Create post via Prisma
const post = await prisma.post.create({
  data: {
    slug: "global-tech-summit",
    authorId: "user-id",
    category: "Technology",
    image: "https://...",
    published: true,
    translations: {
      create: {
        lang: "en",
        title: "Global Tech Summit Unveils Revolutionary AI Platform",
        content: "<p>Article content...</p>",
        excerpt: "Brief summary...",
        seoTitle: "Global Tech Summit 2026 | AI Platform Launch",
        seoDesc: "Industry leaders showcase breakthrough AI technologies...",
        readTime: "5 min read",
      },
    },
  },
});
```

### 4. Access Translated Articles

Visit any article in any language:
- English: `/en/posts/global-tech-summit`
- Thai: `/th/posts/global-tech-summit`
- Japanese: `/ja/posts/global-tech-summit`
- etc.

The first visit to a new language triggers AI translation and caching.

## User Interface

### Language Switcher

Two variants available:

1. **Full Switcher** (`LanguageSwitcher`)
   - Shows all 11 languages with native names
   - Displays English translation for clarity
   - Used on article pages

2. **Compact Switcher** (`LanguageSwitcherCompact`)
   - Shows 5 most common languages
   - "More languages..." option
   - Used in navbar

### Typography

- **Thai Text**: Noto Sans Thai (300-700 weights)
- **Headlines**: Noto Serif (elegant serif font)
- **Body**: Inter (clean, modern sans-serif)
- **RTL Support**: Arabic text automatically right-aligned

### Animations

Framer Motion provides:
- Fade-in effects on content load (600ms)
- Smooth transitions between languages
- Staggered animations for article elements
- Exit animations when switching languages

## API Endpoints

### GET `/api/posts/[slug]?lang={locale}`

Returns post with translation in requested language.

**Response:**
```json
{
  "id": "post-id",
  "slug": "article-slug",
  "category": "Technology",
  "image": "https://...",
  "author": {
    "name": "Author Name",
    "email": "author@email.com"
  },
  "translation": {
    "title": "Translated Title",
    "content": "<p>HTML content...</p>",
    "excerpt": "Brief summary...",
    "seoTitle": "SEO Title",
    "seoDesc": "SEO Description",
    "readTime": "5 min read",
    "lang": "ja"
  },
  "createdAt": "2026-01-30T00:00:00.000Z"
}
```

## Translation Quality

### Elite Editor Guidelines

The Gemini AI translator follows strict editorial standards:

1. **Sophisticated Tone**: Maintains luxury news agency voice
2. **Formal Language**: Uses proper journalistic conventions
3. **Objective Reporting**: No opinions or commentary added
4. **Cultural Adaptation**: Adjusts references appropriately
5. **SEO Optimization**: Creates compelling metadata
6. **HTML Preservation**: Maintains all formatting
7. **Fact Accuracy**: Never changes original meaning

### Read Time Calculation

Automatically calculated based on:
- 200 words per minute reading speed
- Strips HTML tags for word count
- Rounds up to nearest minute

## Performance

### Caching Strategy

1. **Database Cache**: All translations stored permanently
2. **First Load**: May take 3-5 seconds (Gemini API call)
3. **Subsequent Loads**: Instant (from database)
4. **Bot Optimization**: Search engines trigger translations during crawl

### Optimization Tips

- Pre-translate popular articles for all languages
- Monitor Gemini API usage and costs
- Use database indexes on `lang` and `slug` fields
- Consider CDN caching for API responses

## Monitoring

### Track Translation Usage

```sql
-- Count translations per language
SELECT lang, COUNT(*) as count 
FROM PostTranslation 
GROUP BY lang;

-- Find untranslated posts for a language
SELECT p.slug 
FROM Post p 
LEFT JOIN PostTranslation pt ON p.id = pt.postId AND pt.lang = 'ja'
WHERE pt.id IS NULL AND p.published = true;
```

### Error Handling

The system gracefully handles:
- Missing Gemini API key (throws error with clear message)
- Database connection issues (returns error response)
- Translation failures (logs error, shows 500 status)
- Invalid language codes (defaults to English)

## Best Practices

1. **Always create English or Thai translation first** - These serve as source for other languages
2. **Review AI translations** - Especially for critical content
3. **Update translations** - When source content changes significantly
4. **Monitor costs** - Track Gemini API usage
5. **Test RTL languages** - Ensure Arabic displays correctly
6. **Validate SEO** - Use Google Search Console to verify hreflang

## Troubleshooting

### Translation Not Working

1. Check `GEMINI_API_KEY` in `.env`
2. Verify database connection
3. Ensure source translation (en/th) exists
4. Check API rate limits
5. Review server logs for errors

### SEO Issues

1. Verify `NEXT_PUBLIC_BASE_URL` is set correctly
2. Check sitemap at `/sitemap.xml`
3. Validate hreflang tags in HTML source
4. Test with Google's Rich Results Test
5. Submit sitemap to Google Search Console

### Font Issues

1. Ensure Google Fonts are loading
2. Check font variables in `layout.tsx`
3. Verify Tailwind config includes font families
4. Test Thai characters display correctly
5. Validate serif fonts on headlines

## Future Enhancements

- [ ] Translation memory to reduce costs
- [ ] Manual translation override interface
- [ ] Translation quality scoring
- [ ] A/B testing for translated content
- [ ] User preference language storage
- [ ] Automatic translation queue for new posts
- [ ] Translation diff viewer for updates
- [ ] Multi-region CDN optimization
- [ ] Voice synthesis for article reading
- [ ] Translation analytics dashboard

## Credits

- **Translation Engine**: Google Gemini 2.0 Flash
- **Fonts**: Google Fonts (Noto Sans Thai, Noto Serif, Inter)
- **Animations**: Framer Motion
- **Database**: PostgreSQL + Prisma ORM
- **Framework**: Next.js 15 with App Router
