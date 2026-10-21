# VTEX IO — referência de triagem PageSpeed

Lojas lidas: `lojasupersaudavel` (tema só de blocos, sem builder `react`) e `electricink` (tema + apps citados em `apps-citados/`). Conteúdo de banner/prateleira publicado no Site Editor sobrescreve o JSONC do git. Conferir o bloco no admin antes de cotar alteração que o lojista já desfez no editor.

Builders típicos do tema: `store` 0.x, `styles` 2.x, `assets` 0.x, `checkout-ui-custom` 0.x. Pixels de marketing instalados na conta (Admin > Apps) não aparecem no `manifest.json`.

## 1. Anatomia

| Peça | Onde declarar | Como |
|---|---|---|
| Hero imagem | `store/blocks/pages/home/home.jsonc` | `list-context.image-list#main` → `slider-layout#main-images`. Props do list: `height`, `images[].image` / `mobileImage` / `phoneImage`. Props do slider: `itemsPerPage`, `autoplay.timeout`, `infinite`, `showNavigationArrows`, `blockClass`. |
| Hero vídeo | `store/blocks/components/main-banner/index.jsonc` | `list-context.media-list#banners__carousel` (`mediaList[]`: `video`, `mobilevideo`, `loop`, `autoPlay`, `fetchpriority`, `loading`) dentro de `embla-carousel#banners__carousel` (`options.slidesToShow`, `loop`, `autoplay.delay`). App de mídia: `vtex.store-video` via `list-context.media-list` / `vtex.store-media`. |
| Abaixo da dobra | mesmo `home.jsonc` | `__fold__.experimentalLazyAssets` logo após o hero (Super Saudável). Banners seguintes são `image#…` com `src`, `maxHeight`, `maxWidth`, `width`. |
| Card de prateleira | `store/blocks/components/shelf/shelf.jsonc` | `product-summary.shelf` → `product-summary-image` (`aspectRatio`, `width`, `height` por device, `badgeText`, `hoverImage`, `fetchpriority`, `showBadge`). Lista: `list-context.product-list#…` + `slider-layout#shelf` (`itemsPerPage`, `infinite`). |
| PLP | `store/blocks/pages/search/` | Mesmo `product-summary.shelf` (ou variação `shelf/search`). Electric Ink força `fetchpriority: "low"` em `shelf/components/product-image/index.jsonc`. |
| Galeria PDP | `store/blocks/pages/product/product.jsonc` | Super Saudável: `agenciaeplus.store-components:product-images` (`aspectRatio`, `thumbnailAspectRatio`, `thumbnailMaxHeight`, `maxHeight`, `maxWidth`, `zoomMode`, `displayThumbnailsArrows`) + `product-images-swiper`. Electric Ink: `product-medias#summary__medias` em `pages/product/summary/slider/index.jsonc` (`videoProps.autoplay/loop/playing`, `optionsZoom`) + `embla-carousel#summary__medias-slider`. |
| Cookies | `store/blocks/components/cookies/index.jsonc` | `storage-layout` + `rich-text` + `action-button` (`closeAndSave`). Não é modal nativo do browser. |
| Newsletter | footer | `vtex.store-newsletter` em `common/footer/newsletter/`. |
| CEP | PDP | App da loja, ex. `lojasupersaudavel.shipping-simulator` em `pages/product/shipping-simutalor/shipping-simulator.jsonc`. Não é `vtex.store-components` shipping nativo. |
| Scripts de head | tema vs admin | Tema: `helmet#…` (`common/header/helmet/`) e apps no `manifest.json` (`agenciaeplus.trustvox`, `agenciaeplus.instafeed`, `lojasupersaudavel.netdeal-app`, `lojasupersaudavel.helmet`). GTM/Meta/TikTok de pixel app da conta ficam fora do git. |

`manifest.json` da Super Saudável não tem builder `pixel`. Trustvox entra como bloco de tema: `trustvox-review-carrousel-scripts` e `trustvox-starts-scripts` dentro do card.

## 2. Armadilhas reais (LCP, CLS, TBT/INP)

**LCP**

- Hero da Super Saudável não declara `fetchpriority`, `preload` nem `experimentalPreventLayoutShift`. `height: 470` no image-list não vira `fetchpriority="high"` na primeira imagem. Arquivos são PNG em `assets/images/home/`, servidos pelo builder `assets`, sem `srcset`.
- `slider-layout` com `infinite: true` e `autoplay` clona slides e atrasa a pintura estável do primeiro frame. O primeiro slide só é LCP candidato depois que o slider monta.
- Electric Ink: o hero é MP4 externo (`electricink.admin.core.dcg.com.br/...mp4`) com `autoPlay` + `loop` e `fetchpriority: "high"`. O JSONC não envia `poster`. O schema de `apps-citados/store-media/store/contentSchemas.json` já tem `poster` (`$ref` para `vtex.store-video`). Sem esse campo preenchido, o LCP espera o primeiro frame do vídeo.
- O Embla do hero aplica o modificador CSS `loading` enquanto `embla` ainda é nulo (`apps-citados/embla-carousel/react/components/EmblaCarousel/index.tsx`). O primeiro frame fica retido até o JS do carrossel.
- `__fold__.experimentalLazyAssets` está no lugar certo (depois do hero). Não mover o hero para baixo do fold.

**CLS**

- `image#action-banner`, `image#triple-banner-*` e várias imagens de home não têm `width`/`height` juntos. `maxHeight` sozinho não reserva a caixa antes do download.
- `product-summary-image` da Super Saudável tem `aspectRatio: "1:1"` e `width`/`height` (225/145). Electric Ink no shelf de busca declara só `fetchpriority: "low"` e `hoverImage`, sem `aspectRatio` — hover da segunda foto troca a altura se a mídia vier sem caixa.
- Cookie bar (`storage-layout`) e selos `super-badge` entram depois da pintura. Trustvox no card (`trustvox-summary-stars`) injeta estrela sem altura reservada.
- Sticky header (`vtex.sticky-layout`) com `opacity: 0` até o estado `--stuck` em `sass/header/vtex.sticky-layout.scss` não é CLS de conteúdo, mas esconde faixa até o JS.

**TBT / INP**

- Home Super Saudável hidrata 4+ `slider-layout` infinitos, `product-summary` com preço, selo, compra programada e `add-to-cart-button` em cada card, mais `agenciaeplus.instafeed` e carrossel Trustvox. `trustvox-starts-scripts` está dentro de `product-summary.shelf`: o script de review roda por card.
- `helmet` em `common/header/header.jsonc` injeta no tema, sem `async` em vários: Zendesk (`zdassets`), Netdeal, `mtm.js`, `cashback.js`, `smartBanner.js`, `removePaused.js`, `agenticCxLauncher.js`, `subscriptionContactModal.js` e o loader da RD Station. Isso é TBT de tema, não pixel do admin. Fontes: vários pesos de Montserrat em `styles/configs/font-faces.css` sem `font-display`.
- `super-badge` com `queryOptions.ssr: true` dispara query por card.
- Electric Ink troca `slider-layout` por `embla-carousel` no hero e na galeria. O custo de JS continua: Embla + `product-medias` com vídeo autoplay no card da PDP.
- Apps no manifest (menu, search-result fork `agenciaeplus.search-result`, minicart fork, giftcards, netdeal) hidratam com o render-runtime mesmo fora da dobra. Só abrir o app se o achado desta página cair nesse handle e o tema não resolver.

## 3. Não cotar como código de tema

- TTFB do render-runtime / GraphQL de catálogo e do Intelligent Search. O tema não controla o SSR da VTEX.
- Pixels ligados no admin da conta (GTM, Meta, TikTok, Hotjar). Não estão no tema; limpeza é do lojista no Admin ou no container.
- Resize do serviço de imagem VTEX (`*.vteximg.com.br` / `vtexassets`). `width`/`height` do bloco só pedem um recorte; qualidade e formato (webp/avif) são da plataforma.
- Conteúdo já salvo no Site Editor. Mudar o default no JSONC não altera o bloco publicado.
- Checkout (`checkout-ui-custom`) é outro deploy e não entra na home/PLP/PDP do PageSpeed de vitrine.
- Trocar vídeo de hero por imagem estática é sugestão de redesign, cotada à parte.
- App nativo `vtex.*` cuja prop o tema já não controla (ex.: `slider-layout` nativo sem `fetchpriority` no primeiro slide). Registrar a limitação; não cotar fork de app VTEX neste chamado.
- Varrer `manifest.json` ou auditar apps que não pintaram o LCP / CLS / script bloqueante desta URL.

## 4. Portão de apps (só se o tema não resolver)

Tema sem builder `react` só declara blocos. Quem pinta `img`/`video`/`script` é o app. A classe do PSI (`{vendor}-{app}-{major}-x`) ou o bloco `vendor.app:interface` identifica o handle. Não abrir o `manifest` inteiro.

| Prefixo / bloco | Destino | O que ler |
|---|---|---|
| `vtex.slider-layout`, `vtex.store-components`, `vtex.product-summary` | Tema. Se a prop nativa não existir, “Não cotar”. | JSONC do bloco + CSS do `blockClass`. |
| Vendor da loja ou `agenciaeplus` (`lojasupersaudavel.store-image`, `lojasupersaudavel.helmet`, `lojasupersaudavel.super-badge`, `lojasupersaudavel.container`, `agenciaeplus.image-flip-list`, `agenciaeplus.store-components`, `agenciaeplus.trustvox`, `agenciaeplus.instafeed`) | App, **só** se a prop do tema for ignorada ou inexistente. Repo `agencia-e-plus/{app}`, branch da loja; senão `master` com aviso de impacto em outras lojas. | `store/contentSchemas.json` (ou `interfaces.json`) e o React que renderiza a mídia/script. |
| Pixel do Admin | Fora. | Não está no git do tema. |

Checagem curta (um arquivo, não auditoria): o schema aceita a prop? O React aplica no DOM? Se sim, a hora fica no tema / Site Editor. Se não, a hora é release do app (2h a 4h) além do tema.

Exemplos desta loja: `helmet` no `header.jsonc` já declara `async`; se `lojasupersaudavel.helmet` descartar `tagProps`, o TBT não muda só com o JSONC. `super-badge` com `queryOptions.ssr: true` é query por card no app, não no tema. `image-flip-list` (departamentos / marcas) pinta as imagens do slider: dimensões só no JSONC não bastam se o React não as passa.

Teto: 2 ou 3 apps por chamado, os da região do PSI.

## 5. Handoff (otimização funcional, sem redesign)

| Alvo | Arquivo | Props / atributos |
|---|---|---|
| Hero imagem | `store/blocks/pages/home/home.jsonc` no bloco `list-context.image-list#*` e `slider-layout#*` | Na primeira mídia: `experimentalPreventLayoutShift: true` quando o bloco `vtex.store-image`/`list-context.image-list` da conta expuser a prop; `width` e `height` reais da arte; manter `__fold__` abaixo do hero. No slider, não remover `infinite`/`autoplay` (mudaria o comportamento). Se o Site Editor tiver o bloco salvo, repetir as props lá. |
| Hero vídeo | `store/blocks/components/main-banner/index.jsonc` `mediaList[]` | Manter `fetchpriority: "high"` e `loading: "eager"` só no primeiro item. Preencher `poster` (o schema do `store-media` já aponta para `vtex.store-video`). Não desligar `autoPlay`/`loop`. Se o bloco "Banners Principais" estiver salvo no Site Editor, a prop nova entra por lá. O modificador `loading` do Embla é correção no app `embla-carousel`, não no JSONC. |
| Card / PLP | `store/blocks/components/shelf/shelf.jsonc` e a variação em `pages/search/` | `product-summary-image`: `aspectRatio`, `width`, `height` (faixa ~280–300 no desktop, menor no phone), `fetchpriority: "low"` fora da primeira dobra, `hoverImage` preservado. `slider-layout#shelf`: não tirar `infinite`. |
| PDP | `pages/product/product.jsonc` ou `pages/product/summary/slider/index.jsonc` | `aspectRatio` / `maxHeight` / `maxWidth` já existentes. Primeira mídia eager; thumbs com `thumbnailMaxHeight` coerente. Não desligar `zoomMode`. |
| Cookies / CEP / newsletter | `components/cookies/index.jsonc`, `shipping-simulator.jsonc`, `footer/newsletter/` | Reservar `min-height` via `blockClass` no CSS do tema (`styles/css` ou `sass`), sem mudar copy. Cookie continua `storage-layout`. |
| Terceiros de tema | `header.jsonc` `helmet.tags[]`, `shelf.jsonc` `trustvox-starts-scripts`, `instafeed.jsonc` | `async`/`defer` nas tags do helmet que não precisam no primeiro frame. Trustvox por card: um script na página, não um por `product-summary`. Pixel de admin: fora do handoff. Se o app `helmet` não repassar `tagProps.async`, a correção é no app, não só no JSONC. |
| App fork (quando o tema não resolve) | `agencia-e-plus/{app}` na branch da loja | Schema + React do componente que pinta o achado. Publicar o app e o tema. Não alterar `vtex.*`. |

Recadastro: incluir prop nova num bloco que já está no Site Editor exige o lojista republicar o conteúdo desse bloco. IDs de coleção (`category`, `collection`, `orderBy`) não se apagam se a prop nova for só de mídia.
