/* =====================================================================
   APEX MOTORWERKS - JS comum (usado em index.html e veiculo.html)
   Expõe o objeto global  Apex
   ===================================================================== */
(function () {
  'use strict';

  const WHATSAPP_LOJA = '5533919829292'; // número usado nos botões "Contato" dos cards

  /* ------------------------------------------------------------------
     Utilitários
     ------------------------------------------------------------------ */
  const $ = (seletor, raiz = document) => raiz.querySelector(seletor);
  const $$ = (seletor, raiz = document) => Array.from(raiz.querySelectorAll(seletor));

  const esc = (texto) =>
    String(texto ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

  const numero = (n) => Number(n).toLocaleString('pt-BR');
  const moeda = (n) => 'R$' + numero(Math.round(n));            // R$34.900
  const moedaEspaco = (n) => 'R$ ' + numero(Math.round(n));     // R$ 2.450.000
  const quilometragem = (n) => numero(n) + 'KM';                // 139.000KM
  const decimal = (n) => Number(n).toFixed(1).replace('.', ','); // 4,0

  async function api(caminho, opcoes = {}) {
    const resp = await fetch(caminho, {
      headers: { 'Content-Type': 'application/json' },
      ...opcoes,
      body: opcoes.body ? JSON.stringify(opcoes.body) : undefined,
    });
    let dados = null;
    try { dados = await resp.json(); } catch (_) { /* resposta sem corpo */ }
    if (!resp.ok) {
      const erro = new Error((dados && dados.erro) || 'Erro ao falar com o servidor.');
      erro.status = resp.status;
      throw erro;
    }
    return dados;
  }

  function linkWhatsapp(numeroWhats, mensagem) {
    return `https://wa.me/${numeroWhats}?text=${encodeURIComponent(mensagem)}`;
  }

  // Máscara simples de telefone: (33) 99999-0000
  function mascaraTelefone(input) {
    input.addEventListener('input', () => {
      const d = input.value.replace(/\D/g, '').slice(0, 13);
      if (d.length > 11) { input.value = '+' + d; return; }
      if (d.length > 6) input.value = `(${d.slice(0, 2)}) ${d.slice(2, d.length - 4)}-${d.slice(-4)}`;
      else if (d.length > 2) input.value = `(${d.slice(0, 2)}) ${d.slice(2)}`;
      else input.value = d;
    });
  }

  // Imagem quebrada -> placeholder (uma única vez por imagem)
  document.addEventListener('error', (e) => {
    const img = e.target;
    if (img && img.tagName === 'IMG' && !img.dataset.semImagem) {
      img.dataset.semImagem = '1';
      img.src = 'img/placeholder.svg';
    }
  }, true);

  /* ------------------------------------------------------------------
     DROPDOWN ESTILO "ESCADA"
     Uso:
       const dd = Apex.criarDropdown({
         container: document.querySelector('#filtro-marca'),
         opcoes: [{ valor: '', rotulo: 'Todos' }, { valor: 'Ford', rotulo: 'Ford' }],
         valor: '',
         aoMudar: (valor) => { ... },
       });
       dd.obter(); dd.definir('Ford'); dd.resetar();
     ------------------------------------------------------------------ */
  const dropdownsAbertos = new Set();

  function fecharTodos(exceto) {
    dropdownsAbertos.forEach((fechar) => { if (fechar !== exceto) fechar(); });
  }
  document.addEventListener('click', (e) => {
    dropdownsAbertos.forEach((fechar) => fechar(e));
  });

  function criarDropdown({ container, opcoes, valor = '', aoMudar }) {
    const valorInicial = valor;
    let atual = valor;

    container.classList.add('dropdown');
    container.innerHTML = '';

    const botao = document.createElement('button');
    botao.type = 'button';
    botao.className = 'dropdown__botao';
    botao.setAttribute('aria-haspopup', 'listbox');
    botao.setAttribute('aria-expanded', 'false');
    botao.innerHTML = '<span class="dropdown__valor"></span><i class="fa-solid fa-chevron-down dropdown__seta"></i>';

    const lista = document.createElement('ul');
    lista.className = 'dropdown__lista';
    lista.setAttribute('role', 'listbox');

    const itens = opcoes.map((op, i) => {
      const li = document.createElement('li');
      li.className = 'dropdown__opcao';
      li.setAttribute('role', 'option');
      li.tabIndex = -1;
      li.dataset.valor = op.valor;
      li.style.setProperty('--i', i);
      if (op.cor) {
        const bolinha = document.createElement('span');
        bolinha.className = 'dropdown__cor';
        bolinha.style.background = op.cor;
        li.appendChild(bolinha);
      }
      li.appendChild(document.createTextNode(op.rotulo));
      lista.appendChild(li);
      return li;
    });

    container.append(botao, lista);

    function pintar() {
      const op = opcoes.find((o) => o.valor === atual) || opcoes[0];
      const alvo = $('.dropdown__valor', botao);
      alvo.innerHTML = '';
      if (op.cor) {
        const bolinha = document.createElement('span');
        bolinha.className = 'dropdown__cor';
        bolinha.style.background = op.cor;
        alvo.appendChild(bolinha);
      }
      alvo.appendChild(document.createTextNode(op.rotulo));
      itens.forEach((li) => {
        const sel = li.dataset.valor === String(atual);
        li.classList.toggle('dropdown__opcao--selecionada', sel);
        li.setAttribute('aria-selected', sel ? 'true' : 'false');
      });
    }

    function abrir() {
      fecharTodos(fechar);
      container.classList.add('dropdown--aberto');
      botao.setAttribute('aria-expanded', 'true');
      dropdownsAbertos.add(fechar);
      const sel = lista.querySelector('.dropdown__opcao--selecionada');
      if (sel) sel.scrollIntoView({ block: 'nearest' });
    }

    function fechar(evento) {
      // clique dentro do próprio dropdown não fecha (quem trata é o botão/opção)
      if (evento && evento.target && container.contains(evento.target)) return;
      container.classList.remove('dropdown--aberto');
      botao.setAttribute('aria-expanded', 'false');
      dropdownsAbertos.delete(fechar);
    }

    function escolher(novoValor, silencioso) {
      const mudou = String(novoValor) !== String(atual);
      atual = novoValor;
      pintar();
      if (mudou && !silencioso && typeof aoMudar === 'function') aoMudar(atual);
    }

    botao.addEventListener('click', () => {
      container.classList.contains('dropdown--aberto') ? fechar() : abrir();
    });

    lista.addEventListener('click', (e) => {
      const li = e.target.closest('.dropdown__opcao');
      if (!li) return;
      escolher(li.dataset.valor);
      fechar();
      botao.focus();
    });

    container.addEventListener('keydown', (e) => {
      const aberto = container.classList.contains('dropdown--aberto');
      if (e.key === 'Escape' && aberto) { fechar(); botao.focus(); return; }
      if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
        e.preventDefault();
        if (!aberto) { abrir(); return; }
        const indice = itens.indexOf(document.activeElement);
        const prox = e.key === 'ArrowDown' ? Math.min(indice + 1, itens.length - 1) : Math.max(indice - 1, 0);
        itens[prox < 0 ? 0 : prox].focus();
      }
      if ((e.key === 'Enter' || e.key === ' ') && itens.includes(document.activeElement)) {
        e.preventDefault();
        escolher(document.activeElement.dataset.valor);
        fechar();
        botao.focus();
      }
    });

    pintar();

    return {
      obter: () => atual,
      definir: (v, silencioso = false) => escolher(v, silencioso),
      resetar: (silencioso = true) => escolher(valorInicial, silencioso),
    };
  }

  /* ------------------------------------------------------------------
     NAVEGAÇÃO COM FUNDO LÍQUIDO
     Duas "gotas" ficam atrás do item ativo. Ao trocar de item, a gota da
     frente corre para o novo item e a de trás é arrastada logo depois;
     o filtro SVG (#filtro-liquido) funde as duas, criando o efeito de
     liquefazer. No fim elas voltam a ser um fundo sólido.
     ------------------------------------------------------------------ */
  function iniciarNavegacao() {
    const lista = $('#nav-lista');
    const liquido = $('#nav-liquido');
    const cabeca = $('#nav-gota-cabeca');
    const cauda = $('#nav-gota-cauda');
    if (!lista || !liquido) return;

    const links = $$('.nav__link', lista);
    const secoes = links
      .map((link) => ({ link, secao: document.getElementById(link.dataset.secao) }))
      .filter((x) => x.secao);

    // Em páginas sem as seções (veiculo.html) os links só navegam; nenhum fica ativo.
    if (!secoes.length) return;

    let ativo = null;
    let travado = false;      // evita que o scroll-spy brigue com um clique
    let timerTravado = null;

    function posicionar(link, animar) {
      liquido.classList.toggle('nav__liquido--animando', animar);
      [cabeca, cauda].forEach((gota) => {
        gota.style.left = link.offsetLeft + 'px';
        gota.style.width = link.offsetWidth + 'px';
        gota.classList.add('nav__gota--visivel');
      });
    }

    function definirAtivo(link, animar) {
      if (link === ativo) return;
      links.forEach((l) => {
        l.classList.toggle('nav__link--ativo', l === link);
        if (l === link) l.setAttribute('aria-current', 'true'); else l.removeAttribute('aria-current');
      });
      posicionar(link, animar && ativo !== null);
      ativo = link;
    }

    // clique: anima o menu e rola até a seção
    secoes.forEach(({ link, secao }) => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        definirAtivo(link, true);
        travado = true;
        clearTimeout(timerTravado);
        timerTravado = setTimeout(() => { travado = false; atualizarPorScroll(); }, 900);
        secao.scrollIntoView({ behavior: 'smooth', block: 'start' });
        history.replaceState(null, '', '#' + secao.id);
      });
    });

    // scroll-spy: o menu acompanha a seção visível
    function atualizarPorScroll() {
      if (travado) return;
      const limite = $('#cabecalho').offsetHeight + window.innerHeight * 0.35;
      let escolhido = secoes[0];
      secoes.forEach((s) => { if (s.secao.getBoundingClientRect().top <= limite) escolhido = s; });
      definirAtivo(escolhido.link, true);
    }
    let esperando = false;
    window.addEventListener('scroll', () => {
      if (esperando) return;
      esperando = true;
      requestAnimationFrame(() => { esperando = false; atualizarPorScroll(); });
    }, { passive: true });

    function reposicionar() { if (ativo) posicionar(ativo, false); }
    window.addEventListener('resize', reposicionar);
    window.addEventListener('load', reposicionar);
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(reposicionar);

    atualizarPorScroll();
  }

  window.Apex = {
    WHATSAPP_LOJA,
    $, $$, esc, numero, moeda, moedaEspaco, quilometragem, decimal,
    api, linkWhatsapp, mascaraTelefone,
    criarDropdown, iniciarNavegacao,
  };
})();
