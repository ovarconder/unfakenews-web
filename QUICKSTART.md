# Quick Start Guide - Multi-Language System

Get your multi-language news platform running in 5 minutes!

## Prerequisites

- Node.js 18+ installed
- PostgreSQL database (local or cloud)
- Google Gemini API key ([Get it here](https://makersuite.google.com/app/apikey))

## Step-by-Step Setup

### 1. Install Dependencies ✅

Already done! All packages are installed:
- Prisma + PostgreSQL adapter
- Google Generative AI SDK
- Tailwind Typography
- Framer Motion (already included)

### 2. Configure Environment Variables

Create `.env` file in the root directory:

```env
# Database - Replace with your PostgreSQL connection string
DATABASE_URL="postgresql://username:password@localhost:5432/unfakenews?schema=public"

# Google Gemini API Key - Get from: https://makersuite.google.com/app/apikey
GEMINI_API_KEY="your_gemini_api_key_here"

# NextAuth Configuration
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="generate_a_random_secret_here"

# Base URL (use your domain in production)
NEXT_PUBLIC_BASE_URL="http://localhost:3000"
```

**Generate NEXTAUTH_SECRET:**
```bash
openssl rand -base64 32
```

### 3. Setup Database

```bash
# Generate Prisma Client
npm run prisma:generate

# Create database tables
npm run prisma:migrate

# Or use push for quick setup (dev only)
npm run prisma:push
```

### 4. Create Sample Content

Open Prisma Studio to add your first post:

```bash
npm run prisma:studio
```

**In Prisma Studio:**

1. Create a **User** first:
   - email: `admin@unfakenews.com`
   - name: `Admin User`
   - role: `admin`
   - Click Save

2. Create a **Post**:
   - slug: `first-article`
   - category: `Technology`
   - image: `https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200`
   - published: `true`
   - featured: `true`
   - Select the author you created
   - Click Save

3. Create a **PostTranslation** (under the post):
   - Select the post you created
   - lang: `en`
   - title: `Welcome to UnfakeNews`
   - excerpt: `Discover the future of multi-language news publishing`
   - content: 
   ```html
   <p>Welcome to UnfakeNews, your premium multi-language news platform powered by AI translation.</p>
   
   <h2>Features</h2>
   
   <p>Our platform supports 11 languages with on-demand translation, ensuring your content reaches a global audience.</p>
   
   <p>Each article is translated using Google's Gemini AI with elite editorial standards, maintaining sophisticated tone and journalistic quality.</p>
   ```
   - seoTitle: `Welcome to UnfakeNews | Multi-Language News`
   - seoDesc: `Discover premium multi-language news publishing with AI-powered translation supporting 11 languages.`
   - readTime: `3 min read`
   - Click Save

### 5. Run Development Server

```bash
npm run dev
```

### 6. Test Translation System

Open your browser and visit:

1. **English Version:**
   ```
   http://localhost:3000/en/posts/first-article
   ```

2. **Thai Version** (triggers AI translation):
   ```
   http://localhost:3000/th/posts/first-article
   ```
   - First load: 3-5 seconds (AI translation)
   - Subsequent loads: Instant (cached in database)

3. **Japanese Version:**
   ```
   http://localhost:3000/ja/posts/first-article
   ```

4. **Try all languages:**
   - Use the language switcher in the top-right corner
   - Each language is translated and cached automatically

### 7. Verify SEO Setup

1. **View Hreflang Tags:**
   - Right-click → View Page Source
   - Search for "hreflang"
   - Should see links for all 11 languages

2. **Check Sitemap:**
   ```
   http://localhost:3000/sitemap.xml
   ```

3. **Check Robots:**
   ```
   http://localhost:3000/robots.txt
   ```

## Common Commands

```bash
# Development
npm run dev                    # Start dev server
npm run build                  # Build for production
npm run start                  # Start production server

# Database
npm run prisma:studio          # Open database GUI
npm run prisma:generate        # Generate Prisma client
npm run prisma:migrate         # Run migrations
npm run prisma:push            # Push schema changes

# Linting
npm run lint                   # Check code quality
```

## Testing Checklist

- [ ] Environment variables configured
- [ ] Database connected
- [ ] Sample user created
- [ ] Sample post created
- [ ] English translation exists
- [ ] Dev server running
- [ ] Can access article in English
- [ ] Thai translation works (AI generates it)
- [ ] Language switcher appears
- [ ] Hreflang tags in page source
- [ ] Sitemap accessible
- [ ] Framer Motion animations working

## Troubleshooting

### Database Connection Failed
```bash
# Check PostgreSQL is running
psql -U postgres

# Test connection string
psql "postgresql://username:password@localhost:5432/unfakenews"
```

### Prisma Client Error
```bash
# Regenerate Prisma client
npm run prisma:generate

# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Translation Not Working

1. Check Gemini API key is valid
2. Visit Google AI Studio: https://makersuite.google.com/
3. Check API quotas and billing
4. Review server console for errors

### Fonts Not Loading

1. Clear browser cache
2. Check internet connection (fonts load from Google CDN)
3. Verify font imports in `app/layout.tsx`

## Next Steps

### Add More Content

Create more posts via Prisma Studio or build an admin interface.

### Customize Styling

- Edit `app/globals.css` for global styles
- Modify `tailwind.config.ts` for theme
- Update `components/` for component styles

### Deploy to Production

**Recommended: Vercel**

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

**Environment Variables for Production:**
- Add all `.env` variables in Vercel dashboard
- Update `NEXT_PUBLIC_BASE_URL` to your domain
- Use managed PostgreSQL (Vercel Postgres, Supabase, etc.)

### Monitor Usage

1. **Google Cloud Console:**
   - Monitor Gemini API usage
   - Check costs and quotas
   - Set up billing alerts

2. **Database:**
   - Monitor translation count per language
   - Track most translated articles
   - Optimize slow queries

### Pre-translate Popular Content

For high-traffic articles, pre-translate to all languages:

```typescript
import { prisma } from '@/lib/prisma';
import { translatePost } from '@/lib/gemini';

async function preTranslatePost(slug: string) {
  const languages = ['th', 'zh', 'ja', 'es', 'fr', 'de', 'ko', 'ru', 'pt', 'ar'];
  
  for (const lang of languages) {
    // This will trigger translation if not exists
    await getPostBySlug(slug, lang);
  }
}
```

## Support

For detailed documentation:
- `MULTILANGUAGE_SETUP.md` - Full system documentation
- `IMPLEMENTATION_SUMMARY.md` - Implementation details
- Inline code comments

## 🎉 You're Ready!

Your multi-language news platform is now running with:
- ✅ 11 languages supported
- ✅ AI-powered translation
- ✅ Advanced SEO with hreflang
- ✅ Beautiful UI with animations
- ✅ Smart caching system
- ✅ Production-ready architecture

Start creating content and watch it automatically translate to 11 languages! 🚀
