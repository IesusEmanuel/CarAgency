-- =====================================================================
-- APEX MOTORWERKS - Esquema do banco de dados (SQLite)
-- Execute com:  npm run db:init
-- =====================================================================

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS interesses;
DROP TABLE IF EXISTS encomendas;
DROP TABLE IF EXISTS entregas;
DROP TABLE IF EXISTS veiculo_diferenciais;
DROP TABLE IF EXISTS veiculo_opcionais;
DROP TABLE IF EXISTS veiculo_imagens;
DROP TABLE IF EXISTS veiculo_tags;
DROP TABLE IF EXISTS veiculos;
DROP TABLE IF EXISTS vendedores;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS cores;
DROP TABLE IF EXISTS carrocerias;
DROP TABLE IF EXISTS marcas;

PRAGMA foreign_keys = ON;

-- ---------------------------------------------------------------------
-- Tabelas de apoio (alimentam os filtros)
-- ---------------------------------------------------------------------

-- 20 marcas mais comuns no Brasil. 'fipe_codigo' é preenchido pelo script
-- database/importar-marcas.js, que consulta a API externa da FIPE.
CREATE TABLE marcas (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  nome         TEXT    NOT NULL UNIQUE,
  slug         TEXT    NOT NULL UNIQUE,
  ranking      INTEGER NOT NULL,            -- posição na lista das mais comuns
  fipe_codigo  TEXT,                        -- código da marca na API FIPE
  fipe_nome    TEXT                         -- nome como a FIPE o chama
);

CREATE TABLE carrocerias (
  id     INTEGER PRIMARY KEY AUTOINCREMENT,
  nome   TEXT NOT NULL UNIQUE,              -- nome mostrado no filtro
  sigla  TEXT NOT NULL,                     -- texto curto mostrado no card
  slug   TEXT NOT NULL UNIQUE
);

CREATE TABLE cores (
  id    INTEGER PRIMARY KEY AUTOINCREMENT,
  nome  TEXT NOT NULL UNIQUE,
  hex   TEXT NOT NULL                       -- usado na bolinha do dropdown
);

CREATE TABLE tags (
  id      INTEGER PRIMARY KEY AUTOINCREMENT,
  nome    TEXT NOT NULL UNIQUE,
  classe  TEXT NOT NULL                     -- classe CSS (ex.: tag--procurado)
);

CREATE TABLE vendedores (
  id        INTEGER PRIMARY KEY AUTOINCREMENT,
  nome      TEXT NOT NULL,
  empresa   TEXT NOT NULL,
  whatsapp  TEXT NOT NULL,                  -- somente dígitos, com DDI (55...)
  online    INTEGER NOT NULL DEFAULT 1,
  foto      TEXT
);

-- ---------------------------------------------------------------------
-- Veículos
-- ---------------------------------------------------------------------
CREATE TABLE veiculos (
  id                      INTEGER PRIMARY KEY AUTOINCREMENT,
  slug                    TEXT    NOT NULL UNIQUE,
  nome                    TEXT    NOT NULL,          -- título do card
  modelo                  TEXT    NOT NULL,          -- usado na busca
  nome_curto              TEXT    NOT NULL DEFAULT '', -- ex.: Audi RS6 Performance (botões, WhatsApp)
  marca_id                INTEGER NOT NULL REFERENCES marcas(id),
  carroceria_id           INTEGER NOT NULL REFERENCES carrocerias(id),
  cor_id                  INTEGER NOT NULL REFERENCES cores(id),
  vendedor_id             INTEGER NOT NULL REFERENCES vendedores(id),

  ano_fabricacao          INTEGER NOT NULL,
  ano_modelo              INTEGER NOT NULL,
  quilometragem           INTEGER NOT NULL,          -- em km
  preco                   REAL    NOT NULL,          -- em R$
  preco_usd               REAL,                      -- opcional
  benchmark_brl           REAL,                      -- tabela FIPE / benchmark
  benchmark_usd           REAL,
  parcela_a_partir        REAL    NOT NULL,          -- "a partir de R$ X/mês"

  potencia_cv             INTEGER NOT NULL,
  aceleracao_0_100        REAL    NOT NULL,          -- segundos
  cambio                  TEXT    NOT NULL,          -- Manual | Automático | Powershift
  transmissao_detalhe     TEXT    NOT NULL,
  motor                   TEXT    NOT NULL,
  subtitulo               TEXT    NOT NULL,

  final_placa             TEXT    NOT NULL,
  id_estoque              TEXT    NOT NULL,
  cor_acabamento          TEXT    NOT NULL,
  revestimento_interno    TEXT    NOT NULL,
  blindagem               TEXT    NOT NULL DEFAULT 'Não se aplica',

  integridade_pontuacao   INTEGER NOT NULL DEFAULT 100,
  rigidez_chassi          TEXT    NOT NULL DEFAULT 'deflexão zero',
  reserva_termica_freios  TEXT    NOT NULL DEFAULT '98,8%',
  compressao_cilindros    TEXT    NOT NULL DEFAULT 'Normal',

  chips                   TEXT,                      -- chips da galeria, separados por |
  descricao_curada        TEXT    NOT NULL,

  imagem_capa             TEXT    NOT NULL,
  video_url               TEXT,

  destaque                INTEGER NOT NULL DEFAULT 0, -- veículo em destaque da Home
  troca_rapida            INTEGER NOT NULL DEFAULT 0, -- posição em "Mudar veículo" (0 = não aparece)
  relevancia              INTEGER NOT NULL DEFAULT 0, -- ordenação padrão (maior = primeiro)
  vistoriado              INTEGER NOT NULL DEFAULT 1,
  disponivel              INTEGER NOT NULL DEFAULT 1,
  criado_em               TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_veiculos_marca       ON veiculos(marca_id);
CREATE INDEX idx_veiculos_carroceria  ON veiculos(carroceria_id);
CREATE INDEX idx_veiculos_cor         ON veiculos(cor_id);
CREATE INDEX idx_veiculos_ano         ON veiculos(ano_modelo);
CREATE INDEX idx_veiculos_preco       ON veiculos(preco);
CREATE INDEX idx_veiculos_km          ON veiculos(quilometragem);

CREATE TABLE veiculo_tags (
  veiculo_id  INTEGER NOT NULL REFERENCES veiculos(id) ON DELETE CASCADE,
  tag_id      INTEGER NOT NULL REFERENCES tags(id)     ON DELETE CASCADE,
  ordem       INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (veiculo_id, tag_id)
);

CREATE TABLE veiculo_imagens (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  veiculo_id  INTEGER NOT NULL REFERENCES veiculos(id) ON DELETE CASCADE,
  rotulo      TEXT    NOT NULL,                 -- FRENTE, INTERNO, RODAS...
  legenda     TEXT    NOT NULL,                 -- VISTA FRONTAL, VISTA INTERNA...
  arquivo     TEXT    NOT NULL,
  ordem       INTEGER NOT NULL
);

CREATE TABLE veiculo_opcionais (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  veiculo_id  INTEGER NOT NULL REFERENCES veiculos(id) ON DELETE CASCADE,
  descricao   TEXT    NOT NULL,
  ordem       INTEGER NOT NULL
);

CREATE TABLE veiculo_diferenciais (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  veiculo_id  INTEGER NOT NULL REFERENCES veiculos(id) ON DELETE CASCADE,
  titulo      TEXT    NOT NULL,
  descricao   TEXT    NOT NULL,
  icone       TEXT    NOT NULL,                 -- classe Font Awesome
  ordem       INTEGER NOT NULL
);

-- ---------------------------------------------------------------------
-- Seção "Recém-Saídos"
-- ---------------------------------------------------------------------
CREATE TABLE entregas (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  cliente         TEXT NOT NULL,
  mes_ano         TEXT NOT NULL,
  titulo          TEXT NOT NULL,
  descricao       TEXT NOT NULL,
  quilometragem   INTEGER NOT NULL,
  valor_venda     REAL    NOT NULL,
  local_entrega   TEXT NOT NULL,
  imagem          TEXT NOT NULL,
  ordem           INTEGER NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------
-- Formulários recebidos
-- ---------------------------------------------------------------------

-- Formulário "Não consegue encontrar o carro dos seus sonhos?"
CREATE TABLE encomendas (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  marca_modelo TEXT NOT NULL,
  faixa_valor  TEXT NOT NULL,
  nome         TEXT NOT NULL,
  whatsapp     TEXT NOT NULL,
  descricao    TEXT,
  criado_em    TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Formulário da página de detalhes do veículo
CREATE TABLE interesses (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  veiculo_id   INTEGER NOT NULL REFERENCES veiculos(id),
  nome         TEXT NOT NULL,
  whatsapp     TEXT NOT NULL,
  email        TEXT NOT NULL,
  tipo_visita  TEXT,
  observacoes  TEXT,
  criado_em    TEXT NOT NULL DEFAULT (datetime('now'))
);
