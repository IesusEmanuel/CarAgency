/**
 * Executa um arquivo .sql no banco SEM recriar as tabelas
 * (os formulários já recebidos são mantidos).
 *
 * Uso:  npm run db:sql -- database/novo-carro.sql
 */
const fs = require('fs');
const path = require('path');
const Database = require('better-sqlite3');

const arquivo = process.argv[2];
if (!arquivo || !fs.existsSync(arquivo)) {
  console.error('Informe um arquivo .sql existente. Ex.: npm run db:sql -- database/novo-carro.sql');
  process.exit(1);
}

const db = new Database(path.join(__dirname, 'apex.db'));
db.pragma('foreign_keys = ON');

try {
  db.exec('BEGIN');
  db.exec(fs.readFileSync(arquivo, 'utf8'));
  db.exec('COMMIT');
} catch (e) {
  db.exec('ROLLBACK'); // nada é gravado pela metade
  console.error('Erro, nada foi alterado:', e.message);
  process.exit(1);
}

const n = db.prepare('SELECT COUNT(*) AS n FROM veiculos WHERE disponivel = 1').get().n;
console.log(`Concluído. Veículos disponíveis agora: ${n}. Atualize a página (F5).`);
db.close();
