# Shopify (tema Liquid / Online Store 2.0) — referência de triagem PageSpeed

Lojas lidas: `consuladodorock` (tema **Eurus** 9.7.1, `src/layout/theme.liquid`, `src/sections/slideshow.liquid`) e `shopify/camilaklein` (tema **Broadcast** 5.1.1, `src/layout/theme.liquid`, `src/sections/section-slideshow.liquid`, `src/sections/section-hero.liquid`). As duas são Liquid, não Hydrogen. Checkout não está no tema.

`{{ content_for_header }}` é injetado pela Shopify e pelos apps instalados. O git não lista esses scripts. App embed e pixels do admin ficam de fora da cotação de tema.

## 1. Anatomia

| Peça | Consuladodorock | Camila Klein |
|---|---|---|
| Head | `src/layout/theme.liquid`. Preload de `theme.css`, fonte (`font_url`), `content_for_header` ~linha 102. | `src/layout/theme.liquid`. Preload de `theme.css`, `vendor.js` e `theme.dev.js`. Stub `dataLayer`. `content_for_header` ~linha 253. Noscript GTM `GTM-PJFR4S2`. Comentário aponta snippet `analytics-deferred`. `@font-face` Futura com `font-display: swap`. |
| Hero / slider | `src/sections/slideshow.liquid` + `src/snippets/image-slideshow.liquid` e `video-slideshow.liquid`. Schema do bloco: `image`, `image_mobile`, `video`, `mobile_video`, `video_url` (YouTube/Vimeo). Altura: `desktop_height` / `mobile_height` ou `padding-bottom` pelo `aspect_ratio` da primeira mídia. Setting `show_hero` decide eager vs lazy. | `src/sections/section-slideshow.liquid` e `section-hero.liquid`. Snippet `src/snippets/image-hero.liquid` (`loading`, `fetchpriority`, `preload`, `desktop_height`, `mobile_height`). Primeiro slide: `fetchpriority='high'`, `slide_loading='eager'`. |
| Vídeo | `src/snippets/media-video.liquid` e `shoppable-video.liquid`: `video_tag` com `poster: ''` (apaga o poster nativo do arquivo Shopify). | `src/snippets/media.liquid`: primeira mídia `fetchpriority='high'` + `preload`. Vídeo Shopify com `preload: 'none'` no `media_tag`. `photoswipe-video-html.liquid` também `preload: false`. |
| Card | `src/snippets/card-product*.liquid` e `src/sections/card-product.liquid`. `image_url` + `image_tag` com `widths` e `sizes`. Há card com `preload: true` e `loading: 'lazy'` no mesmo filtro (contraditório). | Grade via `src/snippets/product-grid-item` (tema Broadcast) referenciada pelas sections de coleção. |
| PDP | `src/sections/main-product.liquid`, `src/sections/media-gallery.liquid`, `src/snippets/product-template.liquid` (classe `preload-image`). | `src/sections/product.liquid` + `src/snippets/media.liquid`. |
| Newsletter / popup | `src/sections/newsletter.liquid`, `popup-promotion.liquid`, `popup-age-verification.liquid`. | `src/sections/section-newsletter.liquid`, `src/sections/popups.liquid`, `rdstation.liquid`. |
| Apps | `src/sections/apps.liquid` (`{% section 'apps' %}` / app blocks). | `src/sections/apps.liquid`. RD Station é section do tema, não app embed. |

Imagens passam por `image_url` / `image_tag` no CDN `cdn.shopify.com`. `widths` é a lista de candidatos; `sizes` escolhe qual baixa.

## 2. Armadilhas reais

**LCP**

- Consul, `slideshow.liquid` e `snippets/image-slideshow.liquid`: `fetchpriority="high"` e `loading="eager"` só se `section.settings.show_hero and forloop.first`. A home publicada (`templates/index.json`, seção `slideshow_7EJi9t`) tem `show_hero: true`, mas o primeiro bloco `slide_N9FAeN` está `disabled: true`. O `forloop.first` aponta para um slide que não pinta; o slide visível pode sair `lazy`. Há ainda um `<img>` oculto com `preload: true` e `loading: 'lazy'` (largura de fallback 3840).
- O setting global `enable_lazy_loading_image` nasce `true` no schema do Eurus. Com `show_hero` desligado, o hero inteiro fica lazy.
- O mesmo arquivo, ramos com `image_tag`, combina `preload: true` e `loading: 'lazy'` (ex. linhas ~421 e ~798). O preload disputa banda com uma imagem que o parser marcou para adiar.
- Parallax (`parallax-image` / `x-intersect`) em volta da `<img>` atrasa o pedido até o Alpine observar o bloco.
- `media-video.liquid` força `poster: ''` e, num ramo, `preload: 'auto'` no vídeo. LCP vira o primeiro frame do MP4, sem imagem estática. `shoppable-video.liquid` repete `poster: ''`.
- Camila: `theme.liquid` faz preload de `vendor.js` (~71 KB) e `theme.dev.js` (~439 KB) no `<head>`, na frente da imagem do hero. `snippets/loading.liquid` (splash, renderizado no `body` antes do conteúdo) também pede `fetchpriority: 'high'`. O primeiro slide do slideshow ainda manda imagem desktop e mobile ambas eager/high.
- Camila slideshow já diferencia o primeiro slide (eager/high). Não recotar esse ajuste se o relatório apontar outro slide (banner de coleção usa `collection-image-with-title.liquid`, que já passa `loading: 'eager'` e `fetchpriority: 'high'`).

**CLS**

- Consul reserva altura do primeiro bloco com `padding-bottom` a partir de `aspect_ratio` do vídeo ou da imagem. Slide seguinte com proporção diferente ainda pula quando entra.
- `image_tag` sem `width`/`height` (quando o filtro não recebe as dimensões do objeto) deixa o card sem caixa. O filtro da Shopify emite dimensões se a mídia for um objeto `image`, não uma URL solta.
- Popup (`popup-promotion`, `popups.liquid`) e barra de cookies nativa da Shopify (Customer Privacy, fora do tema) aparecem depois do load.
- Fonte: Consul faz preload da fonte do `settings`. Camila declara `@font-face` local sem garantir `unicode-range`; `font-display: swap` evita texto invisível e pode gerar CLS curto de fonte.

**TBT / INP**

- `vendor.js` + `theme.dev.js` (Camila) e o bundle do tema Ecomus (Consul: slideshow, predictive search, cart drawer, quick view) executam na main thread.
- App embeds dentro de `content_for_header` e `sections/apps.liquid` não saem com um PR de Liquid.
- RD Station (`rdstation.liquid`) e reviews (`section-reviews.liquid`, `reviews.liquid`) são JS de terceiro empacotado como section.

## 3. Não cotar como código de tema

- Scripts que a Shopify injeta em `content_for_header` (apps, web pixels, Trekkie, checkout preloads).
- Transformação de imagem do CDN (`image_url`). O tema escolhe `widths` e `sizes`; o formato é da Shopify.
- Checkout extensibility e páginas de conta hospedadas fora do tema, quando o relatório não for a vitrine.
- Banner de consentimento nativo (Shopify Privacy) quando não há section própria no tema.
- Hydrogen / Oxygen. Estas lojas não são esse runtime.
- Trocar slideshow por imagem única, ou remover parallax visível, é redesign se o lojista aprovou o efeito.

## 4. Handoff

| Alvo | Arquivo | O que editar |
|---|---|---|
| Hero Consul | `src/sections/slideshow.liquid` e `src/snippets/image-slideshow.liquid` | Eager/high no primeiro slide **visível**, não no `forloop.first` se o bloco estiver `disabled` em `templates/index.json`. Tirar o par `preload: true` + `loading: 'lazy'` do `<img>` oculto. Baixar o `src` de fallback de `width: 3840`. Não remover parallax sem aprovação. |
| Vídeo Consul | `src/snippets/media-video.liquid`, `src/snippets/shoppable-video.liquid` | Trocar `poster: ''` pelo preview do vídeo (`video.preview_image`) ou por `block.settings.image`, e `preload: 'metadata'` no hero (não `'auto'`). Autoplay/loop/muted permanecem. |
| Card Consul | `src/snippets/card-product*.liquid` | `loading: 'lazy'` abaixo da dobra; tirar `preload: true` quando `loading` for lazy. `widths` na faixa do card, não 1500 se o slot é ~300. |
| Hero Camila | `src/sections/section-slideshow.liquid`, `src/snippets/image-hero.liquid` | O primeiro slide já está eager/high. Ajustar `sizes` e alturas `desktop_height` / `mobile_height` do schema se o PSI mostrar arquivo maior que o slot. |
| Head Camila | `src/layout/theme.liquid`, `src/snippets/loading.liquid` | Remover `preload_tag` de `vendor.js` e `theme.dev.js` (manter o de CSS). No splash, não usar `fetchpriority: 'high'` na imagem de loading se ela não for o LCP. Não apagar o stub `dataLayer` nem o noscript do GTM. O loader adiado está em `snippets/analytics-deferred.liquid`. |
| PDP | `src/snippets/media.liquid` (Camila), `src/sections/media-gallery.liquid` (Consul) | Primeira mídia eager/high; thumbs e vídeo de galeria com `preload: 'none'`. |
| Popups | `popup-promotion.liquid`, `popups.liquid`, `section-newsletter.liquid` | Abrir em `position: fixed` sem empurrar o `body`. Não remover o popup. |
| Apps | — | Não editar `content_for_header`. Section `apps.liquid` só se o app block estiver no JSON do template e a otimização for atributo que o tema controla. |

Settings de schema (`show_hero`, alturas, imagem mobile) ficam no JSON do template (`templates/*.json`) e no editor de temas. Mudança de schema com setting novo pede republicar o template; imagem já cadastrada no bloco não se perde.
