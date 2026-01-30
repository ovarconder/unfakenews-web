import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");

const ELITE_EDITOR_SYSTEM_PROMPT = `You are an elite multilingual editor working for a prestigious luxury news agency renowned worldwide for its sophisticated, formal, and objective journalism. Your editorial standards are impeccable.

Guidelines:
1. Maintain a sophisticated, formal, and objective tone throughout
2. Use proper journalistic language appropriate for high-end news publications
3. Preserve the original meaning, facts, and intent precisely
4. Adapt cultural references appropriately while maintaining sophistication
5. Ensure SEO metadata is compelling yet maintains editorial standards
6. Never add opinions or commentary - remain strictly objective
7. Use proper grammar, punctuation, and style conventions for the target language

Your output must be in JSON format with the following structure:
{
  "title": "Translated title",
  "content": "Full translated article content with HTML formatting preserved",
  "excerpt": "Brief engaging summary (150-200 characters)",
  "seoTitle": "SEO-optimized title (50-60 characters)",
  "seoDesc": "SEO meta description (150-160 characters)"
}`;

export interface TranslationResult {
  title: string;
  content: string;
  excerpt: string;
  seoTitle: string;
  seoDesc: string;
}

export interface TranslationInput {
  title: string;
  content: string;
  excerpt: string;
}

const LANGUAGE_NAMES: Record<string, string> = {
  th: "Thai (ไทย)",
  en: "English",
  zh: "Chinese (中文)",
  ja: "Japanese (日本語)",
  es: "Spanish (Español)",
  fr: "French (Français)",
  de: "German (Deutsch)",
  ko: "Korean (한국어)",
  ru: "Russian (Русский)",
  pt: "Portuguese (Português)",
  ar: "Arabic (العربية)",
};

export async function translatePost(
  input: TranslationInput,
  targetLang: string
): Promise<TranslationResult> {
  const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash-exp",
    systemInstruction: ELITE_EDITOR_SYSTEM_PROMPT,
  });

  const languageName = LANGUAGE_NAMES[targetLang] || targetLang;

  const prompt = `Translate the following news article to ${languageName} with the highest editorial standards. Return ONLY valid JSON, no additional text or markdown formatting.

Article to translate:
Title: ${input.title}
Excerpt: ${input.excerpt}
Content: ${input.content}

Remember:
- Preserve all HTML tags in the content
- Maintain sophisticated, formal tone
- Be objective and precise
- Create compelling SEO metadata
- Output valid JSON only`;

  try {
    const result = await model.generateContent(prompt);
    const response = result.response;
    const text = response.text();

    // Clean up response - remove markdown code blocks if present
    let jsonText = text.trim();
    if (jsonText.startsWith("```json")) {
      jsonText = jsonText.replace(/```json\n?/g, "").replace(/```\n?/g, "");
    } else if (jsonText.startsWith("```")) {
      jsonText = jsonText.replace(/```\n?/g, "");
    }

    const translation: TranslationResult = JSON.parse(jsonText);

    // Validate the response has all required fields
    if (
      !translation.title ||
      !translation.content ||
      !translation.excerpt ||
      !translation.seoTitle ||
      !translation.seoDesc
    ) {
      throw new Error("Translation response missing required fields");
    }

    return translation;
  } catch (error) {
    console.error("Translation error:", error);
    throw new Error(`Failed to translate content: ${error instanceof Error ? error.message : "Unknown error"}`);
  }
}

export async function calculateReadTime(content: string): Promise<string> {
  // Remove HTML tags and calculate word count
  const text = content.replace(/<[^>]*>/g, "");
  const words = text.trim().split(/\s+/).length;
  const minutes = Math.ceil(words / 200); // Average reading speed: 200 words/min
  return `${minutes} min read`;
}
