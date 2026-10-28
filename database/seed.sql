-- =====================================================================
-- APEX MOTORWERKS - Dados iniciais
-- Os dados dos 8 veículos da grade e do Porsche 911 GT3 RS vêm dos PDFs.
-- Itens marcados com [PLACEHOLDER] foram inventados só para a página não
-- ficar vazia: troque pelos dados reais.
-- =====================================================================

PRAGMA foreign_keys = ON;

-- ---------------------------------------------------------------------
-- Marcas (lista local; o script importar-marcas.js completa o código FIPE
-- consultando a API externa)
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- Carrocerias
-- ---------------------------------------------------------------------
INSERT INTO carrocerias (nome, sigla, slug) VALUES
  ('Sedan',     'SEDAN',     'sedan'),
  ('Hatchback', 'HATCH',     'hatchback'),
  ('Perua',     'PERUA',     'perua'),
  ('SUV',       'SUV',       'suv'),
  ('Esportivo', 'ESPORTIVO', 'esportivo'),
  ('Picape',    'PICAPE',    'picape'),
  ('Van',       'VAN',       'van'),
  ('Minivan',   'MINIVAN',   'minivan');

-- ---------------------------------------------------------------------
-- Cores (30)
-- ---------------------------------------------------------------------
INSERT INTO cores (nome, hex) VALUES
  ('Vermelho',      '#d32f2f'),
  ('Azul',          '#1976d2'),
  ('Amarelo',       '#fdd835'),
  ('Verde',         '#388e3c'),
  ('Laranja',       '#f57c00'),
  ('Roxo',          '#7b1fa2'),
  ('Rosa',          '#ec407a'),
  ('Marrom',        '#6d4c41'),
  ('Preto',         '#111111'),
  ('Branco',        '#f5f5f5'),
  ('Cinza',         '#8e8e93'),
  ('Azul-marinho',  '#0d1b4c'),
  ('Verde-claro',   '#8bc34a'),
  ('Amarelo-ouro',  '#ffc107'),
  ('Violeta',       '#8f00ff'),
  ('Turquesa',      '#1abc9c'),
  ('Bordô',         '#6d0f1f'),
  ('Magenta',       '#e91e8c'),
  ('Ciano',         '#00bcd4'),
  ('Salmão',        '#fa8072'),
  ('Bege',          '#d9c8a9'),
  ('Caqui',         '#a89f68'),
  ('Lilás',         '#c8a2c8'),
  ('Ocre',          '#cc7722'),
  ('Prata',         '#c0c0c0'),
  ('Dourado',       '#d4af37'),
  ('Cobre',         '#b87333'),
  ('Lavanda',       '#b7a6e0'),
  ('Esmeralda',     '#50c878'),
  ('Índigo',        '#4b0082');

-- ---------------------------------------------------------------------
-- Tags (cada tag tem uma cor própria no CSS; mantidas as do PDF)
-- ---------------------------------------------------------------------
INSERT INTO tags (nome, classe) VALUES
  ('PROCURADO',          'tag--procurado'),
  ('0KM',                'tag--zero-km'),
  ('LUXO',               'tag--luxo'),
  ('FAMÍLIA',            'tag--familia'),
  ('FAMILIAR',           'tag--familia'),
  ('KILOMETRAGEM BAIXA', 'tag--km-baixa');

-- ---------------------------------------------------------------------
-- Vendedor  [WhatsApp interpretado a partir de "+1 (33) 9 1982-9292" do rodapé]
-- ---------------------------------------------------------------------
INSERT INTO vendedores (nome, empresa, whatsapp, online, foto) VALUES
  ('Henri V. Montgomery', 'JR Multimarcas', '5533919829292', 1, 'img/vendedor-henri.jpg');

-- ---------------------------------------------------------------------
-- Veículos
-- ---------------------------------------------------------------------
INSERT INTO veiculos (
  slug, nome, modelo, marca_id, carroceria_id, cor_id, vendedor_id,
  ano_fabricacao, ano_modelo, quilometragem, preco, preco_usd, benchmark_brl, benchmark_usd, parcela_a_partir,
  potencia_cv, aceleracao_0_100, cambio, transmissao_detalhe, motor, subtitulo,
  final_placa, id_estoque, cor_acabamento, revestimento_interno, blindagem,
  integridade_pontuacao, rigidez_chassi, reserva_termica_freios, compressao_cilindros,
  chips, descricao_curada, imagem_capa, video_url, destaque, troca_rapida, relevancia
) VALUES
-- 1) FORD KA 1.0
('ford-ka-1-0', 'FORD KA 1.0', 'Ka',
 (SELECT id FROM marcas WHERE nome='Ford'), (SELECT id FROM carrocerias WHERE nome='Hatchback'),
 (SELECT id FROM cores WHERE nome='Branco'), 1,
 2014, 2014, 139000, 34900, NULL, NULL, NULL, 890,
 133, 4.0, 'Manual', 'Manual de 5 marchas', '1.0 Flex 3 cilindros', '1.0 Flex • 133cv • 139.000km',
 '***-**4', 'APX-001', 'Branco Ártico', 'Tecido preto', 'Não se aplica',
 92, 'dentro da tolerância', '90%', 'Normal',
 '139.000KM|BRANCO ÁRTICO|MANUAL',
 'Hatch compacto de dono único, com revisões em dia e histórico de manutenção documentado. Ideal para o dia a dia na cidade, com baixo custo de manutenção e procedência verificável.',
 'img/veiculos/ford-ka-1-0/capa.jpg', NULL, 0, 0, 100),

-- 2) CHEVROLET ONIX LT 1.4
('chevrolet-onix-lt-1-4', 'ONIX LT 1.4', 'Onix',
 (SELECT id FROM marcas WHERE nome='Chevrolet'), (SELECT id FROM carrocerias WHERE nome='Hatchback'),
 (SELECT id FROM cores WHERE nome='Prata'), 1,
 2014, 2014, 39000, 48500, NULL, NULL, NULL, 999,
 147, 3.5, 'Manual', 'Manual de 6 marchas', '1.4 Flex 8V', '1.4 Flex • 147cv • 39.000km',
 '***-**7', 'APX-002', 'Prata Switchblade', 'Tecido bicolor', 'Não se aplica',
 96, 'dentro da tolerância', '94%', 'Normal',
 '39.000KM|PRATA SWITCHBLADE|MANUAL',
 'Unidade com baixa quilometragem para o ano, mantida em garagem e com todas as revisões feitas em concessionária. Acompanha manual, chave reserva e nota fiscal originais.',
 'img/veiculos/chevrolet-onix-lt-1-4/capa.jpg', NULL, 0, 0, 90),

-- 3) AUDI RS6 AVANT PERFORMANCE
('audi-rs6-avant-performance', 'RS6 AVANT PERFORMANCE', 'RS6',
 (SELECT id FROM marcas WHERE nome='Audi'), (SELECT id FROM carrocerias WHERE nome='Sedan'),
 (SELECT id FROM cores WHERE nome='Cinza'), 1,
 2024, 2024, 0, 447500, NULL, NULL, NULL, 3999,
 320, 1.7, 'Automático', 'Tiptronic de 8 marchas', '4.0L V8 TFSI Biturbo', '4.0L V8 Biturbo • Quattro • 0km',
 '***-**1', 'APX-003', 'Cinza Nardo', 'Couro Valcona com costura vermelha', 'Não se aplica',
 100, 'deflexão zero', '99%', 'Normal',
 '0KM|CINZA NARDO|QUATTRO',
 'Zero quilômetro, entregue diretamente da concessionária autorizada, ainda com as proteções plásticas originais de fábrica. Configuração performance com tração integral quattro.',
 'img/veiculos/audi-rs6-avant-performance/capa.jpg', NULL, 0, 3, 80),

-- 4) FORD ECOSPORT ECO 1.6
('ford-ecosport-eco-1-6', 'ECOSPORT ECO 1.6', 'EcoSport',
 (SELECT id FROM marcas WHERE nome='Ford'), (SELECT id FROM carrocerias WHERE nome='SUV'),
 (SELECT id FROM cores WHERE nome='Azul-marinho'), 1,
 2014, 2014, 44000, 59900, NULL, NULL, NULL, 1099,
 183, 5.6, 'Powershift', 'Powershift de dupla embreagem, 6 marchas', '1.6 Flex Duratec', '1.6 Flex • 183cv • 44.000km',
 '***-**3', 'APX-004', 'Azul Perseus', 'Couro sintético preto', 'Não se aplica',
 94, 'dentro da tolerância', '95%', 'Normal',
 '44.000KM|AZUL PERSEUS|POWERSHIFT',
 'SUV compacto com baixa quilometragem, câmbio Powershift revisado e laudo cautelar aprovado. Interior bem conservado, sem registros de sinistro.',
 'img/veiculos/ford-ecosport-eco-1-6/capa.jpg', NULL, 0, 0, 70),

-- 5) CHEVROLET MERIVA JOY LT 1.8
('chevrolet-meriva-joy-lt-1-8', 'MERIVA JOY LT 1.8', 'Meriva',
 (SELECT id FROM marcas WHERE nome='Chevrolet'), (SELECT id FROM carrocerias WHERE nome='Perua'),
 (SELECT id FROM cores WHERE nome='Bege'), 1,
 2011, 2011, 134900, 49900, NULL, NULL, NULL, 990,
 195, 7.2, 'Manual', 'Manual de 5 marchas', '1.8 Flex Econoflex', '1.8 Flex • 195cv • 134.900km',
 '***-**5', 'APX-005', 'Bege Sahara', 'Tecido claro', 'Não se aplica',
 90, 'dentro da tolerância', '88%', 'Normal',
 '134.900KM|BEGE SAHARA|MANUAL',
 'Perua espaçosa e versátil, ótima para família. Revisão completa recente, pneus novos e documentação regular, com procedência verificada.',
 'img/veiculos/chevrolet-meriva-joy-lt-1-8/capa.jpg', NULL, 0, 0, 60),

-- 6) JEEP RENEGADE PREMIUM
('jeep-renegade-premium', 'RENEGADE PREMIUM', 'Renegade',
 (SELECT id FROM marcas WHERE nome='Jeep'), (SELECT id FROM carrocerias WHERE nome='SUV'),
 (SELECT id FROM cores WHERE nome='Vermelho'), 1,
 2023, 2023, 0, 168900, NULL, NULL, NULL, 1999,
 218, 2.9, 'Automático', 'Automático de 9 marchas', '1.3 Turbo Flex', '1.3 Turbo Flex • 218cv • 0km',
 '***-**8', 'APX-006', 'Vermelho Colorado', 'Couro preto', 'Não se aplica',
 100, 'deflexão zero', '99%', 'Normal',
 '0KM|VERMELHO COLORADO|TURBO',
 'Zero quilômetro com garantia de fábrica, acabamento Premium e pacote de segurança completo. Entrega imediata com documentação inclusa.',
 'img/veiculos/jeep-renegade-premium/capa.jpg', NULL, 0, 0, 50),

-- 7) JEEP COMPASS TURBO
('jeep-compass-turbo', 'COMPASS TURBO', 'Compass',
 (SELECT id FROM marcas WHERE nome='Jeep'), (SELECT id FROM carrocerias WHERE nome='SUV'),
 (SELECT id FROM cores WHERE nome='Branco'), 1,
 2023, 2023, 39000, 194000, NULL, NULL, NULL, 2299,
 220, 1.7, 'Automático', 'Automático de 9 marchas', '1.3 Turbo Flex', '1.3 Turbo Flex • 220cv • 39.000km',
 '***-**2', 'APX-007', 'Branco Polar', 'Couro marrom', 'Não se aplica',
 98, 'deflexão zero', '97%', 'Normal',
 '39.000KM|BRANCO POLAR|TURBO',
 'SUV médio muito procurado por famílias, com baixa quilometragem, todas as revisões em concessionária e laudo estrutural aprovado.',
 'img/veiculos/jeep-compass-turbo/capa.jpg', NULL, 0, 0, 40),

-- 8) BMW 116i PREMIUM TURBO
('bmw-116i-premium-turbo', '116I PREMIUM TURBO', '116i',
 (SELECT id FROM marcas WHERE nome='BMW'), (SELECT id FROM carrocerias WHERE nome='Hatchback'),
 (SELECT id FROM cores WHERE nome='Azul'), 1,
 2022, 2022, 12400, 99500, NULL, NULL, NULL, 2599,
 417, 0.5, 'Automático', 'Steptronic de 8 marchas', '1.5 Turbo 3 cilindros', '1.5 Turbo • 417cv • 12.400km',
 '***-**6', 'APX-008', 'Azul Portimão', 'Couro Vernasca preto', 'Não se aplica',
 99, 'deflexão zero', '98%', 'Normal',
 '12.400KM|AZUL PORTIMÃO|TURBO',
 'Hatch premium de baixíssima quilometragem (12.400 km), com pacote M Sport e histórico completo de manutenção na rede autorizada.',
 'img/veiculos/bmw-116i-premium-turbo/capa.jpg', NULL, 0, 0, 30),

-- 9) PORSCHE 911 GT3 RS (WEISSACH)  -- dados do PDF 2
('porsche-911-gt3-rs-weissach', '2024 PORSCHE 911 GT3 RS (WEISSACH)', 'Porsche 911 GT3 RS',
 (SELECT id FROM marcas WHERE nome='Porsche'), (SELECT id FROM carrocerias WHERE nome='Esportivo'),
 (SELECT id FROM cores WHERE nome='Preto'), 1,
 2024, 2024, 10000, 2450000, 314900, 2580000, 329500, 17490,
 518, 1.9, 'Automático', 'Dual-Clutch de 7 Vel', '4.0L Flat-6 (518 HP @ 9,000 RPM / 465 Nm)',
 '4.0L Aspirado Boxer-6 • 518cv • Weissach Package',
 '***-**9', 'APX-99x', 'Cromo Preto Metálico / Carbono', 'Integral em couro com detalhes em vermelho', 'Não se aplica',
 100, 'deflexão zero', '98,8%', 'Normal',
 '10.000KM|FREIOS DE COMPÓSITO CERÂMICO|CROMO PRETO',
 'Entregue novo por meio da Porsche Exclusive Manufaktur, em Stuttgart, e mantido sob condições controladas de temperatura e umidade desde a inspeção pré-entrega. Configurado com o cobiçado pacote Weissach, incluindo detalhes externos em fibra de carbono e uma estrutura de proteção em titânio. O veículo nunca foi utilizado em pistas, preserva as proteções plásticas originais de fábrica no assoalho do lado do passageiro e possui procedência verificável.',
 'img/veiculos/porsche-911-gt3-rs-weissach/capa.jpg', 'video/destaque-porsche-911-gt3-rs.mp4', 1, 1, 20),

-- 10) MERCEDES-AMG G63  [PLACEHOLDER: só aparece em "Mudar veículo" no PDF 2]
('mercedes-amg-g63', '2024 MERCEDES-AMG G63', 'AMG G63',
 (SELECT id FROM marcas WHERE nome='Mercedes-Benz'), (SELECT id FROM carrocerias WHERE nome='SUV'),
 (SELECT id FROM cores WHERE nome='Preto'), 1,
 2024, 2024, 12000, 1890000, NULL, NULL, NULL, 13493,
 585, 4.5, 'Automático', 'AMG Speedshift TCT de 9 marchas', '4.0L V8 Biturbo', '4.0L V8 Biturbo • 585cv • Night Package',
 '***-**0', 'APX-010', 'Preto Obsidiana Metálico', 'Couro Nappa vermelho', 'Não se aplica',
 99, 'deflexão zero', '97%', 'Normal',
 '12.000KM|PACOTE NIGHT|SUSPENSÃO ADAPTATIVA',
 'Ícone off-road de alta performance, com pacote Night, interior em couro Nappa e histórico completo de manutenção. Procedência verificável.',
 'img/veiculos/mercedes-amg-g63/capa.jpg', NULL, 0, 2, 15),

-- 11) BMW M4 CSL TRACK  [PLACEHOLDER: só aparece em "Mudar veículo" no PDF 2]
('bmw-m4-csl-track', '2023 BMW M4 CSL TRACK', 'M4 CSL',
 (SELECT id FROM marcas WHERE nome='BMW'), (SELECT id FROM carrocerias WHERE nome='Esportivo'),
 (SELECT id FROM cores WHERE nome='Cinza'), 1,
 2023, 2023, 3800, 1250000, NULL, NULL, NULL, 8923,
 550, 3.7, 'Automático', 'M Steptronic de 8 marchas', '3.0L Biturbo 6 em linha', '3.0L Biturbo • 550cv • Track Package',
 '***-**4', 'APX-011', 'Cinza Brooklyn', 'Alcantara com costuras M', 'Não se aplica',
 100, 'deflexão zero', '99%', 'Normal',
 '3.800KM|TRACK PACKAGE|FIBRA DE CARBONO',
 'Edição limitada de pista para uso de rua, com bancos de fibra de carbono e redução de peso. Unidade com baixíssima quilometragem.',
 'img/veiculos/bmw-m4-csl-track/capa.jpg', NULL, 0, 4, 10);

-- Nome curto (usado em "Mudar veículo", nas especificações e nas mensagens de WhatsApp)
UPDATE veiculos SET nome_curto = CASE slug
  WHEN 'ford-ka-1-0'                   THEN 'Ford Ka 1.0'
  WHEN 'chevrolet-onix-lt-1-4'         THEN 'Chevrolet Onix LT 1.4'
  WHEN 'audi-rs6-avant-performance'    THEN 'Audi RS6 Performance'
  WHEN 'ford-ecosport-eco-1-6'         THEN 'Ford EcoSport Eco 1.6'
  WHEN 'chevrolet-meriva-joy-lt-1-8'   THEN 'Chevrolet Meriva Joy LT 1.8'
  WHEN 'jeep-renegade-premium'         THEN 'Jeep Renegade Premium'
  WHEN 'jeep-compass-turbo'            THEN 'Jeep Compass Turbo'
  WHEN 'bmw-116i-premium-turbo'        THEN 'BMW 116i Premium Turbo'
  WHEN 'porsche-911-gt3-rs-weissach'   THEN 'Porsche 911 GT3 RS'
  WHEN 'mercedes-amg-g63'              THEN 'Mercedes-AMG G63'
  WHEN 'bmw-m4-csl-track'              THEN 'BMW M4 CSL Track'
END;

-- ---------------------------------------------------------------------
-- Tags de cada veículo (mantidas do PDF; cores corrigidas no CSS)
-- ---------------------------------------------------------------------
INSERT INTO veiculo_tags (veiculo_id, tag_id, ordem)
SELECT v.id, t.id, x.ordem
FROM (
  SELECT 'ford-ka-1-0' AS slug, 'PROCURADO' AS tag, 1 AS ordem UNION ALL
  SELECT 'ford-ka-1-0', '0KM', 2 UNION ALL
  SELECT 'ford-ka-1-0', 'LUXO', 3 UNION ALL

  SELECT 'chevrolet-onix-lt-1-4', 'PROCURADO', 1 UNION ALL
  SELECT 'chevrolet-onix-lt-1-4', 'LUXO', 2 UNION ALL

  SELECT 'audi-rs6-avant-performance', 'FAMÍLIA', 1 UNION ALL
  SELECT 'audi-rs6-avant-performance', '0KM', 2 UNION ALL

  SELECT 'ford-ecosport-eco-1-6', 'PROCURADO', 1 UNION ALL
  SELECT 'ford-ecosport-eco-1-6', 'KILOMETRAGEM BAIXA', 2 UNION ALL

  SELECT 'chevrolet-meriva-joy-lt-1-8', 'LUXO', 1 UNION ALL
  SELECT 'chevrolet-meriva-joy-lt-1-8', 'PROCURADO', 2 UNION ALL

  SELECT 'jeep-renegade-premium', 'PROCURADO', 1 UNION ALL
  SELECT 'jeep-renegade-premium', '0KM', 2 UNION ALL

  SELECT 'jeep-compass-turbo', 'PROCURADO', 1 UNION ALL
  SELECT 'jeep-compass-turbo', 'KILOMETRAGEM BAIXA', 2 UNION ALL
  SELECT 'jeep-compass-turbo', 'FAMILIAR', 3 UNION ALL

  SELECT 'bmw-116i-premium-turbo', 'PROCURADO', 1 UNION ALL
  SELECT 'bmw-116i-premium-turbo', '0KM', 2 UNION ALL

  SELECT 'porsche-911-gt3-rs-weissach', 'PROCURADO', 1 UNION ALL
  SELECT 'porsche-911-gt3-rs-weissach', 'LUXO', 2 UNION ALL

  SELECT 'mercedes-amg-g63', 'PROCURADO', 1 UNION ALL
  SELECT 'mercedes-amg-g63', 'LUXO', 2 UNION ALL

  SELECT 'bmw-m4-csl-track', 'LUXO', 1
) x
JOIN veiculos v ON v.slug = x.slug
JOIN tags t     ON t.nome = x.tag;

-- ---------------------------------------------------------------------
-- Imagens da galeria (5 vistas). Coloque os arquivos em
-- public/img/veiculos/<slug>/frente.jpg, interno.jpg, ...
-- ---------------------------------------------------------------------
INSERT INTO veiculo_imagens (veiculo_id, rotulo, legenda, arquivo, ordem)
SELECT v.id, i.rotulo, i.legenda, 'img/veiculos/' || v.slug || '/' || i.arq, i.ordem
FROM veiculos v
CROSS JOIN (
  SELECT 'FRENTE'  AS rotulo, 'VISTA FRONTAL'  AS legenda, 'frente.jpg'  AS arq, 1 AS ordem UNION ALL
  SELECT 'INTERNO',  'VISTA INTERNA',   'interno.jpg',  2 UNION ALL
  SELECT 'TRASEIRA', 'VISTA TRASEIRA',  'traseira.jpg', 3 UNION ALL
  SELECT 'RODAS',    'DETALHE DAS RODAS', 'rodas.jpg',  4 UNION ALL
  SELECT 'CAPÔ',     'DETALHE DO CAPÔ', 'capo.jpg',     5
) i
WHERE v.slug <> 'porsche-911-gt3-rs-weissach';

INSERT INTO veiculo_imagens (veiculo_id, rotulo, legenda, arquivo, ordem)
SELECT v.id, i.rotulo, i.legenda, 'img/veiculos/' || v.slug || '/' || i.arq, i.ordem
FROM veiculos v
CROSS JOIN (
  SELECT 'FRENTE'    AS rotulo, 'VISTA FRONTAL'    AS legenda, 'frente.jpg'    AS arq, 1 AS ordem UNION ALL
  SELECT 'INTERNO',    'VISTA INTERNA',     'interno.jpg',    2 UNION ALL
  SELECT 'AEROFÓLIO',  'DETALHE DO AEROFÓLIO', 'aerofolio.jpg', 3 UNION ALL
  SELECT 'RODAS',      'DETALHE DAS RODAS', 'rodas.jpg',      4 UNION ALL
  SELECT 'CAPÔ',       'DETALHE DO CAPÔ',   'capo.jpg',       5
) i
WHERE v.slug = 'porsche-911-gt3-rs-weissach';

-- ---------------------------------------------------------------------
-- Opcionais
-- ---------------------------------------------------------------------
INSERT INTO veiculo_opcionais (veiculo_id, descricao, ordem)
SELECT v.id, o.descricao, o.ordem
FROM veiculos v
CROSS JOIN (
  SELECT 'Pacote Weissach de fábrica com aerodinâmica em carbono exposta' AS descricao, 1 AS ordem UNION ALL
  SELECT 'Freios de cerâmica composta Porsche (PCCB) 410 mm', 2 UNION ALL
  SELECT 'Sistema de elevação hidráulica do eixo dianteiro com GPS Memória', 3 UNION ALL
  SELECT 'Bancos de competição tipo concha em fibra de carbono (Leves)', 4 UNION ALL
  SELECT 'Pacote Bose High-End Surround Sound Studio', 5 UNION ALL
  SELECT 'Rodas de magnésio forjadas e leves na cor Satin Pyro', 6 UNION ALL
  SELECT 'Faróis Full Dynamic Matrix LED com PDLS+', 7 UNION ALL
  SELECT 'Aprovado em auditoria de 180 pontos de integridade estrutural e telemetria', 8
) o
WHERE v.slug = 'porsche-911-gt3-rs-weissach';

-- [PLACEHOLDER] opcionais genéricos para os demais veículos
INSERT INTO veiculo_opcionais (veiculo_id, descricao, ordem)
SELECT v.id, o.descricao, o.ordem
FROM veiculos v
CROSS JOIN (
  SELECT 'Revisões completas com histórico documentado' AS descricao, 1 AS ordem UNION ALL
  SELECT 'Laudo cautelar aprovado, sem registro de sinistro', 2 UNION ALL
  SELECT 'Manual, chave reserva e nota fiscal originais', 3 UNION ALL
  SELECT 'Aprovado em inspeção de 99 pontos da Apex', 4
) o
WHERE v.slug <> 'porsche-911-gt3-rs-weissach';

-- ---------------------------------------------------------------------
-- Diferenciais da aquisição (os 3 cards pequenos da página de detalhes)
-- ---------------------------------------------------------------------
INSERT INTO veiculo_diferenciais (veiculo_id, titulo, descricao, icone, ordem)
SELECT v.id, d.titulo, d.descricao, d.icone, d.ordem
FROM veiculos v
CROSS JOIN (
  SELECT 'PDI Dossier' AS titulo,
         'Full Stuttgart build sheets, delivery monroney, and factory order book intact.' AS descricao,
         'fa-solid fa-clipboard-check' AS icone, 1 AS ordem UNION ALL
  SELECT 'Title in Escrow',
         'Clean title held in secured international custody, ready for immediate wire transfer.',
         'fa-solid fa-lock', 2 UNION ALL
  SELECT 'Enclosed Transit',
         'Direct white-glove transport to São Paulo, Miami, Zurich, or Dubai.',
         'fa-solid fa-truck', 3
) d;

-- ---------------------------------------------------------------------
-- Recém-Saídos (3 cards iguais no PDF)
-- ---------------------------------------------------------------------
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
