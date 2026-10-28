/**
 * Cria o banco (database/apex.db), aplica schema.sql e seed.sql e tenta
 * importar os códigos das marcas pela API da FIPE.
 *
 * Uso:  npm run db:init
 * ATENÇÃO: recria as tabelas, apagando formulários já recebidos.
 */
const fs = require('fs');
const path = require('path');
const Database = require('better-sqlite3');
const importarMarcas = require('./importar-marcas');

const CAMINHO_DB = path.join(__dirname, 'apex.db');

async function main() {
  const db = new Database(CAMINHO_DB);
  db.exec(fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8'));
  db.exec(fs.readFileSync(path.join(__dirname, 'seed.sql'), 'utf8'));

  const total = db.prepare('SELECT COUNT(*) AS n FROM veiculos').get().n;
  const marcas = db.prepare('SELECT COUNT(*) AS n FROM marcas').get().n;
  console.log(`Banco criado: ${total} veículos, ${marcas} marcas.`);
  db.close();

  try {
    await importarMarcas();
  } catch (e) {
    console.warn(`Importação FIPE ignorada (${e.message}). Rode "npm run marcas:importar" depois.`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
