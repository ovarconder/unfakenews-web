import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const postId = searchParams.get("postId");
    const lang = searchParams.get("lang");

    if (!postId || !lang) {
      return NextResponse.json(
        { error: "Missing postId or lang parameter" },
        { status: 400 }
      );
    }

    // Find the post with the requested language
    const post = await prisma.post.findFirst({
      where: {
        originalPostId: postId,
        language: lang,
      },
      select: {
        slug: true,
      },
    });

    // If no translation found, try to find the original post
    if (!post) {
      const originalPost = await prisma.post.findFirst({
        where: {
          id: postId,
          language: lang,
        },
        select: {
          slug: true,
        },
      });

      if (originalPost) {
        return NextResponse.json({ slug: originalPost.slug });
      }

      return NextResponse.json(
        { error: "Translation not found" },
        { status: 404 }
      );
    }

    return NextResponse.json({ slug: post.slug });
  } catch (error) {
    console.error("Error fetching slug:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
