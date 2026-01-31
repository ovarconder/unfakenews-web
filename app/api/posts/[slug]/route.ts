import { NextRequest, NextResponse } from "next/server";
import { getPostBySlug, incrementPostViews } from "@/lib/db/posts";
import { getLocale, Locale } from "@/lib/i18n";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ slug: string }> }
) {
  try {
    const { slug } = await params;
    const searchParams = request.nextUrl.searchParams;
    const lang = searchParams.get("lang") || "en";
    const locale = getLocale(lang);

    const post = await getPostBySlug(slug, locale);

    if (!post) {
      return NextResponse.json(
        { error: "Post not found" },
        { status: 404 }
      );
    }

    // Increment view count
    await incrementPostViews(slug);

    return NextResponse.json(post);
  } catch (error) {
    console.error("API Error:", error);
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Internal server error" },
      { status: 500 }
    );
  }
}
