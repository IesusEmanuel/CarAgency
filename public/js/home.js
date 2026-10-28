/* =====================================================================
   APEX MOTORWERKS - JS da Home (index.html)
   ===================================================================== */
(function () {
  'use strict';
  const { $, $$, esc, moeda, numero, quilometragem, decimal, api, linkWhatsapp, mascaraTelefone, criarDropdown } = window.Apex;

  /* ------------------------------------------------------------------
     Estado dos filtros
     ------------------------------------------------------------------ */
  const PADRAO = { carroceria: '', marca: '', cor: '', ano: '', precoMax: 0, busca: '', ordem: 'relevantes' };
  const estado = { ...PADRAO };
  const dropdowns = {};
  let controleBusca = null;
  let timerBusca = null;

  const ORDENACOES = [
    { valor: 'relevantes', rotulo: 'Relevantes' },
    { valor: 'preco_asc', rotulo: 'Menor preço' },
    { valor: 'preco_desc', rotulo: 'Maior preço' },
    { valor: 'km_asc', rotulo: 'Menor quilometragem' },
    { valor: 'km_desc', rotulo: 'Maior quilometragem' },
  ];

  const irParaListagem = () =>
    document.getElementById('procurar-veiculos').scrollIntoView({ behavior: 'smooth', block: 'start' });

  /* ------------------------------------------------------------------
     Filtros (dropdowns "escada" + campo de preço)
     ------------------------------------------------------------------ */
  async function montarFiltros() {
    const dados = await api('/api/filtros');

    const lista = (todosRotulo, itens) => [
      { valor: '', rotulo: todosRotulo },
      ...itens.map((i) => (typeof i === 'string' ? { valor: i, rotulo: i } : { valor: i.nome, rotulo: i.nome, cor: i.hex })),
    ];

    const anos = [];
    for (let a = dados.anos.min; a <= dados.anos.max; a++) anos.push(String(a));

    const config = {
      carroceria: ['#filtro-carroceria', lista('Todos', dados.carrocerias)],
      marca: ['#filtro-marca', lista('Todos', dados.marcas)],
      cor: ['#filtro-cor', lista('Todas', dados.cores)],
      ano: ['#filtro-ano', lista('Todos', anos)],
      ordem: ['#filtro-ordenar', ORDENACOES],
    };

    Object.entries(config).forEach(([chave, [seletor, opcoes]]) => {
      dropdowns[chave] = criarDropdown({
        container: $(seletor),
        opcoes,
        valor: PADRAO[chave],
        aoMudar: (valor) => { estado[chave] = valor; buscarVeiculos(); },
      });
    });
  }

  // Campo de preço com máscara "R$ 35.000"
  function montarCampoPreco() {
    const campo = $('#filtro-preco');
    campo.addEventListener('input', () => {
      const digitos = campo.value.replace(/\D/g, '').slice(0, 9);
      estado.precoMax = digitos ? Number(digitos) : 0;
      campo.value = digitos ? 'R$ ' + numero(estado.precoMax) : '';
      clearTimeout(timerBusca);
      timerBusca = setTimeout(buscarVeiculos, 350);
    });
  }

  function definirPrecoMax(valor) {
    estado.precoMax = valor;
    $('#filtro-preco').value = valor ? 'R$ ' + numero(valor) : '';
  }

  function resetarFiltros() {
    Object.keys(dropdowns).forEach((k) => dropdowns[k].resetar(true));
    Object.assign(estado, PADRAO);
    definirPrecoMax(0);
    $('#busca-texto').value = '';
    buscarVeiculos();
  }

  /* ------------------------------------------------------------------
     Busca + renderização da grade
     ------------------------------------------------------------------ */
  async function buscarVeiculos() {
    clearTimeout(timerBusca);
    if (controleBusca) controleBusca.abort();
    controleBusca = new AbortController();

    const params = new URLSearchParams();
    if (estado.carroceria) params.set('carroceria', estado.carroceria);
    if (estado.marca) params.set('marca', estado.marca);
    if (estado.cor) params.set('cor', estado.cor);
    if (estado.ano) params.set('ano', estado.ano);
    if (estado.precoMax) params.set('precoMax', estado.precoMax);
    if (estado.busca) params.set('busca', estado.busca);
    params.set('ordem', estado.ordem);

    try {
      const dados = await api('/api/veiculos?' + params, { signal: controleBusca.signal });
      $('#contador-resultados').textContent = `Mostrando ${dados.quantidade} de ${dados.total}`;
      renderizarGrade(dados.resultados);
    } catch (erro) {
      if (erro.name === 'AbortError') return;
      $('#grade-veiculos').innerHTML =
        '<div class="grade__vazia"><i class="fa-solid fa-triangle-exclamation"></i>Não foi possível carregar os veículos. Verifique se o servidor está rodando.</div>';
    }
  }

  function cardVeiculo(v) {
    const tags = v.tags.map((t) => `<span class="tag ${esc(t.classe)}">${esc(t.nome)}</span>`).join('');
    const mensagem = `Olá! Tenho interesse no ${v.nome} (${v.ano}).`;
    return `
      <article class="card-veiculo" id="veiculo-${v.id}" data-id="${v.id}">
        <a class="card-veiculo__imagem" href="veiculo.html?id=${v.id}" aria-label="Ver detalhes: ${esc(v.nome)}">
          <img src="${esc(v.imagem_capa)}" alt="${esc(v.nome)}" loading="lazy">
          <div class="card-veiculo__tags">${tags}</div>
          <span class="card-veiculo__km">${quilometragem(v.quilometragem)}</span>
        </a>
        <div class="card-veiculo__corpo">
          <div class="card-veiculo__meta">
            <span>${v.ano} • ${esc(v.marca)}</span>
            <span class="card-veiculo__carroceria">${esc(v.carroceria_sigla)}</span>
          </div>
          <h3 class="card-veiculo__nome">${esc(v.nome)}</h3>
          <div class="card-veiculo__preco-linha">
            <strong class="card-veiculo__preco">${moeda(v.preco)}</strong>
            <span class="card-veiculo__parcela">a partir de ${moeda(v.parcela_a_partir)}/mês</span>
          </div>
          <ul class="card-veiculo__specs">
            <li class="spec"><div class="spec__valor"><span>${v.potencia_cv}cv</span></div><span class="spec__rotulo">Motor</span></li>
            <li class="spec"><div class="spec__valor"><span>${decimal(v.aceleracao_0_100)}s</span></div><span class="spec__rotulo">0-100</span></li>
            <li class="spec spec--cambio"><div class="spec__valor"><span>${esc(v.cambio)}</span></div><span class="spec__rotulo">Câmbio</span></li>
          </ul>
          <div class="card-veiculo__acoes">
            <a class="btn btn--primario" href="veiculo.html?id=${v.id}"><i class="fa-solid fa-eye"></i> Ver detalhes</a>
            <a class="btn btn--secundario" href="${linkWhatsapp(window.Apex.WHATSAPP_LOJA, mensagem)}" target="_blank" rel="noopener"><i class="fa-brands fa-whatsapp"></i> Contato</a>
          </div>
        </div>
      </article>`;
  }

  function renderizarGrade(veiculos) {
    const grade = $('#grade-veiculos');
    if (!veiculos.length) {
      grade.innerHTML =
        '<div class="grade__vazia"><i class="fa-solid fa-car-burst"></i>Nenhum veículo encontrado com esses filtros.<br>Tente ajustar ou use "Resetar filtros".</div>';
      return;
    }
    grade.innerHTML = veiculos.map(cardVeiculo).join('');
  }

  /* ------------------------------------------------------------------
     Hero: busca rápida, seleção rápida e veículo em destaque (vídeo)
     ------------------------------------------------------------------ */
  function montarBuscaRapida() {
    $('#form-busca-rapida').addEventListener('submit', (e) => {
      e.preventDefault();
      estado.busca = $('#busca-texto').value.trim();
      buscarVeiculos();
      irParaListagem();
    });

    $('#selecao-rapida').addEventListener('click', (e) => {
      const botao = e.target.closest('button');
      if (!botao) return;
      if (botao.dataset.marca) dropdowns.marca.definir(botao.dataset.marca);        // dispara a busca
      if (botao.dataset.precoMax) { definirPrecoMax(Number(botao.dataset.precoMax)); buscarVeiculos(); }
      irParaListagem();
    });
  }

  async function carregarDestaque() {
    try {
      const d = await api('/api/destaque');
      const link = $('#veiculo-destaque');
      link.href = `veiculo.html?id=${d.id}`;
      $('#destaque-titulo').textContent = d.nome;
      $('#destaque-subtitulo').textContent = d.subtitulo;
      $('#destaque-preco').textContent = moeda(d.preco);

      const video = $('#destaque-video');
      const fonte = $('#destaque-video-fonte');
      video.poster = d.imagem_capa;
      fonte.addEventListener('error', () => {
        // sem arquivo de vídeo: mostra a imagem de capa no lugar
        const img = document.createElement('img');
        img.id = 'destaque-poster';
        img.src = d.imagem_capa;
        img.alt = d.nome;
        video.replaceWith(img);
      });
      fonte.src = d.video_url;
      video.load();
      const tentar = video.play();
      if (tentar && tentar.catch) tentar.catch(() => { /* autoplay bloqueado: fica no poster */ });
    } catch (_) {
      $('#destaque-titulo').textContent = 'Veículo em destaque indisponível';
    }
  }

  /* ------------------------------------------------------------------
     Recém-saídos
     ------------------------------------------------------------------ */
  async function carregarEntregas() {
    const grade = $('#grade-entregas');
    try {
      const entregas = await api('/api/entregas');
      grade.innerHTML = entregas
        .map(
          (e) => `
        <article class="entrega" id="entrega-${e.id}">
          <div class="entrega__imagem">
            <img src="${esc(e.imagem)}" alt="${esc(e.titulo)}" loading="lazy">
            <span class="tag tag--procurado entrega__local">Entregue: ${esc(e.local_entrega)}</span>
          </div>
          <div class="entrega__corpo">
            <div class="entrega__meta"><span>${esc(e.cliente)}</span><span>${esc(e.mes_ano)}</span></div>
            <h3 class="entrega__titulo">${esc(e.titulo)}</h3>
            <p class="entrega__descricao">${esc(e.descricao)}</p>
            <div class="entrega__rodape">
              <span>KM: ${quilometragem(e.quilometragem)}</span>
              <span>Vendido por: <strong>R$${Number(e.valor_venda).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</strong></span>
            </div>
          </div>
        </article>`
        )
        .join('');
    } catch (_) {
      grade.innerHTML = '<div class="grade__vazia" style="grid-column:1/-1">Não foi possível carregar as entregas.</div>';
    }
  }

  /* ------------------------------------------------------------------
     Formulário "Não consegue encontrar o carro dos seus sonhos?"
     ------------------------------------------------------------------ */
  function montarFormSobMedida() {
    const FAIXAS = [
      'R$10.000,00 até R$20.000,00',
      'R$20.000,00 até R$30.000,00',
      'R$30.000,00 até R$40.000,00',
    ];
    const ddValor = criarDropdown({
      container: $('#dropdown-valor'),
      opcoes: [{ valor: '', rotulo: 'Selecione o valor' }, ...FAIXAS.map((f) => ({ valor: f, rotulo: f }))],
      valor: '',
    });
    mascaraTelefone($('#campo-whatsapp'));

    const form = $('#form-sob-medida');
    const msg = $('#msg-sob-medida');
    const botao = $('#btn-enviar-sob-medida');

    function mostrar(texto, ok) {
      msg.textContent = texto;
      msg.className = 'form__mensagem ' + (ok ? 'form__mensagem--ok' : 'form__mensagem--erro');
    }

    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const corpo = {
        marcaModelo: $('#campo-marca-modelo').value.trim(),
        faixaValor: ddValor.obter(),
        nome: $('#campo-nome').value.trim(),
        whatsapp: $('#campo-whatsapp').value.trim(),
        descricao: $('#campo-descricao').value.trim(),
      };
      if (!corpo.marcaModelo || !corpo.faixaValor || !corpo.nome || !corpo.whatsapp) {
        return mostrar('Preencha marca e modelo, valor, nome e WhatsApp.', false);
      }
      botao.disabled = true;
      try {
        await api('/api/encomendas', { method: 'POST', body: corpo });
        mostrar('Recebemos o seu pedido! Nossa equipe entrará em contato pelo WhatsApp.', true);
        form.reset();
        ddValor.resetar(true);
      } catch (erro) {
        mostrar(erro.message, false);
      } finally {
        botao.disabled = false;
      }
    });
  }

  /* ------------------------------------------------------------------
     Início
     ------------------------------------------------------------------ */
  async function iniciar() {
    window.Apex.iniciarNavegacao();
    montarCampoPreco();
    montarBuscaRapida();
    montarFormSobMedida();
    $('#btn-resetar-filtros').addEventListener('click', resetarFiltros);

    carregarDestaque();
    carregarEntregas();
    try {
      await montarFiltros();
    } catch (_) { /* a grade mostra o erro abaixo */ }
    buscarVeiculos();
  }

  document.addEventListener('DOMContentLoaded', iniciar);
})();
