-- ======================================
-- Sample Data with Multiple Languages
-- ======================================

-- First, create a sample user or use existing user
DO $$
BEGIN
  -- Try to insert new user
  INSERT INTO "User" (id, name, email, "emailVerified", image, role, "createdAt", "updatedAt")
  VALUES 
    ('sample-author-1', 'Admin User', 'admin@unfakenews.com', NOW(), NULL, 'ADMIN', NOW(), NOW())
  ON CONFLICT (email) DO UPDATE 
  SET 
    id = 'sample-author-1',
    role = 'ADMIN',
    "updatedAt" = NOW();
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'User creation skipped or updated';
END $$;

-- Verify user exists
DO $$
DECLARE
  user_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO user_count FROM "User" WHERE id = 'sample-author-1' OR email = 'admin@unfakenews.com';
  
  IF user_count = 0 THEN
    RAISE EXCEPTION 'No user found. Please create a user first via Admin panel or run: npx prisma db seed';
  END IF;
  
  RAISE NOTICE 'User found: % user(s)', user_count;
END $$;

-- ======================================
-- Post 1: Breaking Tech News
-- ======================================

INSERT INTO "Post" (id, slug, "authorId", category, image, published, featured, views, "createdAt", "updatedAt")
VALUES 
  ('post-1', 'breaking-tech-news-2026', 'sample-author-1', 'Technology', 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200&h=800&fit=crop', true, true, 0, NOW(), NOW())
ON CONFLICT (slug) DO NOTHING;

-- Translations for Post 1
INSERT INTO "PostTranslation" ("postId", lang, title, content, excerpt, "seoTitle", "seoDesc", "readTime", "createdAt", "updatedAt")
VALUES 
  -- Thai
  ('post-1', 'th', 
   'ปัญญาประดิษฐ์ล้ำยุค: Google เปิดตัว AI รุ่นใหม่ปี 2026',
   '<p>Google ได้เปิดตัวเทคโนโลยี AI รุ่นใหม่ที่มีความสามารถในการเรียนรู้และตอบสนองที่ก้าวหน้ากว่าเดิมอย่างมาก</p><h2>ความสามารถใหม่</h2><p>AI รุ่นใหม่นี้สามารถเข้าใจบริบทที่ซับซ้อน ตอบคำถามที่ต้องการการคิดวิเคราะห์ และสร้างเนื้อหาที่มีคุณภาพสูง</p>',
   'Google เปิดตัวเทคโนโลยี AI รุ่นใหม่ล่าสุด พร้อมความสามารถที่ก้าวหน้ากว่าเดิมอย่างมาก คาดว่าจะเปลี่ยนแปลงวงการเทคโนโลยีในปี 2026',
   'ปัญญาประดิษฐ์ล้ำยุค: Google เปิดตัว AI รุ่นใหม่ปี 2026',
   'Google เปิดตัวเทคโนโลยี AI รุ่นใหม่ล่าสุด พร้อมความสามารถที่ก้าวหน้ากว่าเดิมอย่างมาก คาดว่าจะเปลี่ยนแปลงวงการเทคโนโลยีในปี 2026',
   '5 min read', NOW(), NOW()),
   
  -- English
  ('post-1', 'en', 
   'Revolutionary AI: Google Unveils Next-Gen AI for 2026',
   '<p>Google has unveiled its latest AI technology with significantly advanced learning and response capabilities.</p><h2>New Capabilities</h2><p>This new AI can understand complex contexts, answer questions requiring analytical thinking, and generate high-quality content.</p>',
   'Google unveils its latest AI technology with significantly advanced capabilities, expected to transform the tech industry in 2026',
   'Revolutionary AI: Google Unveils Next-Gen AI for 2026',
   'Google unveils its latest AI technology with significantly advanced capabilities, expected to transform the tech industry in 2026',
   '5 min read', NOW(), NOW()),
   
  -- Japanese
  ('post-1', 'ja', 
   '革命的AI：Googleが2026年向け次世代AIを発表',
   '<p>Googleは、大幅に進化した学習と応答能力を持つ最新のAI技術を発表しました。</p><h2>新機能</h2><p>この新しいAIは、複雑な文脈を理解し、分析的思考を必要とする質問に答え、高品質なコンテンツを生成できます。</p>',
   'Googleが大幅に進化した機能を持つ最新のAI技術を発表。2026年のテクノロジー業界を変革すると予想されています',
   '革命的AI：Googleが2026年向け次世代AIを発表',
   'Googleが大幅に進化した機能を持つ最新のAI技術を発表。2026年のテクノロジー業界を変革すると予想されています',
   '5分で読める', NOW(), NOW()),
   
  -- Chinese
  ('post-1', 'zh', 
   '革命性AI：谷歌发布2026年下一代AI',
   '<p>谷歌发布了其最新的AI技术，具有显著提升的学习和响应能力。</p><h2>新功能</h2><p>这款新AI能够理解复杂的上下文，回答需要分析思维的问题，并生成高质量的内容。</p>',
   '谷歌发布其最新AI技术，具有显著提升的能力，预计将在2026年改变科技行业',
   '革命性AI：谷歌发布2026年下一代AI',
   '谷歌发布其最新AI技术，具有显著提升的能力，预计将在2026年改变科技行业',
   '5分钟阅读', NOW(), NOW()),
   
  -- Korean
  ('post-1', 'ko', 
   '혁명적 AI: 구글, 2026년 차세대 AI 공개',
   '<p>구글이 크게 향상된 학습 및 응답 능력을 갖춘 최신 AI 기술을 공개했습니다.</p><h2>새로운 기능</h2><p>이 새로운 AI는 복잡한 맥락을 이해하고, 분석적 사고가 필요한 질문에 답하며, 고품질 콘텐츠를 생성할 수 있습니다.</p>',
   '구글이 크게 향상된 기능을 갖춘 최신 AI 기술을 공개했으며, 2026년 기술 산업을 변화시킬 것으로 예상됩니다',
   '혁명적 AI: 구글, 2026년 차세대 AI 공개',
   '구글이 크게 향상된 기능을 갖춘 최신 AI 기술을 공개했으며, 2026년 기술 산업을 변화시킬 것으로 예상됩니다',
   '5분 소요', NOW(), NOW()),
   
  -- Spanish
  ('post-1', 'es', 
   'IA Revolucionaria: Google Presenta la Próxima Generación de IA para 2026',
   '<p>Google ha presentado su última tecnología de IA con capacidades de aprendizaje y respuesta significativamente avanzadas.</p><h2>Nuevas Capacidades</h2><p>Esta nueva IA puede entender contextos complejos, responder preguntas que requieren pensamiento analítico y generar contenido de alta calidad.</p>',
   'Google presenta su última tecnología de IA con capacidades significativamente avanzadas, que se espera transforme la industria tecnológica en 2026',
   'IA Revolucionaria: Google Presenta la Próxima Generación de IA para 2026',
   'Google presenta su última tecnología de IA con capacidades significativamente avanzadas, que se espera transforme la industria tecnológica en 2026',
   '5 min de lectura', NOW(), NOW()),
   
  -- Malay
  ('post-1', 'ms', 
   'AI Revolusioner: Google Melancarkan AI Generasi Seterusnya untuk 2026',
   '<p>Google telah melancarkan teknologi AI terkini dengan keupayaan pembelajaran dan tindak balas yang jauh lebih maju.</p><h2>Keupayaan Baharu</h2><p>AI baharu ini boleh memahami konteks yang kompleks, menjawab soalan yang memerlukan pemikiran analitikal, dan menghasilkan kandungan berkualiti tinggi.</p>',
   'Google melancarkan teknologi AI terkini dengan keupayaan yang jauh lebih maju, dijangka mengubah industri teknologi pada 2026',
   'AI Revolusioner: Google Melancarkan AI Generasi Seterusnya untuk 2026',
   'Google melancarkan teknologi AI terkini dengan keupayaan yang jauh lebih maju, dijangka mengubah industri teknologi pada 2026',
   '5 min bacaan', NOW(), NOW()),
   
  -- Indonesian
  ('post-1', 'id', 
   'AI Revolusioner: Google Meluncurkan AI Generasi Berikutnya untuk 2026',
   '<p>Google telah meluncurkan teknologi AI terbaru dengan kemampuan pembelajaran dan respons yang jauh lebih maju.</p><h2>Kemampuan Baru</h2><p>AI baru ini dapat memahami konteks yang kompleks, menjawab pertanyaan yang memerlukan pemikiran analitis, dan menghasilkan konten berkualitas tinggi.</p>',
   'Google meluncurkan teknologi AI terbaru dengan kemampuan yang jauh lebih maju, diperkirakan akan mengubah industri teknologi di 2026',
   'AI Revolusioner: Google Meluncurkan AI Generasi Berikutnya untuk 2026',
   'Google meluncurkan teknologi AI terbaru dengan kemampuan yang jauh lebih maju, diperkirakan akan mengubah industri teknologi di 2026',
   '5 menit baca', NOW(), NOW()),
   
  -- Vietnamese
  ('post-1', 'vi', 
   'AI Cách Mạng: Google Ra Mắt AI Thế Hệ Tiếp Theo Cho 2026',
   '<p>Google đã ra mắt công nghệ AI mới nhất với khả năng học tập và phản hồi tiên tiến hơn đáng kể.</p><h2>Khả Năng Mới</h2><p>AI mới này có thể hiểu các ngữ cảnh phức tạp, trả lời các câu hỏi đòi hỏi tư duy phân tích và tạo nội dung chất lượng cao.</p>',
   'Google ra mắt công nghệ AI mới nhất với khả năng tiên tiến hơn đáng kể, dự kiến sẽ thay đổi ngành công nghệ vào năm 2026',
   'AI Cách Mạng: Google Ra Mắt AI Thế Hệ Tiếp Theo Cho 2026',
   'Google ra mắt công nghệ AI mới nhất với khả năng tiên tiến hơn đáng kể, dự kiến sẽ thay đổi ngành công nghệ vào năm 2026',
   '5 phút đọc', NOW(), NOW()),
   
  -- Filipino
  ('post-1', 'tl', 
   'Rebolusyonaryong AI: Inilabas ng Google ang Susunod na Henerasyong AI para sa 2026',
   '<p>Inilabas ng Google ang pinakabagong teknolohiya ng AI na may makabuluhang advanced na kakayahan sa pag-aaral at pagtugon.</p><h2>Mga Bagong Kakayahan</h2><p>Ang bagong AI na ito ay maaaring maunawaan ang mga komplikadong konteksto, sagutin ang mga tanong na nangangailangan ng analytical thinking, at lumikha ng de-kalidad na nilalaman.</p>',
   'Inilabas ng Google ang pinakabagong teknolohiya ng AI na may makabuluhang advanced na kakayahan, inaasahang magbabago sa industriya ng teknolohiya sa 2026',
   'Rebolusyonaryong AI: Inilabas ng Google ang Susunod na Henerasyong AI para sa 2026',
   'Inilabas ng Google ang pinakabagong teknolohiya ng AI na may makabuluhang advanced na kakayahan, inaasahang magbabago sa industriya ng teknolohiya sa 2026',
   '5 minuto basahin', NOW(), NOW())
ON CONFLICT ("postId", lang) DO NOTHING;

-- ======================================
-- Post 2: Economic Growth
-- ======================================

INSERT INTO "Post" (id, slug, "authorId", category, image, published, featured, views, "createdAt", "updatedAt")
VALUES 
  ('post-2', 'global-economy-2026', 'sample-author-1', 'Business', 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&h=600&fit=crop', true, false, 0, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO "PostTranslation" ("postId", lang, title, content, excerpt, "seoTitle", "seoDesc", "readTime", "createdAt", "updatedAt")
VALUES 
  ('post-2', 'th', 
   'เศรษฐกิจโลกฟื้นตัวแข็งแกร่ง: คาดการณ์การเติบโต 4.5% ในปี 2026',
   '<p>ตัวชี้วัดทางเศรษฐกิจแสดงให้เห็นถึงการเติบโตที่แข็งแกร่งในทุกภาคส่วน</p>',
   'รายงานเศรษฐกิจโลกแสดงสัญญาณการฟื้นตัวที่แข็งแกร่ง พร้อมการเติบโตที่คาดว่าจะอยู่ที่ 4.5% ในปี 2026',
   'เศรษฐกิจโลกฟื้นตัวแข็งแกร่ง: คาดการณ์การเติบโต 4.5% ในปี 2026',
   'รายงานเศรษฐกิจโลกแสดงสัญญาณการฟื้นตัวที่แข็งแกร่ง',
   '4 min read', NOW(), NOW()),
  ('post-2', 'en', 
   'Global Economy Rebounds Strongly: 4.5% Growth Forecast for 2026',
   '<p>Economic indicators show strong growth across all sectors</p>',
   'Global economic reports show strong recovery signs with growth expected at 4.5% in 2026',
   'Global Economy Rebounds Strongly: 4.5% Growth Forecast for 2026',
   'Global economic reports show strong recovery signs',
   '4 min read', NOW(), NOW()),
  ('post-2', 'ja', 
   '世界経済が力強く回復：2026年は4.5%の成長予測',
   '<p>経済指標はすべてのセクターで力強い成長を示しています</p>',
   '世界経済レポートは、2026年に4.5%の成長が見込まれる力強い回復の兆しを示しています',
   '世界経済が力強く回復：2026年は4.5%の成長予測',
   '世界経済レポートは力強い回復の兆しを示しています',
   '4分で読める', NOW(), NOW()),
  ('post-2', 'zh', 
   '全球经济强劲反弹：预测2026年增长4.5%',
   '<p>经济指标显示所有部门都出现强劲增长</p>',
   '全球经济报告显示强劲复苏迹象，预计2026年增长率为4.5%',
   '全球经济强劲反弹：预测2026年增长4.5%',
   '全球经济报告显示强劲复苏迹象',
   '4分钟阅读', NOW(), NOW()),
  ('post-2', 'ko', 
   '세계 경제 강력한 반등: 2026년 4.5% 성장 전망',
   '<p>경제 지표는 모든 부문에서 강력한 성장을 보여줍니다</p>',
   '글로벌 경제 보고서는 2026년 4.5% 성장이 예상되는 강력한 회복 신호를 보여줍니다',
   '세계 경제 강력한 반등: 2026년 4.5% 성장 전망',
   '글로벌 경제 보고서는 강력한 회복 신호를 보여줍니다',
   '4분 소요', NOW(), NOW()),
  ('post-2', 'es', 
   'La Economía Global Se Recupera Con Fuerza: Previsión de Crecimiento del 4.5% para 2026',
   '<p>Los indicadores económicos muestran un fuerte crecimiento en todos los sectores</p>',
   'Los informes económicos globales muestran señales de fuerte recuperación con un crecimiento esperado del 4.5% en 2026',
   'La Economía Global Se Recupera Con Fuerza: Previsión de Crecimiento del 4.5% para 2026',
   'Los informes económicos globales muestran señales de fuerte recuperación',
   '4 min de lectura', NOW(), NOW()),
  ('post-2', 'ms', 
   'Ekonomi Global Pulih Dengan Kuat: Ramalan Pertumbuhan 4.5% untuk 2026',
   '<p>Penunjuk ekonomi menunjukkan pertumbuhan kukuh merentas semua sektor</p>',
   'Laporan ekonomi global menunjukkan tanda pemulihan yang kukuh dengan pertumbuhan dijangka pada 4.5% pada 2026',
   'Ekonomi Global Pulih Dengan Kuat: Ramalan Pertumbuhan 4.5% untuk 2026',
   'Laporan ekonomi global menunjukkan tanda pemulihan yang kukuh',
   '4 min bacaan', NOW(), NOW()),
  ('post-2', 'id', 
   'Ekonomi Global Pulih Dengan Kuat: Perkiraan Pertumbuhan 4.5% untuk 2026',
   '<p>Indikator ekonomi menunjukkan pertumbuhan kuat di semua sektor</p>',
   'Laporan ekonomi global menunjukkan tanda-tanda pemulihan kuat dengan pertumbuhan diperkirakan 4.5% di 2026',
   'Ekonomi Global Pulih Dengan Kuat: Perkiraan Pertumbuhan 4.5% untuk 2026',
   'Laporan ekonomi global menunjukkan tanda-tanda pemulihan kuat',
   '4 menit baca', NOW(), NOW()),
  ('post-2', 'vi', 
   'Kinh Tế Toàn Cầu Phục Hồi Mạnh Mẽ: Dự Báo Tăng Trưởng 4.5% Cho 2026',
   '<p>Các chỉ số kinh tế cho thấy tăng trưởng mạnh mẽ trên tất cả các lĩnh vực</p>',
   'Báo cáo kinh tế toàn cầu cho thấy dấu hiệu phục hồi mạnh mẽ với tăng trưởng dự kiến ở mức 4.5% vào năm 2026',
   'Kinh Tế Toàn Cầu Phục Hồi Mạnh Mẽ: Dự Báo Tăng Trưởng 4.5% Cho 2026',
   'Báo cáo kinh tế toàn cầu cho thấy dấu hiệu phục hồi mạnh mẽ',
   '4 phút đọc', NOW(), NOW()),
  ('post-2', 'tl', 
   'Ang Pandaigdigang Ekonomiya ay Malakas na Bumangon: 4.5% na Paglaki ang Hula para sa 2026',
   '<p>Ang mga indikador ng ekonomiya ay nagpapakita ng malakas na paglaki sa lahat ng sektor</p>',
   'Ang mga ulat ng pandaigdigang ekonomiya ay nagpapakita ng mga senyales ng malakas na pagbawi na may inaasahang paglaki na 4.5% sa 2026',
   'Ang Pandaigdigang Ekonomiya ay Malakas na Bumangon: 4.5% na Paglaki ang Hula para sa 2026',
   'Ang mga ulat ng pandaigdigang ekonomiya ay nagpapakita ng mga senyales ng malakas na pagbawi',
   '4 minuto basahin', NOW(), NOW())
ON CONFLICT ("postId", lang) DO NOTHING;

-- ======================================
-- Post 3: Climate Action
-- ======================================

INSERT INTO "Post" (id, slug, "authorId", category, image, published, featured, views, "createdAt", "updatedAt")
VALUES 
  ('post-3', 'climate-summit-2026', 'sample-author-1', 'Politics', 'https://images.unsplash.com/photo-1569163139394-de4798aa62b6?w=800&h=600&fit=crop', true, true, 0, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO "PostTranslation" ("postId", lang, title, content, excerpt, "seoTitle", "seoDesc", "readTime", "createdAt", "updatedAt")
VALUES 
  ('post-3', 'th', 
   'การประชุมสุดยอดด้านสภาพภูมิอากาศ 2026: ผู้นำโลกตกลงเป้าหมายที่ทะเยอทะยาน',
   '<p>ผู้นำโลกได้ประกาศแผนการอันทะเยอทะยานในการต่อสู้กับการเปลี่ยนแปลงสภาพภูมิอากาศ</p>',
   'การประชุมสุดยอดด้านสภาพภูมิอากาศประจำปี 2026 สิ้นสุดลงด้วยข้อตกลงที่สำคัญจากผู้นำโลกในการลดการปล่อยก๊าซเรือนกระจก',
   'การประชุมสุดยอดด้านสภาพภูมิอากาศ 2026: ผู้นำโลกตกลงเป้าหมายที่ทะเยอทะยาน',
   'การประชุมสุดยอดด้านสภาพภูมิอากาศประจำปี 2026 สิ้นสุดลงด้วยข้อตกลงที่สำคัญ',
   '6 min read', NOW(), NOW()),
  ('post-3', 'en', 
   'Climate Summit 2026: World Leaders Agree on Ambitious Targets',
   '<p>World leaders have announced ambitious plans to combat climate change</p>',
   'The 2026 Climate Summit concluded with landmark agreements from world leaders to reduce greenhouse gas emissions',
   'Climate Summit 2026: World Leaders Agree on Ambitious Targets',
   'The 2026 Climate Summit concluded with landmark agreements',
   '6 min read', NOW(), NOW()),
  ('post-3', 'ja', 
   '2026年気候サミット：世界のリーダーが野心的な目標で合意',
   '<p>世界のリーダーたちは気候変動と闘うための野心的な計画を発表しました</p>',
   '2026年気候サミットは、温室効果ガス排出削減に関する世界のリーダーからの画期的な合意で終了しました',
   '2026年気候サミット：世界のリーダーが野心的な目標で合意',
   '2026年気候サミットは画期的な合意で終了しました',
   '6分で読める', NOW(), NOW()),
  ('post-3', 'zh', 
   '2026年气候峰会：世界领导人就雄心勃勃的目标达成一致',
   '<p>世界领导人宣布了应对气候变化的雄心勃勃的计划</p>',
   '2026年气候峰会以世界领导人就减少温室气体排放达成的里程碑式协议而结束',
   '2026年气候峰会：世界领导人就雄心勃勃的目标达成一致',
   '2026年气候峰会以里程碑式协议结束',
   '6分钟阅读', NOW(), NOW()),
  ('post-3', 'ko', 
   '2026 기후 정상회담: 세계 지도자들, 야심찬 목표에 합의',
   '<p>세계 지도자들은 기후 변화에 맞서기 위한 야심찬 계획을 발표했습니다</p>',
   '2026 기후 정상회담은 온실가스 배출 감소에 대한 세계 지도자들의 획기적인 합의로 마무리되었습니다',
   '2026 기후 정상회담: 세계 지도자들, 야심찬 목표에 합의',
   '2026 기후 정상회담은 획기적인 합의로 마무리되었습니다',
   '6분 소요', NOW(), NOW()),
  ('post-3', 'es', 
   'Cumbre Climática 2026: Los Líderes Mundiales Acuerdan Objetivos Ambiciosos',
   '<p>Los líderes mundiales han anunciado planes ambiciosos para combatir el cambio climático</p>',
   'La Cumbre Climática 2026 concluyó con acuerdos históricos de los líderes mundiales para reducir las emisiones de gases de efecto invernadero',
   'Cumbre Climática 2026: Los Líderes Mundiales Acuerdan Objetivos Ambiciosos',
   'La Cumbre Climática 2026 concluyó con acuerdos históricos',
   '6 min de lectura', NOW(), NOW()),
  ('post-3', 'ms', 
   'Sidang Kemuncak Iklim 2026: Pemimpin Dunia Bersetuju dengan Sasaran Bercita-cita Tinggi',
   '<p>Pemimpin dunia telah mengumumkan rancangan bercita-cita tinggi untuk memerangi perubahan iklim</p>',
   'Sidang Kemuncak Iklim 2026 berakhir dengan perjanjian bersejarah daripada pemimpin dunia untuk mengurangkan pelepasan gas rumah hijau',
   'Sidang Kemuncak Iklim 2026: Pemimpin Dunia Bersetuju dengan Sasaran Bercita-cita Tinggi',
   'Sidang Kemuncak Iklim 2026 berakhir dengan perjanjian bersejarah',
   '6 min bacaan', NOW(), NOW()),
  ('post-3', 'id', 
   'KTT Iklim 2026: Para Pemimpin Dunia Sepakat tentang Target Ambisius',
   '<p>Para pemimpin dunia telah mengumumkan rencana ambisius untuk memerangi perubahan iklim</p>',
   'KTT Iklim 2026 ditutup dengan kesepakatan bersejarah dari para pemimpin dunia untuk mengurangi emisi gas rumah kaca',
   'KTT Iklim 2026: Para Pemimpin Dunia Sepakat tentang Target Ambisius',
   'KTT Iklim 2026 ditutup dengan kesepakatan bersejarah',
   '6 menit baca', NOW(), NOW()),
  ('post-3', 'vi', 
   'Hội Nghị Thượng Đỉnh Khí Hậu 2026: Các Nhà Lãnh Đạo Thế Giới Đồng Ý về Các Mục Tiêu Tham Vọng',
   '<p>Các nhà lãnh đạo thế giới đã công bố các kế hoạch tham vọng để chống biến đổi khí hậu</p>',
   'Hội nghị Thượng đỉnh Khí hậu 2026 kết thúc với các thỏa thuận mang tính bước ngoặt từ các nhà lãnh đạo thế giới nhằm giảm phát thải khí nhà kính',
   'Hội Nghị Thượng Đỉnh Khí Hậu 2026: Các Nhà Lãnh Đạo Thế Giới Đồng Ý về Các Mục Tiêu Tham Vọng',
   'Hội nghị Thượng đỉnh Khí hậu 2026 kết thúc với các thỏa thuận mang tính bước ngoặt',
   '6 phút đọc', NOW(), NOW()),
  ('post-3', 'tl', 
   'Climate Summit 2026: Ang Mga Pinuno ng Mundo ay Sumasang-ayon sa Mataas na Layunin',
   '<p>Ang mga pinuno ng mundo ay nag-anunsyo ng mga ambisyosong plano upang labanan ang pagbabago ng klima</p>',
   'Ang Climate Summit 2026 ay natapos na may makasaysayang mga kasunduan mula sa mga pinuno ng mundo upang bawasan ang mga greenhouse gas emissions',
   'Climate Summit 2026: Ang Mga Pinuno ng Mundo ay Sumasang-ayon sa Mataas na Layunin',
   'Ang Climate Summit 2026 ay natapos na may makasaysayang mga kasunduan',
   '6 minuto basahin', NOW(), NOW())
ON CONFLICT ("postId", lang) DO NOTHING;

-- Success message
SELECT 'Sample data with multiple languages created successfully!' as result;
SELECT COUNT(*) as total_posts FROM "Post";
SELECT COUNT(*) as total_translations FROM "PostTranslation";
