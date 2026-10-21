# FastStore — referência de triagem PageSpeed

Lojas lidas: `faststore/faststore-formosa` (override de seções em React, CMS Headless da VTEX / registry com shape legado `Hero`) e `faststore/faststoretorra` (seções próprias, parte ainda com contrato Deco em `src/sections/*.tsx`, `next/image` e `next/head`).

As duas falam com catálogo e Intelligent Search da VTEX. Checkout headless não é a vitrine. Imagem de produto costuma ser URL `*.vtexassets.com` / `vteximg`. Conteúdo de banner publicado no CMS remoto não está no git; o componente só define o schema.

## 1. Anatomia

| Peça | Formosa | Torra |
|---|---|---|
| Hero | Legado, fora da home publicada: `src/components/sections/Hero/Hero.tsx`. A home em `cms/content/home.json` usa a seção `FormosaBanner`. O registry em `src/components/index.tsx` faz `Hero: FormosaBanner`. `FormosaBanner.tsx`: `picture` + `source` mobile, eager no índice 0, sem `fetchPriority`. | `src/components/sections/banner-slider/BannerSliderPicture.tsx` + `BannerSliderLcpHints.tsx` (`next/head`, preload com `media` e `fetchPriority="high"`). Props da section: `preload` (default true), `skipLazyLoadingSection`. |
| Reserva de caixa | FormosaBanner: CSS vars `--fb-aspect-desktop` e `--fb-aspect-mobile` a partir de `desktopWidth`/`desktopHeight`/`mobileWidth`/`mobileHeight` do CMS. Hero legado não tem aspect no TSX. | `image.layout.desktop` / `image.layout.mobile` no `picture`. |
| Card | `src/components/sections/Shelf/ShelfProductCard.tsx` e `FormosaShelf/FormosaShelfCard.tsx`. `loading={index < 4 ? 'eager' : 'lazy'}`. A caixa 1:1 está no SCSS (`.cardImageBox`), não no `<img>`. | `src/components/common/product-card/index.tsx` + `ProductCardMedia.tsx`. Defaults 320×400. `fetchPriority` high só se `preload`. A PLP passa `preload` no índice 0; `ProductShelf` do carrossel não passa. |
| PDP | `src/components/sections/ProductDetails/CustomImageGallery.tsx`. Principal `loading="eager"` sem `fetchPriority` nem dimensão. Thumbs `loading="lazy"`. | Galeria da PDP: `src/components/sections/product-details/gallery/index.tsx` (`priority={index === 0}`, `sizes` ~480px). `image-gallery/ImageGallery.tsx` é outra seção e marca thumbs `lazy`. |
| CEP / newsletter | CEP de montagem em `ProductDetails/Modals.tsx` (estado `cep`). Newsletter: resolver GraphQL `src/graphql/vtex/resolvers/newsletter.ts` (Master Data `NT`), não um pixel. | Seções de UI da loja; GTM não fica no resolver. |
| Scripts | `src/scripts/ThirdPartyScripts.tsx` só publica favicon. `discovery.config.js` tem `analytics.gtmContainerId: ""` (GTM nativo do core desligado). | `src/sections/ThirdPartyScripts.tsx` (schema `gtmContainerId`, default `GTM-PGVW3R29`) → componente com `gtmDelayedLoaderScript`. `discovery.config.js` deixa `gtmContainerId: null` para não duplicar. |

Outros blocos Formosa com `<img loading>`: `BannerGrid`, `FormosaThreeBanners` (sempre lazy), `DepartmentHero` (eager), `FormosaServicoMontagem` (`fetchPriority="high"`). Torra: `banner-mosaic` calcula `fetchPriority: 'high'` só no primeiro se `preload`; `banner-full-width` e `banner-compre-e-retire` usam eager.

## 2. Armadilhas reais

**LCP**

- `Hero.tsx` não é a home publicada (`cms/content/home.json` aponta `FormosaBanner`). Cotar o legado só se o PSI for de uma LP que ainda resolve a section `Hero`.
- `FormosaBanner` reserva aspect via CMS, mas a `<img>` não tem `fetchPriority` nem `width`/`height`. `decoding="async"` no slide 0 compete com a pintura do LCP. O card da prateleira tem `aspect-ratio: 1/1` no SCSS e eager nos 4 primeiros de **cada** shelf.
- Sem `desktopWidth`/`desktopHeight` preenchidos, o comentário do componente diz que cai no tamanho padrão da loja — caixa errada se o fallback não bater com a arte.
- Torra já trata o atraso de preload: o comentário em `BannerSliderLcpHints.tsx` mede ~595 ms de resource load delay porque um `<link>` no corpo só é visto depois do mega-menu. O hint tem que continuar em `next/head`. React 18 não içá `<link>` sozinho.
- `BannerSliderPicture` pode nascer com `src` undefined quando `deferSrc` é true e só preencher no `IntersectionObserver`. No slide 0, `deferSrc` não pode ser true.
- URLs `vtexassets` com recorte `-768-auto` (defaults do FormosaBanner) ignoram densidade da tela; o PSI acusa arquivo pequeno esticado ou grande demais conforme o slot.

**CLS**

- Hero legado sem aspect. O track usa `translate3d` em `<ul>`; a altura segue a imagem. Sem caixa, o header transparente (`NavbarCustom`, margem negativa do hero) pula quando a imagem chega.
- FormosaBanner está correto desde que as quatro dimensões do CMS existam. Cotar “ligar aspect” só se o bloco publicado estiver sem elas.
- Galeria Formosa: `<img>` principal sem width/height. Thumbs lazy sem caixa empurram a coluna se o CSS do módulo não fixar o viewer.
- Card Torra já tem aspect. Card Formosa: confirmar no SCSS do shelf se a foto tem ratio; o TSX não passa width/height.

**TBT / INP**

- Hero e banner Formosa são client components com `setInterval` de autoplay e listeners de `visibilitychange` / mouse. Várias vitrines repetem o padrão.
- Torra adia o GTM de propósito. Religar o pixel nativo do `@faststore/core` junto com esse loader duplica o container.
- Formosa `ThirdPartyScripts` não carrega GTM. Se o PSI mostrar tags, elas vêm do CMS, de um override de `_app` do core, ou do que foi publicado fora desse arquivo — não cotar “remover GTM do ThirdPartyScripts” dessa loja.
- `ShelfProductCard` marca eager os 4 primeiros de cada prateleira. Quatro prateleiras = 16 imagens eager.

## 3. Não cotar como código de tema

- TTFB da FastStore API, Intelligent Search e do resolver GraphQL de catálogo.
- CDN de imagem VTEX (`vtexassets` / `vteximg`). O loader pede largura; o formato é da VTEX.
- Checkout e `orderPlaced` fora do storefront.
- Conteúdo de slides no Headless CMS / Deco CMS da Torra. O default `DEFAULT_SLIDES` do FormosaBanner só aparece antes do CMS publicar.
- Partytown / pixel nativo do core, quando a loja não o desligou no `discovery.config` / cms. Não assumir que editar `ThirdPartyScripts.tsx` da Formosa mexe em tag de marketing.

## 4. Handoff

| Alvo | Arquivo | O que editar |
|---|---|---|
| Hero Formosa (section antiga) | `src/components/sections/Hero/Hero.tsx` | No índice 0: `fetchPriority="high"`, `width` e `height` (ou aspect no SCSS `hero.module.scss`), `decoding="sync"`. Slides seguintes continuam `lazy`. Não remover autoplay. |
| Banner Formosa | `FormosaBanner.tsx` + schema da section | Índice 0: `fetchPriority="high"`. Preencher `desktopWidth`, `desktopHeight`, `mobileWidth`, `mobileHeight` no CMS para as CSS vars. Não deixar o slide 0 com `decoding="async"`. |
| Preload Torra | `BannerSliderLcpHints.tsx` | Manter os dois `<link>` em `next/head`, `media` separado, `key` por URL. Não mover o preload para o JSX do picture. |
| Slide Torra | `BannerSliderPicture.tsx` e o resolvedor `resolve-slides` | Slide 0: `deferSrc` false, `loading="eager"`, `fetchPriority="high"`, `decoding="sync"`. Demais: `deferSrc` + lazy. |
| Card | Formosa: `ShelfProductCard.tsx` / `FormosaShelfCard.tsx` (eager só na primeira dobra, não `index < 4` em toda prateleira; a caixa 1:1 do SCSS permanece). Torra: `product-card/index.tsx` e o call site `ProductShelf` (passar `preload` só no primeiro card acima da dobra; a PLP já faz isso no índice 0). |
| PDP | Formosa: `CustomImageGallery.tsx` (`fetchPriority="high"` e dimensão na principal). Torra: `product-details/gallery/index.tsx` (já tem `priority` no índice 0; não recotar se o PSI for só a thumb). |
| GTM Torra | `ThirdPartyScripts.tsx` (component e section) | Manter injeção pós-load. Trocar só `gtmContainerId` se o container estiver errado. Não voltar o pixel nativo do core em paralelo. |
| GTM Formosa | não está em `src/scripts/ThirdPartyScripts.tsx` | Localizar a tag no override do core ou no CMS antes de estimar hora de tema. |

Campo novo no schema da section pede republicar o conteúdo no Headless CMS. Slides já cadastrados permanecem se a prop for opcional.
