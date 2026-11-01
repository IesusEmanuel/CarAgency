-- =====================================================================
-- MODELO PARA ADICIONAR UM CARRO
-- 1) Troque os valores abaixo (principalmente o SLUG, que não pode repetir)
-- 2) Rode:  npm run db:sql -- database/novo-carro.sql
-- 3) Coloque as fotos em public/img/veiculos/<slug>/  (capa.jpg, frente.jpg...)
-- =====================================================================

-- =====================================================================
-- =====================================================================
-- =========== HONDA CIVIC TOURING 2024
-- =====================================================================

/* INSERT INTO veiculos (
  slug, nome, nome_curto, modelo,
  marca_id, carroceria_id, cor_id, vendedor_id,
  ano_fabricacao, ano_modelo, quilometragem, preco, parcela_a_partir,
  potencia_cv, aceleracao_0_100, cambio, transmissao_detalhe, motor, subtitulo,
  final_placa, id_estoque, cor_acabamento, revestimento_interno,
  chips, descricao_curada, imagem_capa,
  relevancia
) VALUES (
  'Honda-Civic-Touring-2024',                       -- slug: único, sem espaços/acentos (vira o nome da pasta de imagens)
  'Honda Civic Touring 2.0',                        -- nome mostrado no card
  'Honda Civic',                                    -- nome curto
  'Civic',                                          -- modelo (usado na busca)
  (SELECT id FROM marcas       WHERE nome = 'Honda'),      -- marca: nome exato da lista
  (SELECT id FROM carrocerias  WHERE nome = 'Sedan'),   -- Sedan, Hatchback, Perua, SUV, Esportivo, Picape, Van, Minivan
  (SELECT id FROM cores        WHERE nome = 'Branco'),      -- uma das 30 cores
  1,                                                -- vendedor (1 = Henri)
  2023, 2024, 56000, 139900, 2199,                  -- ano fab., ano modelo, km, preço, parcela "a partir de"
  230, 6.4, 'Automático', 'DSG de 7 marchas', '2.0 TSI turbo', '2.0 TSI • 260cv • 56.000km',
  '***-**3', 'APX-020', 'Branco Oryx', 'Couro preto',
  '56.000KM|BRANCO ORYX|DSG',                       -- chips da galeria, separados por |
  'Texto da visão geral do carro, que aparece na página de detalhes.',
  'img/veiculos/Honda-Civic-Touring-2024/frente.jpg',
  55                                                -- ordem na listagem padrão (maior = aparece primeiro)
);

-- Tags do card (PROCURADO, 0KM, LUXO, FAMÍLIA, FAMILIAR, KILOMETRAGEM BAIXA)
INSERT INTO veiculo_tags (veiculo_id, tag_id, ordem)
SELECT v.id, t.id, x.ordem FROM veiculos v
JOIN (SELECT 'PROCURADO' AS tag, 1 AS ordem UNION ALL SELECT 'KILOMETRAGEM BAIXA', 2) x
JOIN tags t ON t.nome = x.tag
WHERE v.slug = 'Honda-Civic-Touring-2024';

-- Galeria: 5 fotos em public/img/veiculos/<slug>/
INSERT INTO veiculo_imagens (veiculo_id, rotulo, legenda, arquivo, ordem)
SELECT v.id, i.rotulo, i.legenda, 'img/veiculos/' || v.slug || '/' || i.arq, i.ordem
FROM veiculos v
CROSS JOIN (
  SELECT 'FRENTE' AS rotulo, 'VISTA FRONTAL' AS legenda, 'frente.jpg' AS arq, 1 AS ordem UNION ALL
  SELECT 'INTERNO',  'VISTA INTERNA',      'interna.jpg',  2 UNION ALL
  SELECT 'TRASEIRA', 'VISTA TRASEIRA',     'traseira.jpg', 3 UNION ALL
  SELECT 'TETO',    'TETO SOLAR',  'teto.jpg',    4 UNION ALL
  SELECT 'LATERAL',     'VISÃO LATERAL',    'lado.jpg',     5
) i
WHERE v.slug = 'Honda-Civic-Touring-2024';

-- Opcionais (um INSERT por linha, a ordem define a posição)
INSERT INTO veiculo_opcionais (veiculo_id, descricao, ordem)
SELECT v.id, o.descricao, o.ordem FROM veiculos v
JOIN (
  SELECT 'Revisões completas com histórico documentado' AS descricao, 1 AS ordem UNION ALL
  SELECT 'Laudo cautelar aprovado', 2
) o
WHERE v.slug = 'Honda-Civic-Touring-2024';

-- Diferenciais (os 3 cardzinhos): copia os padrões do site
INSERT INTO veiculo_diferenciais (veiculo_id, titulo, descricao, icone, ordem)
SELECT v.id, d.titulo, d.descricao, d.icone, d.ordem FROM veiculos v
JOIN (
  SELECT titulo, descricao, icone, ordem FROM veiculo_diferenciais
  WHERE veiculo_id = (SELECT id FROM veiculos WHERE slug = 'porsche-911-gt3-rs-weissach')
) d
WHERE v.slug = 'Honda-Civic-Touring-2024';
 */
-- =====================================================================
-- =====================================================================
-- =========== COROLLA
-- =====================================================================

INSERT INTO veiculos (
  slug, nome, nome_curto, modelo,
  marca_id, carroceria_id, cor_id, vendedor_id,
  ano_fabricacao, ano_modelo, quilometragem, preco, parcela_a_partir,
  potencia_cv, aceleracao_0_100, cambio, transmissao_detalhe, motor, subtitulo,
  final_placa, id_estoque, cor_acabamento, revestimento_interno,
  chips, descricao_curada, imagem_capa, relevancia
) VALUES (
  'toyota-corolla-altis-hybrid-2022',
  'COROLLA ALTIS HYBRID',
  'Toyota Corolla Altis Hybrid',
  'Corolla',
  (SELECT id FROM marcas      WHERE nome = 'Toyota'),
  (SELECT id FROM carrocerias WHERE nome = 'Sedan'),
  (SELECT id FROM cores       WHERE nome = 'Cinza'),
  1,
  2022, 2022,
  41200,                -- quilometragem
  139900,               -- preço em R$ (sem pontos nem vírgula)
  2290,                 -- "a partir de R$ 2.290/mês"
  122, 10.5, 'Automático', 'CVT e-CVT', '1.8 Híbrido Flex', '1.8 Híbrido • 122cv • 41.200km',
  '***-**7', 'APX-021', 'Cinza Granito', 'Couro bege',
  '41.200KM|CINZA GRANITO|HÍBRIDO',
  'Sedan híbrido de único dono, com revisões feitas na concessionária e laudo cautelar aprovado. Muito econômico e silencioso na cidade.',
  'https://images.topgear.com.ph/topgear/images/2025/01/04/toyota-corolla-altis-2025-1-1735973576.webp',
  45
);

-- 2) AS TAGS do card (use nomes existentes: PROCURADO, 0KM, LUXO, FAMÍLIA, FAMILIAR, KILOMETRAGEM BAIXA)
INSERT INTO veiculo_tags (veiculo_id, tag_id, ordem) VALUES
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), (SELECT id FROM tags WHERE nome = 'PROCURADO'),          1),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), (SELECT id FROM tags WHERE nome = 'KILOMETRAGEM BAIXA'), 2),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), (SELECT id FROM tags WHERE nome = 'FAMÍLIA'),            3);

-- 3) AS IMAGENS da galeria (arquivos em public/img/veiculos/toyota-corolla-altis-hybrid-2022/)
INSERT INTO veiculo_imagens (veiculo_id, rotulo, legenda, arquivo, ordem) VALUES
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'FRENTE',      'VISTA FRONTAL',      'https://images.topgear.com.ph/topgear/images/2025/01/04/toyota-corolla-altis-2025-1-1735973576.webp',      1),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'INTERNO',     'VISTA INTERNA',      'https://midias.vrum.com.br/_midias/jpg/2024/08/02/1200x675/1_toyota_corolla_altis_hybrid_premium_modelo_2024_branco_interior_painel_multimidia_bancos_dianteiros_no_asfalto_com_mata_ao_fundo-39254746.jpg',     2),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'TRASEIRA',    'VISTA TRASEIRA',     'https://www.autoo.com.br/fotos/2019/9/1280_960/toyota_corolla_2020_1_06092019_15692_1280_960.jpg',    3),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'RODAS',       'DETALHE DAS RODAS',  'https://midias.vrum.com.br/_midias/jpg/2024/08/02/toyota_corolla_altis_hybrid_premium_modelo_2024_branco_roda_de_liga_leve_de_17_polegadas_no_asfalto_com_mata_ao_fundo-39254758.jpg',       4),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'PORTA-MALAS', 'PORTA-MALAS',        'https://midias.vrum.com.br/_midias/jpg/2024/08/02/1200x675/1_toyota_corolla_altis_hybrid_premium_modelo_2024_branco_de_traseira_porta_malas_aberto_no_asfalto_com_mata_ao_fundo-39254654.jpg', 5);

-- 4) OS OPCIONAIS (lista da página de detalhes)
INSERT INTO veiculo_opcionais (veiculo_id, descricao, ordem) VALUES
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'Teto solar elétrico',                      1),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'Central multimídia com Apple CarPlay',      2),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'Pacote de segurança Toyota Safety Sense',   3),
  ((SELECT id FROM veiculos WHERE slug = 'toyota-corolla-altis-hybrid-2022'), 'Revisões completas na concessionária',      4);

-- 5) OS 3 DIFERENCIAIS (textos padrão do site, edite se quiser)
INSERT INTO veiculo_diferenciais (veiculo_id, titulo, descricao, icone, ordem)
SELECT v.id, d.titulo, d.descricao, d.icone, d.ordem
FROM (
  SELECT 'PDI Dossier' AS titulo,
         'Full Stuttgart build sheets, delivery monroney, and factory order book intact.' AS descricao,
         'fa-solid fa-clipboard-check' AS icone, 1 AS ordem UNION ALL
  SELECT 'Title in Escrow',
         'Clean title held in secured international custody, ready for immediate wire transfer.',
         'fa-solid fa-lock', 2 UNION ALL
  SELECT 'Enclosed Transit',
         'Direct white-glove transport to São Paulo, Miami, Zurich, or Dubai.',
         'fa-solid fa-truck', 3
) d
JOIN veiculos v ON v.slug = 'toyota-corolla-altis-hybrid-2022';