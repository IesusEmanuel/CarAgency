/**
 * Importa o código FIPE das 20 marcas mais comuns do Brasil usando a API
 * externa da FIPE (parallelum). As marcas já existem no banco (seed.sql);
 * aqui gravamos o código e o nome oficial de cada uma.
 *
 * Uso:  npm run marcas:importar
 * Se a API estiver fora do ar, as marcas continuam funcionando normalmente
 * (só ficam sem o código FIPE).
 */
const path = require('path');
const Database = require('better-sqlite3');

const CAMINHO_DB = path.join(__dirname, 'apex.db');

// Endereços tentados em ordem
const ENDPOINTS = [
  { url: 'https://fipe.parallelum.com.br/api/v2/cars/brands', codigo: 'code', nome: 'name' },
  { url: 'https://parallelum.com.br/fipe/api/v1/carros/marcas', codigo: 'codigo', nome: 'nome' },
];

const normalizar = (t) =>
  String(t).normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();

// Nome no banco  ->  palavras que identificam a marca no nome da FIPE
const ALIAS = {
  'Volkswagen': ['volkswagen', 'vw'],
  'Chevrolet': ['chevrolet', 'gm'],
  'Mercedes-Benz': ['mercedes'],
  'Kia': ['kia'],
  'Citroën': ['citroen'],
};

async function buscarMarcasFipe() {
  let ultimoErro;
  for (const ep of ENDPOINTS) {
    try {
      const resp = await fetch(ep.url, { signal: AbortSignal.timeout(15000) });
      if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
      const dados = await resp.json();
      return dados.map((m) => ({ codigo: String(m[ep.codigo]), nome: String(m[ep.nome]) }));
    } catch (e) {
      ultimoErro = e;
      console.warn(`  ! ${ep.url} falhou: ${e.message}`);
    }
  }
  throw ultimoErro;
}

function acharNaFipe(nomeBanco, listaFipe) {
  const chaves = (ALIAS[nomeBanco] || [normalizar(nomeBanco)]).map(normalizar);
  return listaFipe.find((m) => {
    const palavras = normalizar(m.nome).split(' ');
    return chaves.some((c) => palavras.includes(c));
  });
}

async function importar() {
  const db = new Database(CAMINHO_DB);
  const marcas = db.prepare('SELECT id, nome FROM marcas ORDER BY ranking').all();

  console.log('Consultando a API da FIPE...');
  const listaFipe = await buscarMarcasFipe();
  console.log(`  ${listaFipe.length} marcas recebidas da FIPE.`);

  const atualizar = db.prepare('UPDATE marcas SET fipe_codigo = ?, fipe_nome = ? WHERE id = ?');
  let ok = 0;
  for (const marca of marcas) {
    const achada = acharNaFipe(marca.nome, listaFipe);
    if (achada) {
      atualizar.run(achada.codigo, achada.nome, marca.id);
      ok++;
      console.log(`  ✓ ${marca.nome.padEnd(14)} -> ${achada.nome} (código ${achada.codigo})`);
    } else {
      console.log(`  - ${marca.nome.padEnd(14)} não encontrada na FIPE`);
    }
  }
  console.log(`Concluído: ${ok} de ${marcas.length} marcas com código FIPE.`);
  db.close();
}

module.exports = importar;
module.exports.acharNaFipe = acharNaFipe; // exportado para testes

if (require.main === module) {
  importar().catch((e) => {
    console.error('Não foi possível importar da FIPE:', e.message);
    console.error('As marcas locais continuam disponíveis; rode "npm run marcas:importar" depois.');
    process.exit(1);
  });
}
