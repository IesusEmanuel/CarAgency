/**
 * APEX MOTORWERKS - servidor (Express + SQLite)
 * Uso:  npm start   ->  http://localhost:3000
 */
const path = require('path');
const fs = require('fs');
const express = require('express');
const Database = require('better-sqlite3');

const PORTA = process.env.PORT || 3000;
const CAMINHO_DB = path.join(__dirname, 'database', 'apex.db');

if (!fs.existsSync(CAMINHO_DB)) {
  console.error('Banco não encontrado. Rode primeiro:  npm run db:init');
  process.exit(1);
}

const db = new Database(CAMINHO_DB);
db.pragma('foreign_keys = ON');

const app = express();
app.use(express.json({ limit: '50kb' }));
app.use(express.static(path.join(__dirname, 'public')));

// ---------------------------------------------------------------------
// Consultas
// ---------------------------------------------------------------------
const SELECT_CARD = `
  SELECT v.id, v.slug, v.nome, v.nome_curto, v.modelo,
         m.nome AS marca, c.nome AS carroceria, c.sigla AS carroceria_sigla, co.nome AS cor,
         v.ano_modelo AS ano, v.quilometragem, v.preco, v.parcela_a_partir,
         v.potencia_cv, v.aceleracao_0_100, v.cambio, v.imagem_capa
  FROM veiculos v
  JOIN marcas m       ON m.id = v.marca_id
  JOIN carrocerias c  ON c.id = v.carroceria_id
  JOIN cores co       ON co.id = v.cor_id
`;

// Valores aceitos em ?ordem=  (nada vindo do usuário entra direto no SQL)
const ORDENACOES = {
  relevantes: 'v.relevancia DESC, v.id ASC',
  preco_asc: 'v.preco ASC, v.id ASC',
  preco_desc: 'v.preco DESC, v.id ASC',
  km_asc: 'v.quilometragem ASC, v.id ASC',
  km_desc: 'v.quilometragem DESC, v.id ASC',
};

const stmtTags = db.prepare(`
  SELECT t.nome, t.classe
  FROM veiculo_tags vt JOIN tags t ON t.id = vt.tag_id
  WHERE vt.veiculo_id = ? ORDER BY vt.ordem
`);

const comTags = (veiculos) => veiculos.map((v) => ({ ...v, tags: stmtTags.all(v.id) }));

const limpar = (valor, max = 300) => String(valor ?? '').trim().slice(0, max);

// ---------------------------------------------------------------------
// GET /api/filtros  -> opções para os dropdowns
// ---------------------------------------------------------------------
app.get('/api/filtros', (req, res) => {
  res.json({
    carrocerias: db.prepare('SELECT nome FROM carrocerias ORDER BY id').all().map((r) => r.nome),
    marcas: db.prepare('SELECT nome FROM marcas ORDER BY nome COLLATE NOCASE').all().map((r) => r.nome),
    cores: db.prepare('SELECT nome, hex FROM cores ORDER BY id').all(),
    anos: { min: 1989, max: 2026 },
  });
});

// ---------------------------------------------------------------------
// GET /api/veiculos?carroceria=&marca=&cor=&ano=&precoMax=&busca=&ordem=
// ---------------------------------------------------------------------
app.get('/api/veiculos', (req, res) => {
  const { carroceria, marca, cor, ano, precoMax, busca } = req.query;
  const ordem = ORDENACOES[req.query.ordem] || ORDENACOES.relevantes;

  const condicoes = ['v.disponivel = 1'];
  const params = [];

  if (carroceria) { condicoes.push('c.nome = ?');  params.push(limpar(carroceria, 40)); }
  if (marca)      { condicoes.push('m.nome = ?');  params.push(limpar(marca, 40)); }
  if (cor)        { condicoes.push('co.nome = ?'); params.push(limpar(cor, 40)); }
  if (ano && Number.isInteger(Number(ano))) { condicoes.push('v.ano_modelo = ?'); params.push(Number(ano)); }
  if (precoMax && Number(precoMax) > 0)     { condicoes.push('v.preco <= ?');     params.push(Number(precoMax)); }

  if (busca && limpar(busca, 60)) {
    const termo = `%${limpar(busca, 60)}%`;
    condicoes.push('(v.nome LIKE ? OR v.modelo LIKE ? OR m.nome LIKE ? OR CAST(v.ano_modelo AS TEXT) LIKE ?)');
    params.push(termo, termo, termo, termo);
  }

  const resultados = db
    .prepare(`${SELECT_CARD} WHERE ${condicoes.join(' AND ')} ORDER BY ${ordem}`)
    .all(...params);
  const total = db.prepare('SELECT COUNT(*) AS n FROM veiculos WHERE disponivel = 1').get().n;

  res.json({ total, quantidade: resultados.length, resultados: comTags(resultados) });
});

// ---------------------------------------------------------------------
// GET /api/destaque  -> veículo em destaque da Home (vídeo)
// ---------------------------------------------------------------------
app.get('/api/destaque', (req, res) => {
  const veiculo = db.prepare(`${SELECT_CARD} WHERE v.destaque = 1 AND v.disponivel = 1 LIMIT 1`).get();
  if (!veiculo) return res.status(404).json({ erro: 'Nenhum veículo em destaque.' });
  const extra = db.prepare('SELECT subtitulo, video_url FROM veiculos WHERE id = ?').get(veiculo.id);
  res.json({ ...veiculo, ...extra });
});

// ---------------------------------------------------------------------
// GET /api/veiculos/:id  -> página de detalhes (id numérico ou slug)
// ---------------------------------------------------------------------
app.get('/api/veiculos/:id', (req, res) => {
  const chave = req.params.id;
  const veiculo = db
    .prepare(
      `SELECT v.*, m.nome AS marca, c.nome AS carroceria, c.sigla AS carroceria_sigla, co.nome AS cor
       FROM veiculos v
       JOIN marcas m ON m.id = v.marca_id
       JOIN carrocerias c ON c.id = v.carroceria_id
       JOIN cores co ON co.id = v.cor_id
       WHERE (v.id = ? OR v.slug = ?) AND v.disponivel = 1`
    )
    .get(Number(chave) || 0, chave);

  if (!veiculo) return res.status(404).json({ erro: 'Veículo não encontrado.' });

  res.json({
    ...veiculo,
    chips: veiculo.chips ? veiculo.chips.split('|') : [],
    tags: stmtTags.all(veiculo.id),
    vendedor: db.prepare('SELECT nome, empresa, whatsapp, online, foto FROM vendedores WHERE id = ?').get(veiculo.vendedor_id),
    imagens: db.prepare('SELECT rotulo, legenda, arquivo FROM veiculo_imagens WHERE veiculo_id = ? ORDER BY ordem').all(veiculo.id),
    opcionais: db.prepare('SELECT descricao FROM veiculo_opcionais WHERE veiculo_id = ? ORDER BY ordem').all(veiculo.id).map((o) => o.descricao),
    diferenciais: db.prepare('SELECT titulo, descricao, icone FROM veiculo_diferenciais WHERE veiculo_id = ? ORDER BY ordem').all(veiculo.id),
    troca_rapida: db
      .prepare('SELECT id, nome_curto AS nome FROM veiculos WHERE troca_rapida > 0 AND disponivel = 1 ORDER BY troca_rapida')
      .all(),
  });
});

// ---------------------------------------------------------------------
// GET /api/entregas  -> seção "Recém-Saídos"
// ---------------------------------------------------------------------
app.get('/api/entregas', (req, res) => {
  res.json(db.prepare('SELECT * FROM entregas ORDER BY ordem').all());
});

// ---------------------------------------------------------------------
// POST /api/encomendas  -> "Não consegue encontrar o carro dos seus sonhos?"
// ---------------------------------------------------------------------
const FAIXAS_VALOR = [
  'R$10.000,00 até R$20.000,00',
  'R$20.000,00 até R$30.000,00',
  'R$30.000,00 até R$40.000,00',
];

app.post('/api/encomendas', (req, res) => {
  const marca_modelo = limpar(req.body.marcaModelo, 120);
  const faixa_valor = limpar(req.body.faixaValor, 60);
  const nome = limpar(req.body.nome, 120);
  const whatsapp = limpar(req.body.whatsapp, 30);
  const descricao = limpar(req.body.descricao, 1000);

  if (!marca_modelo || !nome || !whatsapp || !faixa_valor) {
    return res.status(400).json({ erro: 'Preencha marca e modelo, valor, nome e WhatsApp.' });
  }
  if (!FAIXAS_VALOR.includes(faixa_valor)) {
    return res.status(400).json({ erro: 'Escolha uma faixa de valor válida.' });
  }
  if (whatsapp.replace(/\D/g, '').length < 10) {
    return res.status(400).json({ erro: 'Informe um WhatsApp válido, com DDD.' });
  }

  const info = db
    .prepare('INSERT INTO encomendas (marca_modelo, faixa_valor, nome, whatsapp, descricao) VALUES (?, ?, ?, ?, ?)')
    .run(marca_modelo, faixa_valor, nome, whatsapp, descricao);
  res.status(201).json({ ok: true, id: info.lastInsertRowid });
});

// ---------------------------------------------------------------------
// POST /api/interesses  -> formulário da página de detalhes
// ---------------------------------------------------------------------
const TIPOS_VISITA = ['Test-Drive Próprio', 'Test-Drive com Piloto', 'Documentação', 'Financiamento'];

app.post('/api/interesses', (req, res) => {
  const veiculo_id = Number(req.body.veiculoId);
  const nome = limpar(req.body.nome, 120);
  const whatsapp = limpar(req.body.whatsapp, 30);
  const email = limpar(req.body.email, 160);
  const tipo_visita = limpar(req.body.tipoVisita, 40);
  const observacoes = limpar(req.body.observacoes, 1000);

  if (!db.prepare('SELECT 1 FROM veiculos WHERE id = ?').get(veiculo_id)) {
    return res.status(400).json({ erro: 'Veículo inválido.' });
  }
  if (!nome || !whatsapp || !email) {
    return res.status(400).json({ erro: 'Preencha nome, WhatsApp e e-mail.' });
  }
  if (!/^\S+@\S+\.\S+$/.test(email)) {
    return res.status(400).json({ erro: 'Informe um e-mail válido.' });
  }
  if (tipo_visita && !TIPOS_VISITA.includes(tipo_visita)) {
    return res.status(400).json({ erro: 'Tipo de visita inválido.' });
  }

  const info = db
    .prepare('INSERT INTO interesses (veiculo_id, nome, whatsapp, email, tipo_visita, observacoes) VALUES (?, ?, ?, ?, ?, ?)')
    .run(veiculo_id, nome, whatsapp, email, tipo_visita || null, observacoes);
  res.status(201).json({ ok: true, id: info.lastInsertRowid });
});

// ---------------------------------------------------------------------
app.use('/api', (req, res) => res.status(404).json({ erro: 'Rota não encontrada.' }));

app.listen(PORTA, () => {
  console.log(`Apex Motorwerks rodando em http://localhost:${PORTA}`);
});
