-- ======================================
-- Simple Sample Data - Using Existing User
-- ======================================

-- This script uses your existing user from the database
-- No need to create a new user!

-- Step 1: Get your existing user ID
-- Run this query first to see your user:
-- SELECT id, email, name, role FROM "User" LIMIT 1;

-- Step 2: Replace 'YOUR_USER_ID' below with your actual user ID

-- ======================================
-- Post 1: Breaking Tech News
-- ======================================

INSERT INTO "Post" (id, slug, "authorId", category, image, published, featured, views, "createdAt", "updatedAt")
VALUES 
  ('post-tech-1', 'breaking-tech-news-2026', 
   (SELECT id FROM "User" LIMIT 1), -- Uses first user in database
   'Technology', 
   'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200&h=800&fit=crop', 
   true, true, 0, NOW(), NOW())
ON CONFLICT (slug) DO UPDATE 
SET "updatedAt" = NOW();

-- Translations for Post 1
INSERT INTO "PostTranslation" ("postId", lang, title, content, excerpt, "seoTitle", "seoDesc", "readTime", "createdAt", "updatedAt")
VALUES 
  -- Thai
  ('post-tech-1', 'th', 
   'ปัญญาประดิษฐ์ล้ำยุค: Google เปิดตัว AI รุ่นใหม่ปี 2026',
   '<p>Google ได้เปิดตัวเทคโนโลยี AI รุ่นใหม่ที่มีความสามารถในการเรียนรู้และตอบสนองที่ก้าวหน้ากว่าเดิมอย่างมาก</p><h2>ความสามารถใหม่</h2><p>AI รุ่นใหม่นี้สามารถเข้าใจบริบทที่ซับซ้อน ตอบคำถามที่ต้องการการคิดวิเคราะห์ และสร้างเนื้อหาที่มีคุณภาพสูง</p>',
   'Google เปิดตัวเทคโนโลยี AI รุ่นใหม่ล่าสุด พร้อมความสามารถที่ก้าวหน้ากว่าเดิมอย่างมาก คาดว่าจะเปลี่ยนแปลงวงการเทคโนโลยีในปี 2026',
   'ปัญญาประดิษฐ์ล้ำยุค: Google เปิดตัว AI รุ่นใหม่ปี 2026',
   'Google เปิดตัวเทคโนโลยี AI รุ่นใหม่ล่าสุด พร้อมความสามารถที่ก้าวหน้ากว่าเดิมอย่างมาก',
   '5 min read', NOW(), NOW()),
   
  -- English
  ('post-tech-1', 'en', 
   'Revolutionary AI: Google Unveils Next-Gen AI for 2026',
   '<p>Google has unveiled its latest AI technology with significantly advanced learning and response capabilities.</p><h2>New Capabilities</h2><p>This new AI can understand complex contexts, answer questions requiring analytical thinking, and generate high-quality content.</p>',
   'Google unveils its latest AI technology with significantly advanced capabilities, expected to transform the tech industry in 2026',
   'Revolutionary AI: Google Unveils Next-Gen AI for 2026',
   'Google unveils its latest AI technology with significantly advanced capabilities',
   '5 min read', NOW(), NOW()),
   
  -- Japanese
  ('post-tech-1', 'ja', 
   '革命的AI：Googleが2026年向け次世代AIを発表',
   '<p>Googleは、大幅に進化した学習と応答能力を持つ最新のAI技術を発表しました。</p><h2>新機能</h2><p>この新しいAIは、複雑な文脈を理解し、分析的思考を必要とする質問に答え、高品質なコンテンツを生成できます。</p>',
   'Googleが大幅に進化した機能を持つ最新のAI技術を発表。2026年のテクノロジー業界を変革すると予想されています',
   '革命的AI：Googleが2026年向け次世代AIを発表',
   'Googleが大幅に進化した機能を持つ最新のAI技術を発表',
   '5分で読める', NOW(), NOW()),
   
  -- Chinese
  ('post-tech-1', 'zh', 
   '革命性AI：谷歌发布2026年下一代AI',
   '<p>谷歌发布了其最新的AI技术，具有显著提升的学习和响应能力。</p><h2>新功能</h2><p>这款新AI能够理解复杂的上下文，回答需要分析思维的问题，并生成高质量的内容。</p>',
   '谷歌发布其最新AI技术，具有显著提升的能力，预计将在2026年改变科技行业',
   '革命性AI：谷歌发布2026年下一代AI',
   '谷歌发布其最新AI技术，具有显著提升的能力',
   '5分钟阅读', NOW(), NOW()),
   
  -- Korean
  ('post-tech-1', 'ko', 
   '혁명적 AI: 구글, 2026년 차세대 AI 공개',
   '<p>구글이 크게 향상된 학습 및 응답 능력을 갖춘 최신 AI 기술을 공개했습니다.</p><h2>새로운 기능</h2><p>이 새로운 AI는 복잡한 맥락을 이해하고, 분석적 사고가 필요한 질문에 답하며, 고품질 콘텐츠를 생성할 수 있습니다.</p>',
   '구글이 크게 향상된 기능을 갖춘 최신 AI 기술을 공개했으며, 2026년 기술 산업을 변화시킬 것으로 예상됩니다',
   '혁명적 AI: 구글, 2026년 차세대 AI 공개',
   '구글이 크게 향상된 기능을 갖춘 최신 AI 기술을 공개',
   '5분 소요', NOW(), NOW()),
   
  -- Spanish
  ('post-tech-1', 'es', 
   'IA Revolucionaria: Google Presenta la Próxima Generación de IA para 2026',
   '<p>Google ha presentado su última tecnología de IA con capacidades de aprendizaje y respuesta significativamente avanzadas.</p><h2>Nuevas Capacidades</h2><p>Esta nueva IA puede entender contextos complejos, responder preguntas que requieren pensamiento analítico y generar contenido de alta calidad.</p>',
   'Google presenta su última tecnología de IA con capacidades significativamente avanzadas',
   'IA Revolucionaria: Google Presenta la Próxima Generación de IA para 2026',
   'Google presenta su última tecnología de IA con capacidades avanzadas',
   '5 min de lectura', NOW(), NOW()),
   
  -- Malay
  ('post-tech-1', 'ms', 
   'AI Revolusioner: Google Melancarkan AI Generasi Seterusnya untuk 2026',
   '<p>Google telah melancarkan teknologi AI terkini dengan keupayaan pembelajaran dan tindak balas yang jauh lebih maju.</p>',
   'Google melancarkan teknologi AI terkini dengan keupayaan yang jauh lebih maju',
   'AI Revolusioner: Google Melancarkan AI Generasi Seterusnya untuk 2026',
   'Google melancarkan teknologi AI terkini',
   '5 min bacaan', NOW(), NOW()),
   
  -- Indonesian
  ('post-tech-1', 'id', 
   'AI Revolusioner: Google Meluncurkan AI Generasi Berikutnya untuk 2026',
   '<p>Google telah meluncurkan teknologi AI terbaru dengan kemampuan pembelajaran dan respons yang jauh lebih maju.</p>',
   'Google meluncurkan teknologi AI terbaru dengan kemampuan yang jauh lebih maju',
   'AI Revolusioner: Google Meluncurkan AI Generasi Berikutnya untuk 2026',
   'Google meluncurkan teknologi AI terbaru',
   '5 menit baca', NOW(), NOW()),
   
  -- Vietnamese
  ('post-tech-1', 'vi', 
   'AI Cách Mạng: Google Ra Mắt AI Thế Hệ Tiếp Theo Cho 2026',
   '<p>Google đã ra mắt công nghệ AI mới nhất với khả năng học tập và phản hồi tiên tiến hơn đáng kể.</p>',
   'Google ra mắt công nghệ AI mới nhất với khả năng tiên tiến hơn đáng kể',
   'AI Cách Mạng: Google Ra Mắt AI Thế Hệ Tiếp Theo Cho 2026',
   'Google ra mắt công nghệ AI mới nhất',
   '5 phút đọc', NOW(), NOW()),
   
  -- Filipino
  ('post-tech-1', 'tl', 
   'Rebolusyonaryong AI: Inilabas ng Google ang Susunod na Henerasyong AI para sa 2026',
   '<p>Inilabas ng Google ang pinakabagong teknolohiya ng AI na may makabuluhang advanced na kakayahan.</p>',
   'Inilabas ng Google ang pinakabagong teknolohiya ng AI',
   'Rebolusyonaryong AI: Inilabas ng Google ang Susunod na Henerasyong AI para sa 2026',
   'Inilabas ng Google ang pinakabagong teknolohiya ng AI',
   '5 minuto basahin', NOW(), NOW())
ON CONFLICT ("postId", lang) DO UPDATE 
SET "updatedAt" = NOW();

-- Success message
SELECT 'Sample data created successfully!' as result;
SELECT 'Post ID: post-tech-1' as post_created;
SELECT COUNT(*) as translations_created FROM "PostTranslation" WHERE "postId" = 'post-tech-1';
