import { Metadata } from "next";
import { notFound } from "next/navigation";
import { getPostBySlug } from "@/lib/db/posts";
import { getLocale, locales } from "@/lib/i18n";
import { PostContent } from "./post-content";

export async function generateMetadata({
  params,
}: {
  params: { lang: string; slug: string };
}): Promise<Metadata> {
  const locale = getLocale(params.lang);
  
  try {
    const post = await getPostBySlug(params.slug, locale);

    if (!post) {
      return {
        title: "Post Not Found",
      };
    }

    const baseUrl = process.env.NEXT_PUBLIC_BASE_URL || "http://localhost:3000";
    const currentUrl = `${baseUrl}/${locale}/posts/${params.slug}`;

    // Generate hreflang tags for all supported languages
    const languages: Record<string, string> = {};
    locales.forEach((lang) => {
      languages[lang] = `${baseUrl}/${lang}/posts/${params.slug}`;
    });
    languages["x-default"] = `${baseUrl}/en/posts/${params.slug}`;

    return {
      title: post.translation.seoTitle,
      description: post.translation.seoDesc,
      openGraph: {
        title: post.translation.seoTitle,
        description: post.translation.seoDesc,
        url: currentUrl,
        siteName: "UnfakeNews",
        images: [
          {
            url: post.image,
            width: 1200,
            height: 630,
            alt: post.translation.title,
          },
        ],
        locale: locale,
        type: "article",
        publishedTime: post.createdAt.toISOString(),
        modifiedTime: post.updatedAt.toISOString(),
        authors: [post.author.name || post.author.email],
      },
      twitter: {
        card: "summary_large_image",
        title: post.translation.seoTitle,
        description: post.translation.seoDesc,
        images: [post.image],
      },
      alternates: {
        canonical: currentUrl,
        languages,
      },
    };
  } catch (error) {
    console.error("Error generating metadata:", error);
    return {
      title: "UnfakeNews",
    };
  }
}

export default async function PostPage({
  params,
}: {
  params: { lang: string; slug: string };
}) {
  const locale = getLocale(params.lang);

  try {
    const post = await getPostBySlug(params.slug, locale);

    if (!post) {
      notFound();
    }

    return <PostContent post={post} locale={locale} slug={params.slug} />;
  } catch (error) {
    console.error("Error loading post:", error);
    notFound();
  }
}
