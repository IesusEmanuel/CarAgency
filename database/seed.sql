-- =====================================================================
-- APEX MOTORWERKS - Dados iniciais (seed)
--
-- Rodar:  npm run db:init   (recria o banco e APAGA formulários recebidos)
--
-- ÍNDICE
--   1. Tabelas de apoio ....... marcas, carrocerias, cores, tags, vendedor
--   2. Veículo inicial ........ Mercedes-Benz AMG G63 (o ÚNICO pré-cadastrado)
--   3. Recém-Saídos ........... cards da seção de entregas da Home
--
-- Os demais carros são cadastrados depois, com:
--   npm run db:sql -- database/novo-carro.sql
--
-- [PLACEHOLDER] = valor provisório inventado. Troque pelos dados reais.
-- =====================================================================

PRAGMA foreign_keys = ON;


-- =====================================================================
-- 1. TABELAS DE APOIO
-- =====================================================================

-- ---------- Marcas (20 mais comuns; a FIPE completa o código depois) ----------
INSERT INTO marcas (ranking, nome, slug) VALUES
  ( 1, 'Fiat',          'fiat'),
  ( 2, 'Volkswagen',    'volkswagen'),
  ( 3, 'Chevrolet',     'chevrolet'),
  ( 4, 'Hyundai',       'hyundai'),
  ( 5, 'Toyota',        'toyota'),
  ( 6, 'Honda',         'honda'),
  ( 7, 'Jeep',          'jeep'),
  ( 8, 'Renault',       'renault'),
  ( 9, 'Ford',          'ford'),
  (10, 'Nissan',        'nissan'),
  (11, 'Citroën',       'citroen'),
  (12, 'Peugeot',       'peugeot'),
  (13, 'BYD',           'byd'),
  (14, 'Mitsubishi',    'mitsubishi'),
  (15, 'BMW',           'bmw'),
  (16, 'Mercedes-Benz', 'mercedes-benz'),
  (17, 'Audi',          'audi'),
  (18, 'Kia',           'kia'),
  (19, 'Volvo',         'volvo'),
  (20, 'Porsche',       'porsche');

-- ---------- Carrocerias ----------
INSERT INTO carrocerias (nome, sigla, slug) VALUES
  ('Sedan',     'SEDAN',     'sedan'),
  ('Hatchback', 'HATCH',     'hatchback'),
  ('Perua',     'PERUA',     'perua'),
  ('SUV',       'SUV',       'suv'),
  ('Esportivo', 'ESPORTIVO', 'esportivo'),
  ('Picape',    'PICAPE',    'picape'),
  ('Van',       'VAN',       'van'),
  ('Minivan',   'MINIVAN',   'minivan');

-- ---------- Cores (30) ----------
INSERT INTO cores (nome, hex) VALUES
  ('Vermelho',     '#d32f2f'), ('Azul',         '#1976d2'), ('Amarelo',      '#fdd835'),
  ('Verde',        '#388e3c'), ('Laranja',      '#f57c00'), ('Roxo',         '#7b1fa2'),
  ('Rosa',         '#ec407a'), ('Marrom',       '#6d4c41'), ('Preto',        '#111111'),
  ('Branco',       '#f5f5f5'), ('Cinza',        '#8e8e93'), ('Azul-marinho', '#0d1b4c'),
  ('Verde-claro',  '#8bc34a'), ('Amarelo-ouro', '#ffc107'), ('Violeta',      '#8f00ff'),
  ('Turquesa',     '#1abc9c'), ('Bordô',        '#6d0f1f'), ('Magenta',      '#e91e8c'),
  ('Ciano',        '#00bcd4'), ('Salmão',       '#fa8072'), ('Bege',         '#d9c8a9'),
  ('Caqui',        '#a89f68'), ('Lilás',        '#c8a2c8'), ('Ocre',         '#cc7722'),
  ('Prata',        '#c0c0c0'), ('Dourado',      '#d4af37'), ('Cobre',        '#b87333'),
  ('Lavanda',      '#b7a6e0'), ('Esmeralda',    '#50c878'), ('Índigo',       '#4b0082');

-- ---------- Tags (a cor de cada uma está em css/comum.css) ----------
INSERT INTO tags (nome, classe) VALUES
  ('PROCURADO',          'tag--procurado'),
  ('0KM',                'tag--zero-km'),
  ('LUXO',               'tag--luxo'),
  ('FAMÍLIA',            'tag--familia'),
  ('FAMILIAR',           'tag--familia'),
  ('KILOMETRAGEM BAIXA', 'tag--km-baixa');

-- ---------- Vendedor (id 1) ----------
-- WhatsApp: somente dígitos, com DDI (55). Veio de "+1 (33) 9 1982-9292" do rodapé.
INSERT INTO vendedores (nome, empresa, whatsapp, online, foto) VALUES
  ('Henri V. Montgomery', 'JR Multimarcas', '5533919829292', 1, 'img/vendedor-henri.jpg');


-- =====================================================================
-- 2. VEÍCULO INICIAL: MERCEDES-AMG G63   [PLACEHOLDER: todos os dados]
--    Fotos em  public/img/veiculos/mercedes-amg-g63/
--    Vídeo em  public/video/destaque-mercedes-amg-g63.mp4
-- =====================================================================

-- ---------- 2.1 Dados principais ----------
INSERT INTO veiculos (
  -- identificação
  slug, nome, nome_curto, modelo, id_estoque,
  -- classificação (nomes das tabelas de apoio)
  marca_id, carroceria_id, cor_id, vendedor_id,
  -- anos, quilometragem e preços
  ano_fabricacao, ano_modelo, quilometragem,
  preco, preco_usd, benchmark_brl, benchmark_usd, parcela_a_partir,
  -- desempenho e mecânica
  potencia_cv, aceleracao_0_100, cambio, transmissao_detalhe, motor, subtitulo,
  -- ficha
  final_placa, cor_acabamento, revestimento_interno, blindagem,
  -- integridade estrutural
  integridade_pontuacao, rigidez_chassi, reserva_termica_freios, compressao_cilindros,
  -- textos e mídia
  chips, descricao_curada, imagem_capa, video_url,
  -- exibição no site
  destaque, troca_rapida, relevancia
) VALUES (
  -- identificação
  'mercedes-amg-g63', '2024 MERCEDES-AMG G63', 'Mercedes-AMG G63', 'AMG G63', 'APX-010',
  -- classificação
  (SELECT id FROM marcas      WHERE nome = 'Mercedes-Benz'),
  (SELECT id FROM carrocerias WHERE nome = 'SUV'),
  (SELECT id FROM cores       WHERE nome = 'Preto'),
  1,
  -- anos, km e preços (preço em R$, só números; NULL = não mostrar)
  2024, 2024, 12000,
  1890000, NULL, NULL, NULL, 13493,
  -- desempenho e mecânica
  585, 4.5, 'Automático', 'AMG Speedshift TCT de 9 marchas', '4.0L V8 Biturbo',
  '4.0L V8 Biturbo • 585cv • Night Package',
  -- ficha
  '***-**0', 'Preto Obsidiana Metálico', 'Couro Nappa vermelho', 'Não se aplica',
  -- integridade
  99, 'deflexão zero', '97%', 'Normal',
  -- textos e mídia (chips separados por |)
  '12.000KM|PACOTE NIGHT|SUSPENSÃO ADAPTATIVA',
  'Ícone off-road de alta performance, com pacote Night, interior em couro Nappa e histórico completo de manutenção. Procedência verificável.',
  'img/veiculos/mercedes-amg-g63/capa.jpg',
  'video/destaque-mercedes-amg-g63.mp4',
  -- exibição: é o destaque (vídeo) da Home; 0 = fora da barra "Mudar veículo"; ordem na grade
  1, 0, 100
);

-- ---------- 2.2 Tags do card ----------
INSERT INTO veiculo_tags (veiculo_id, tag_id, ordem)
SELECT v.id, t.id, x.ordem
FROM (SELECT 'PROCURADO' AS tag, 1 AS ordem UNION ALL SELECT 'LUXO', 2) x
JOIN tags t     ON t.nome = x.tag
JOIN veiculos v ON v.slug = 'mercedes-amg-g63';

-- ---------- 2.3 Galeria (5 fotos, mesmos nomes de arquivo da pasta) ----------
INSERT INTO veiculo_imagens (veiculo_id, rotulo, legenda, arquivo, ordem)
SELECT v.id, i.rotulo, i.legenda, 'img/veiculos/' || v.slug || '/' || i.arq, i.ordem
FROM (
  SELECT 'FRENTE' AS rotulo, 'VISTA FRONTAL' AS legenda, 'frente.jpg' AS arq, 1 AS ordem UNION ALL
  SELECT 'INTERNO',  'VISTA INTERNA',     'interno.jpg',  2 UNION ALL
  SELECT 'TRASEIRA', 'VISTA TRASEIRA',    'traseira.jpg', 3 UNION ALL
  SELECT 'RODAS',    'DETALHE DAS RODAS', 'rodas.jpg',    4 UNION ALL
  SELECT 'CAPÔ',     'DETALHE DO CAPÔ',   'capo.jpg',     5
) i
JOIN veiculos v ON v.slug = 'mercedes-amg-g63';

-- ---------- 2.4 Opcionais ----------
INSERT INTO veiculo_opcionais (veiculo_id, descricao, ordem)
SELECT v.id, o.descricao, o.ordem
FROM (
  SELECT 'Revisões completas com histórico documentado' AS descricao, 1 AS ordem UNION ALL
  SELECT 'Laudo cautelar aprovado, sem registro de sinistro', 2 UNION ALL
  SELECT 'Manual, chave reserva e nota fiscal originais', 3 UNION ALL
  SELECT 'Aprovado em inspeção de 99 pontos da Apex', 4
) o
JOIN veiculos v ON v.slug = 'mercedes-amg-g63';

-- ---------- 2.5 Diferenciais (os 3 cardzinhos da página de detalhes) ----------
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
JOIN veiculos v ON v.slug = 'mercedes-amg-g63';


-- =====================================================================
-- 3. RECÉM-SAÍDOS (seção da Home; 3 cards iguais, como no PDF)
-- =====================================================================
INSERT INTO entregas (cliente, mes_ano, titulo, descricao, quilometragem, valor_venda, local_entrega, imagem, ordem) VALUES
  ('JULIO PEDRO DANTAS', 'OUT 2026', '2023 PORSCHE 911 GT3 TOURING',
   'Adquirida por meio de serviço de concierge via telefone, com transação estruturada com garantia (escrow) de 48 horas e transporte em veículo fechado, com desembarque realizado diretamente.',
   22000, 568500, 'CRICIÚMA, SC', 'img/entregas/entrega-1.jpg', 1),
  ('JULIO PEDRO DANTAS', 'OUT 2026', '2023 PORSCHE 911 GT3 TOURING',
   'Adquirida por meio de serviço de concierge via telefone, com transação estruturada com garantia (escrow) de 48 horas e transporte em veículo fechado, com desembarque realizado diretamente.',
   22000, 568500, 'CRICIÚMA, SC', 'img/entregas/entrega-2.jpg', 2),
  ('JULIO PEDRO DANTAS', 'OUT 2026', '2023 PORSCHE 911 GT3 TOURING',
   'Adquirida por meio de serviço de concierge via telefone, com transação estruturada com garantia (escrow) de 48 horas e transporte em veículo fechado, com desembarque realizado diretamente.',
   22000, 568500, 'CRICIÚMA, SC', 'img/entregas/entrega-3.jpg', 3);