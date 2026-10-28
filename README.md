# Apex Motorwerks

Site em HTML + CSS + JS, com backend Express e banco SQLite.

## Como rodar

```bash
npm install
npm run db:init   # cria database/apex.db (schema.sql + seed.sql) e importa as marcas da FIPE
npm start         # http://localhost:3000
```

`npm run db:init` **recria as tabelas** (apaga formulários já recebidos).
Para só atualizar os códigos FIPE das marcas: `npm run marcas:importar`.

## Estrutura

```
server.js                  API (Express) + serve a pasta public/
database/
  schema.sql               tabelas
  seed.sql                 dados iniciais (veículos, cores, marcas...)
  init-db.js               aplica schema + seed + importação FIPE
  importar-marcas.js       consulta a API externa da FIPE
public/
  index.html               Home
  veiculo.html             Detalhes (veiculo.html?id=9)
  css/comum.css            variáveis, header, botões, dropdown, tags, formulários, rodapé
  css/home.css             Home
  css/veiculo.css          Detalhes
  js/comum.js              menu líquido, dropdown "escada", utilitários
  js/home.js               filtros, grade, destaque, formulário
  js/veiculo.js            página de detalhes
  img/ , video/            suas imagens e o vídeo (veja abaixo)
```

## O que você precisa colocar nas pastas

| Arquivo | Para quê |
|---|---|
| `public/video/destaque-porsche-911-gt3-rs.mp4` | vídeo do veículo em destaque (Home) |
| `public/img/veiculos/<slug>/capa.jpg` | foto do card de cada veículo |
| `public/img/veiculos/<slug>/frente.jpg, interno.jpg, traseira.jpg, rodas.jpg, capo.jpg` | galeria da página de detalhes (no Porsche: `aerofolio.jpg` no lugar de `traseira.jpg`) |
| `public/img/entregas/entrega-1.jpg` ... `entrega-3.jpg` | seção Recém-Saídos |
| `public/img/vendedor-henri.jpg` | foto do vendedor |

`<slug>` é o nome da pasta, por exemplo `ford-ka-1-0`, `porsche-911-gt3-rs-weissach`
(lista completa na coluna `slug` de `veiculos`). Enquanto o arquivo não existir,
aparece uma imagem "SEM IMAGEM" no lugar.

## Fontes

Troque em um só lugar, no topo de `public/css/comum.css`:

```css
--fonte-texto:  'Poppins', sans-serif;      /* textos menores */
--fonte-titulo: 'Bebas Neue', sans-serif;   /* h1 e demais títulos */
```
(e o `<link>` do Google Fonts no `<head>` das duas páginas).

## Adicionar, esconder e remover um veículo

**Adicionar:** copie `database/novo-carro.sql`, troque os valores (o `slug` não pode repetir) e rode:
```bash
npm run db:sql -- database/novo-carro.sql
```
Não precisa reiniciar o servidor, é só atualizar a página (F5). O carro aparece na grade, nos filtros
e ganha a própria página de detalhes. Depois coloque as fotos em `public/img/veiculos/<slug>/`.
Se o arquivo der erro, nada é gravado.

**Esconder** (reversível, recomendado): crie um `.sql` com
```sql
UPDATE veiculos SET disponivel = 0 WHERE slug = 'ford-ka-1-0';   -- volta com disponivel = 1
```
e rode com `npm run db:sql -- arquivo.sql`.

**Excluir de vez:**
```sql
DELETE FROM veiculos WHERE slug = 'ford-ka-1-0';
```
Imagens, opcionais, tags e diferenciais do carro saem junto. Se algum cliente já enviou o formulário
de interesse para esse carro, o banco recusa a exclusão (para não perder o contato). Nesse caso,
esconda o carro em vez de excluir.

**Os carros de exemplo:** para trocar todos de uma vez, edite `seed.sql` e rode `npm run db:init`
(recria o banco e apaga os formulários recebidos).

Atenção: o veículo em destaque (vídeo) é o que tem `destaque = 1` e os 4 botões de "Mudar veículo"
são os que têm `troca_rapida` de 1 a 4.

## Pontos marcados como [PLACEHOLDER] no seed.sql

Os PDFs não tinham dados completos destes itens, então usei valores provisórios:
revisões/opcionais genéricos dos 8 carros da grade, ficha dos veículos Mercedes-AMG G63 e BMW M4 CSL
(que só aparecem em "Mudar veículo"), e os dados técnicos de cada carro da grade que não estavam no card
(final de placa, cor, câmbio detalhado etc.). Revise antes de publicar.

## Formulários recebidos

Ficam nas tabelas `encomendas` ("Não consegue encontrar o carro dos seus sonhos?") e `interesses`
(formulário da página de detalhes):

```bash
sqlite3 database/apex.db "SELECT * FROM encomendas;"
```
