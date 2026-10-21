# Nuvemshop (Tiendanube, tema Twig) — referência de triagem PageSpeed

Lojas lidas: `nuvemshop/alanisbrand` e `nuvemshop/lasanday`. O tema publicado é a pasta `store/` (Twig + estáticos). `src/main.scss` e `src/main.ts` geram `store/static/css/main.css` e `store/static/js/main.js`. Publicação é FTP do `store/`, não deploy de app.

O admin pode divergir do git. `store/config/data.json` nestes dois repos só lista assets de preview. Valores vivos de banner, ordem da home e slider mobile estão no admin (e, como default de tema, em `store/config/defaults.txt`). `defaults.txt` das duas lojas põe `home_order_position_1 = slider`.

## 1. Anatomia

Motor: Twig. Página entra por `store/templates/{home,category,product,search,cart}.tpl` dentro de `store/layouts/layout.tpl`. Blocos reutilizáveis ficam em `store/snipplets/`. Schema do editor: `store/config/settings.txt`. Textos: `translations.txt`. Defaults: `defaults.txt`.

| O que é do tema | O que a plataforma injeta |
|---|---|
| `.tpl`, SCSS/CSS, `static/js/*.tpl` e `main.js` | `{% head_content %}` em `layouts/layout.tpl`: JS privado (`LS`), apps da App Store, pixels e metatags do admin |
| `settings.css_code` impresso no `<head>` (CSS do lojista) | `{{ component(...) }}` e `{{ component('nubesdk-slot', ...) }}`: componentes e slots que o tema não implementa |
| Filtros que o tema escolhe: `static_url`, `settings_image_url`, `product_image_url` | A URL e o arquivo gerados por esses filtros (CDN da Nuvemshop) |
| Carrinho (`templates/cart.tpl`) e simulador de frete no tema | Checkout depois do carrinho, hospedado pela Nuvemshop |

| Peça | Alanis Brand | Lasanday |
|---|---|---|
| Head | `store/layouts/layout.tpl`. Preload da Google Font (`settings.font_headings`, `settings.font_rest`). jQuery 1.11.1 via `script_tag(true)` se `load_jquery`. `{% head_content %}`. No fim do body: `external-no-dependencies.js.tpl` (lazysizes 5.2.2), `external.js.tpl` (Swiper) e `store.js.tpl` dentro de `LS.ready.then`, depois `js/main.js`. | Igual, com preload extra de `js/external-no-dependencies.js.tpl` no `<head>` e o mesmo arquivo de novo no body via `script_tag`. `main.js?v=20260811d`. |
| Hero imagem | `snipplets/home/home-slider.tpl`, incluído por `home-section-switch.tpl` (desktop e, se houver, `mobile: true`). Swiper. `settings.slider` / `settings.slider_mobile`. | O mesmo arquivo, com classe `swiper` (não `swiper-container`) e `settings.slider_full`. |
| Hero vídeo | `snipplets/home/home-video.tpl`. YouTube (`video_embed`, `video_type` autoplay/sound). Poster: `video_image.jpg` ou `img.youtube.com/vi_webp/{id}/maxresdefault.webp`. `fetchpriority="high"` se `home_order_position_1 == 'video'`. Caixa `embed-responsive-16by9`. | O mesmo snippet, sem `fetchpriority` no `<img>` do poster mesmo quando o vídeo é a primeira seção. |
| Ordem da home | `templates/home.tpl` itera `home_order_position_1`…`_18` e inclui `home-section-switch.tpl`. | Igual, até `_25`. |
| Card | `snipplets/grid/item.tpl` → componente de plataforma `product-item-image` (`image_lazy: true`, `image_lazy_js: true`, `image_thumbs`, `image_sizes` em vw, `image_priority_high`). Classe `lazyautosizes` + `lazyload`, exceto quando `image_priority_high`. | Igual. `settings.item_same_height` e `item_image_format_size` reservam caixa no SCSS. Slider de fotos do card desligado (`slider: false`). |
| Onde o card entra | PLP: `snipplets/product_grid.tpl` (índices 1 e 2 com `image_priority_high`). Home: `home-featured-grid.tpl` inclui `item.tpl` sem essa flag. | PLP: `product_grid.tpl` (mesma regra dos 2 primeiros). Home: `home-featured-grid.tpl` e `home-banner-products.tpl`, sem `image_priority_high`. |
| Galeria PDP | `snipplets/product/product-image.tpl`. Primeira mídia: `src` real, `fetchpriority="high"`, `width`/`height` se `media.dimensions` existir, `padding-bottom` pela razão. Demais: GIF via `data-src` + `lazyload lazyautosizes`. Vídeo: `product-video.tpl`. | Igual, com ramos de imagem inicial e de mídia nativa. Zoom/modal via `data-fancybox` ou `data-zoom`. |
| Newsletter | `snipplets/home/home-newsletter.tpl` + `snipplets/newsletter.tpl`. Imagem com `src` placeholder e `data-srcset` `lazyload`. | Equivalente no mesmo caminho de snipplet. |
| Popup promoção | `templates/home.tpl` inclui `home-popup.tpl` se `home_promotional_popup`. Modal (`modal.tpl`), imagem `lazyload`. | Inclui `home-popup.tpl` se `show_news_box` com imagem ou formulário. Cookie de reexibição em `store.js.tpl` (`home_popup_cookie`, default 15 dias). |
| Frete | `snipplets/product/product-form.tpl` → `shipping/shipping-calculator.tpl` (`store.shipping_calculator_url`). Resultado em `shipping_options.tpl`. CEP também no `store.js.tpl` (`calculator_zipcode`). | Mesmos snipplets. |
| Cookies / LGPD | `snipplets/header/header.tpl` inclui `notification.tpl` com `show_cookie_banner: true`. Barra `notification-fixed-bottom`, `display: none` até `store.js.tpl` chamar `cookieNotificationService`. Some se `should_omit_consent_management`. | O mesmo include no header. O JS ainda soma `paddingBottom` no rodapé legal com a altura da barra. |

Imagem de configuração: `slide.image | static_url | settings_image_url('large'|'huge'|'original'|'1080p')`. Imagem de produto: `product_image_url('small'|'medium'|'large'|'huge'|'original')`. O tema pede o nome do tamanho; o arquivo sai do CDN.

## 2. Armadilhas reais

**LCP**

- `home-slider.tpl` (as duas lojas) só tira o lazy do primeiro slide quando `home_order_position_1 == 'slider'` e, além disso, `(slider desktop sem slider mobile) ou (este include é o mobile)`. Com `toggle_slider_mobile` ligado, o include desktop cai no GIF 1×1 (`data-src` + classe `swiper-lazy`) e o `fetchpriority="high"` não sai. O LCP de desktop espera o Swiper (`store.js.tpl`, `createSwiper('.js-home-slider')`).
- O `srcset` do hero não tem `sizes`. Os candidatos vão de `large` (480w) a `1080p` (1920w). Sem `sizes`, o navegador pode baixar o 1920w em viewport menor. O `src` eager usa só `settings_image_url('large')`.
- `width`/`height` do slide só entram se o objeto do admin tiver `slide.width` e `slide.height`. Arte antiga sem essas props não reserva caixa no HTML.
- Lasanday, `home-video.tpl`: o poster não recebe `fetchpriority="high"` quando o vídeo é a primeira seção. Alanis recebe. Nos dois, o iframe do YouTube nasce depois do JS (`js-home-video` / `data-video`). Autoplay troca o poster pelo player; o poster precisa existir no primeiro HTML.
- Card da home (`home-featured-grid.tpl`) não passa `image_priority_high`. O `<img>` fica com `lazyload` + `image_lazy: true` + `image_lazy_js: true` no componente `product-item-image`. lazysizes (classe `lazyload`, attr `data-src`) compete com o `loading` nativo: a imagem não entra no preload scanner.
- Na PLP, `product_grid.tpl` tira a classe `lazyload` dos dois primeiros, mas o componente continua com `image_lazy: true`. Conferir no HTML publicado se o `src` real saiu ou se ainda é `data-src`.

**CLS**

- Hero lazy: o GIF 1×1 mais `.placeholder-fade` troca de altura quando o Swiper revela a arte, se `width`/`height` não vieram do admin.
- PDP reserva razão com `padding-bottom: height/width * 100%` e `img-absolute`. Sem `media.dimensions`, a conta quebra e a coluna pula.
- Newsletter e banners secundários usam `images/empty-placeholder.png` no `src` e a foto em `data-srcset`, sem `width`/`height`.
- Cookie: a barra é `fixed` e nasce `display: none`. O `store.js.tpl` aplica `paddingBottom` no rodapé com a altura medida. Isso desloca o fim da página depois do JS. Não é o LCP; é CLS de rodapé.
- Popup de home é modal. A imagem interna é lazy. Abrir por cima não deve empurrar o documento; empurrar o body é CLS e entra na hora de modal.

**TBT / INP / Payload**

- `external-no-dependencies.js.tpl` é o lazysizes inteiro. `external.js.tpl` é o Swiper. Os dois entram no HTML via include, dentro de `LS.ready.then` (Alanis) — depois do JS privado da Nuvemshop. Lasanday ainda faz preload do lazysizes no head e carrega de novo no body.
- `store.js.tpl` é um arquivo único: Swiper da home, vitrines (`js-swiper-featured`, `new`, `sale`), frete, cookie, popup, quickshop. Roda na main thread a cada página.
- `main.js` é o bundle da agência (`src/main.ts`), carregado sem `defer` no fim do body, depois do bloco acima.
- jQuery 1.11 ainda está no layout quando `load_jquery` é verdadeiro.
- Apps, GTM, Meta e pixels não estão nos `.tpl`. Saem de `{% head_content %}` e dos slots `nubesdk-slot`.
- Widgets de vídeos curtos e stories instalados pela App Store ou por script no admin (iShorts, Tolstoy, Wide e equivalentes) baixam, no carregamento inicial, dezenas de `.mp4` e thumbnails. Auditorias da plataforma mediram payloads de 10 MB a 35 MB ou mais só nesse widget. O preload dispara na primeira pintura, gera dezenas de long tasks, ocupa a thread principal e derruba LCP e INP mesmo com o hero do tema já priorizado. O código interno do app não está no git do tema.

## 3. Não cotar como código de tema

- TTFB dos servidores da Nuvemshop e o tempo de `{% head_content %}` / `LS.ready`.
- Formato, compressão e domínio do CDN pedido por `product_image_url` e `settings_image_url`. O tema só escolhe o nome do tamanho (`large`, `huge`, `original`, `1080p`).
- Scripts de apps instalados na App Store e pixels configurados no admin. Não estão no git.
- Checkout depois do carrinho.
- HTML interno do componente `product-item-image` e de `structured-data`. Dá para passar props; não dá para reescrever o componente da plataforma no tema.
- Trocar o slider por uma imagem estática, ou desligar o autoplay do vídeo, é redesign se o lojista aprovou o efeito.
- Valor de `home_order_position_*` e das imagens do slider salvo no admin. Mudar o `.tpl` não reordena a home.

## 4. Handoff

| Alvo | Arquivo | O que editar |
|---|---|---|
| Hero imagem | `store/snipplets/home/home-slider.tpl` | No primeiro slide visível do breakpoint (desktop e mobile separados): `src` real, `fetchpriority="high"`, sem classe `swiper-lazy` e sem GIF. A condição atual falha quando os dois sliders existem. Acrescentar `sizes` coerente com a largura do banner (full-bleed = `100vw`). Manter `width`/`height` quando `slide.width` e `slide.height` existirem. Não remover Swiper, setas, dots nem autoplay. |
| Hero vídeo | `store/snipplets/home/home-video.tpl` | Lasanday: `fetchpriority="high"` no poster quando `has_video_first`, como já está na Alanis. Poster com `width`/`height` (16:9 ou a imagem custom). Autoplay e YouTube permanecem. Não trocar o vídeo por banner estático. |
| Card home | `store/snipplets/home/home-featured-grid.tpl` (Lasanday: também `home-banner-products.tpl`) e `store/snipplets/grid/item.tpl` | Passar `image_priority_high` só no primeiro card acima da dobra. Nesse caso, não mandar `image_lazy: true` / `image_lazy_js: true` e não usar a classe `lazyload`. Os demais cards continuam no lazysizes. `image_sizes` em vw permanece. |
| Card PLP | `store/snipplets/product_grid.tpl` + `item.tpl` | Nos índices 1 e 2, alinhar a prop `image_lazy` com a classe (hoje a classe tira `lazyload` e a prop pede lazy). Não marcar a grade inteira como eager. |
| PDP | `store/snipplets/product/product-image.tpl` | Primeira mídia já é eager/high. Garantir `width`/`height` e o `padding-bottom` da razão. Thumbs e demais slides continuam `lazyload`. Vídeo da galeria não vira a primeira mídia sem pedido do lojista. |
| Newsletter / banners | `home-newsletter.tpl`, `home-banners.tpl`, `home-banners-grid.tpl` | `width`/`height` ou aspect no SCSS do bloco. Lazy só abaixo da dobra. O `src` placeholder deixa de ser a imagem de LCP se o bloco for o primeiro. |
| Cookie | `store/snipplets/notification.tpl` e o trecho de `paddingBottom` em `store/static/js/store.js.tpl` | Barra continua `fixed`. Reservar o `padding` do rodapé no CSS, no primeiro paint, em vez de medir no JS. Não remover o texto nem o botão. |
| Popup | `store/snipplets/home/home-popup.tpl` | Modal continua overlay. Imagem do popup permanece lazy. Não abrir no fluxo do documento. |
| Frete | `snipplets/shipping/shipping-calculator.tpl` | Reservar altura mínima da lista de opções. Não mover o bloco. |
| JS | `layouts/layout.tpl`, `static/js/external*.js.tpl`, `static/js/store.js.tpl` | Não duplicar o lazysizes (Lasanday: preload no head e include no body). Não colocar GTM novo no tema. Tags de `{% head_content %}` ficam no admin. |
| Vídeos curtos / stories (iShorts, Tolstoy, Wide) | Wrapper no tema: snipplet da seção que contém o container do widget e o gatilho em `src/main.ts` (publicado em `static/js/main.js`) | O app é externo. Não editar o script interno do widget e não desinstalar o app. Atrasar a inicialização: o container fica no HTML com o espaço da seção reservado (aspect-ratio ou min-height, sem mudar o layout) e o script/embed só entra quando um `IntersectionObserver` vê a seção perto da viewport, ou no primeiro gesto de rolagem/interação. Até lá, nenhum `.mp4` nem thumbnail do widget é pedido. |
| CSS do lojista | `settings.css_code` no admin | Fora do PR de tema, a menos que o chamado aponte uma regra desse campo. |

Setting novo em `config/settings.txt` pede republicar o tema e preencher o campo no admin. Imagens já salvas no slider não se perdem se o atributo novo for opcional no `.tpl`.
