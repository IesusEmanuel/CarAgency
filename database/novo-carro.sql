-- =====================================================================
-- MODELO PARA ADICIONAR UM CARRO
-- 1) Troque os valores abaixo (principalmente o SLUG, que não pode repetir)
-- 2) Rode:  npm run db:sql -- database/novo-carro.sql
-- 3) Coloque as fotos em public/img/veiculos/<slug>/  (capa.jpg, frente.jpg...)
-- =====================================================================

INSERT INTO veiculos (
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
