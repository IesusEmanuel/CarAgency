/* =====================================================================
   APEX MOTORWERKS - JS da página de detalhes (veiculo.html?id=...)
   Busca o veículo clicado na API (que consulta o SQLite) e monta a página.
   ===================================================================== */
(function () {
  'use strict';
  const { $, esc, moeda, moedaEspaco, numero, quilometragem, decimal, api, linkWhatsapp, mascaraTelefone, criarDropdown } = window.Apex;

  let veiculo = null;
  let ddTipoVisita = null;

  const id = new URLSearchParams(location.search).get('id');

  function mostrarAviso(html) {
    const aviso = $('#detalhe-aviso');
    aviso.hidden = false;
    aviso.innerHTML = html;
    $('#detalhe-conteudo').hidden = true;
  }

  /* ------------------------------------------------------------------
     Montagem da página
     ------------------------------------------------------------------ */
  function preencherCabecalho(v) {
    document.title = `${v.nome} | Apex Motorwerks`;
    $('#trilha-atual').textContent = v.nome;

    const selos = ['<span class="selo-status selo-status--disponivel">Disponível</span>'];
    if (v.tags.some((t) => t.nome === 'PROCURADO')) selos.push('<span class="selo-status selo-status--procurado">Procurado</span>');
    if (v.vistoriado) selos.push('<span class="selo-status selo-status--vistoriado"><i class="fa-solid fa-circle-check"></i> Vistoriado</span>');
    $('#trilha-selos').innerHTML = selos.join('');

    $('#troca-lista').innerHTML = v.troca_rapida
      .map(
        (t) => `<a class="troca__botao ${t.id === v.id ? 'troca__botao--atual' : ''}" href="veiculo.html?id=${t.id}"
                   ${t.id === v.id ? 'aria-current="page"' : ''}>${esc(t.nome)}</a>`
      )
      .join('');
    // se o veículo aberto não está na barra, esconde o destaque sem esconder a barra
    $('#troca-painel').hidden = v.troca_rapida.length === 0;

    $('#detalhe-titulo').textContent = v.nome;
    $('#detalhe-subtitulo').textContent = v.subtitulo;

    $('#preco-valor').textContent = moedaEspaco(v.preco);
    $('#preco-usd').textContent = v.preco_usd ? `US$ ${numero(v.preco_usd)}` : '';
    $('#preco-parcela').textContent = `a partir de ${moeda(v.parcela_a_partir)}/mês`;

    const caixaBench = $('#preco-benchmark');
    if (v.benchmark_brl) {
      caixaBench.hidden = false;
      $('#benchmark-valor').textContent = moedaEspaco(v.benchmark_brl);
      const economia = v.benchmark_brl - v.preco;
      const rotulo = $('#benchmark-economia');
      rotulo.hidden = economia <= 0;
      rotulo.textContent = `Economia de ${moedaEspaco(economia)}`;
    } else {
      caixaBench.hidden = true;
    }
  }

  /* ---------- Galeria ---------- */
  function montarGaleria(v) {
    const imagem = $('#galeria-imagem');
    const legenda = $('#galeria-legenda');
    const miniaturas = $('#galeria-miniaturas');

    $('#galeria-chips').innerHTML = v.chips
      .map((c, i) => `<span class="chip ${i === 0 ? 'chip--primeiro' : ''}">${esc(c)}</span>`)
      .join('');

    miniaturas.innerHTML = v.imagens
      .map(
        (img, i) => `
        <button type="button" class="miniatura ${i === 0 ? 'miniatura--ativa' : ''}" data-indice="${i}">
          <img src="${esc(img.arquivo)}" alt="" loading="lazy">
          <span><span class="miniatura__numero">0${i + 1} View</span><span class="miniatura__rotulo">${esc(img.rotulo)}</span></span>
        </button>`
      )
      .join('');

    function mostrar(indice) {
      const atual = v.imagens[indice];
      if (!atual) return;
      delete imagem.dataset.semImagem;
      imagem.src = atual.arquivo;
      imagem.alt = `${v.nome} - ${atual.legenda}`;
      legenda.textContent = atual.legenda;
      miniaturas.querySelectorAll('.miniatura').forEach((b, i) => b.classList.toggle('miniatura--ativa', i === indice));
    }

    miniaturas.addEventListener('click', (e) => {
      const botao = e.target.closest('.miniatura');
      if (botao) mostrar(Number(botao.dataset.indice));
    });

    $('#btn-tela-cheia').addEventListener('click', () => {
      const area = $('#galeria-principal');
      if (document.fullscreenElement) document.exitFullscreen();
      else if (area.requestFullscreen) area.requestFullscreen();
    });

    mostrar(0);
  }

  /* ---------- Especificações, visão geral e opcionais ---------- */
  function montarEspecificacoes(v) {
    $('#spec-modelo').textContent = v.nome_curto;
    $('#spec-ano').textContent = `${v.ano_fabricacao} / ${v.ano_modelo}`;
    $('#spec-km').textContent = quilometragem(v.quilometragem);
    $('#spec-aceleracao').textContent = `${decimal(v.aceleracao_0_100)} seg`;
    $('#spec-transmissao').textContent = v.transmissao_detalhe;
    $('#spec-placa').textContent = v.final_placa;
    $('#spec-motor').textContent = v.motor;
    $('#spec-estoque').textContent = v.id_estoque;
    $('#spec-cor').textContent = v.cor_acabamento;
    $('#spec-interno').textContent = v.revestimento_interno;
    $('#spec-blindagem').textContent = v.blindagem;

    const nota = v.integridade_pontuacao >= 95 ? 'A' : v.integridade_pontuacao >= 85 ? 'B' : 'C';
    $('#integridade-pontuacao').textContent = `PONTUAÇÃO: ${v.integridade_pontuacao} / 100 ${nota}`;
    $('#integridade-chassi').textContent = `Rigidez do chassi: ${v.rigidez_chassi}`;
    $('#integridade-freios').textContent = `Reserva térmica dos freios: ${v.reserva_termica_freios}`;
    $('#integridade-cilindros').textContent = `Compressão dos cilindros: ${v.compressao_cilindros}`;
    requestAnimationFrame(() => requestAnimationFrame(() => {
      $('#integridade-barra').style.width = v.integridade_pontuacao + '%';
    }));
  }

  function montarTextos(v) {
    $('#visao-texto').textContent = v.descricao_curada;
    $('#diferenciais').innerHTML = v.diferenciais
      .map(
        (d) => `
        <div class="diferencial">
          <div class="diferencial__titulo"><i class="${esc(d.icone)}"></i>${esc(d.titulo)}</div>
          <p class="diferencial__texto">${esc(d.descricao)}</p>
        </div>`
      )
      .join('');

    $('#opcionais-contador').textContent = `${v.opcionais.length} opcionais disponíveis`;
    $('#opcionais').innerHTML = v.opcionais
      .map((o) => `<div class="opcional"><i class="fa-regular fa-circle-check"></i><span>${esc(o)}</span></div>`)
      .join('');
  }

  /* ---------- Coluna lateral ---------- */
  function montarLateral(v) {
    const vend = v.vendedor;
    $('#vendedor-foto').src = vend.foto || 'img/placeholder.svg';
    $('#vendedor-foto').alt = vend.nome;
    $('#vendedor-nome').textContent = vend.nome;
    $('#vendedor-empresa').textContent = vend.empresa;
    $('#vendedor-online').hidden = !vend.online;

    $('#btn-whatsapp').href = linkWhatsapp(
      vend.whatsapp,
      `Olá, ${vend.nome.split(' ')[0]}! Tenho interesse no ${v.nome_curto} (ID ${v.id_estoque}).`
    );

    $('#fin-entrada').textContent = moedaEspaco(v.preco * 0.5);
    $('#fin-parcela').textContent = `${moedaEspaco(v.parcela_a_partir)} / mês`;

    mascaraTelefone($('#interesse-whatsapp'));
    const TIPOS = ['Test-Drive Próprio', 'Test-Drive com Piloto', 'Documentação', 'Financiamento'];
    ddTipoVisita = criarDropdown({
      container: $('#dropdown-tipo-visita'),
      opcoes: [{ valor: '', rotulo: 'Selecione' }, ...TIPOS.map((t) => ({ valor: t, rotulo: t }))],
      valor: '',
    });

    $('#btn-agendar-visita').addEventListener('click', () => {
      $('#form-interesse').scrollIntoView({ behavior: 'smooth', block: 'center' });
      setTimeout(() => $('#interesse-nome').focus({ preventScroll: true }), 450);
    });

    const form = $('#form-interesse');
    const msg = $('#msg-interesse');
    const botao = $('#btn-enviar-interesse');
    const mostrar = (texto, ok) => {
      msg.textContent = texto;
      msg.className = 'form__mensagem ' + (ok ? 'form__mensagem--ok' : 'form__mensagem--erro');
    };

    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const corpo = {
        veiculoId: v.id,
        nome: $('#interesse-nome').value.trim(),
        whatsapp: $('#interesse-whatsapp').value.trim(),
        email: $('#interesse-email').value.trim(),
        tipoVisita: ddTipoVisita.obter(),
        observacoes: $('#interesse-observacoes').value.trim(),
      };
      if (!corpo.nome || !corpo.whatsapp || !corpo.email) return mostrar('Preencha nome, WhatsApp e e-mail.', false);
      botao.disabled = true;
      try {
        await api('/api/interesses', { method: 'POST', body: corpo });
        mostrar('Mensagem enviada! Em breve entraremos em contato.', true);
        form.reset();
        ddTipoVisita.resetar(true);
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

    if (!id) {
      return mostrarAviso(
        '<i class="fa-solid fa-car-burst"></i>Nenhum veículo foi selecionado.<br><a class="btn btn--primario" href="index.html#procurar-veiculos"><i class="fa-solid fa-arrow-left"></i> Ver veículos</a>'
      );
    }

    try {
      veiculo = await api('/api/veiculos/' + encodeURIComponent(id));
    } catch (erro) {
      const naoAchou = erro.status === 404;
      return mostrarAviso(
        `<i class="fa-solid fa-triangle-exclamation"></i>${
          naoAchou ? 'Veículo não encontrado ou não está mais disponível.' : 'Não foi possível carregar o veículo. Verifique se o servidor está rodando.'
        }<br><a class="btn btn--primario" href="index.html#procurar-veiculos"><i class="fa-solid fa-arrow-left"></i> Ver veículos</a>`
      );
    }

    preencherCabecalho(veiculo);
    montarGaleria(veiculo);
    montarEspecificacoes(veiculo);
    montarTextos(veiculo);
    montarLateral(veiculo);

    $('#detalhe-aviso').hidden = true;
    $('#detalhe-conteudo').hidden = false;
  }

  document.addEventListener('DOMContentLoaded', iniciar);
})();
