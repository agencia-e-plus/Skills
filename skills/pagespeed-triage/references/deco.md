# Deco.cx (Fresh) — referência de triagem PageSpeed

Organização GitHub: os temas e repositórios da Deco.cx ficam centralizados na organização oficial `github.com/deco-sites/{nome-da-loja}` (diferente das demais stacks da agência, que usam `agencia-e-plus`).

Lojas lidas: `miess-01` e `phytoterapica`. Seção = arquivo em `sections/` que reexporta um componente (`export { default, loader }`). Schema do CMS é a `interface Props` com anotações `@title` / `@description`. Conteúdo publicado vive no admin Deco (blocos), não só no git. Islands ficam em `islands/` e hidratam no cliente; componente em `components/` renderiza no SSR.

`Image` / `Picture` / `Source` vêm de `apps/website/components/`. O `srcset` aponta para o CDN Deco (`deco-assets.edgedeco.com`, `deco-assets.decoazn.com`, origem `decoims.com`). `quality="original"` não impede o `srcset` compactado. Isso é pipeline de mídia, não alavanca de LCP por si só — ver skill `deco-image-quality-debugger` se o chamado for nitidez.

## 1. Anatomia

| Peça | Miess | Phytoterapica |
|---|---|---|
| Hero | `sections/Images/Carousel.tsx` → `components/ui/BannerCarousel.tsx`. Props: `banners[]` (`desktop`, `mobile`, `alt`, `href`, `scheduling`, `ga4`), `interval`. | `sections/Images/Carousel.tsx` → `components/ui/BannerCarousel.tsx`. Props: `images[]` (`desktop`, `mobile`, `alt`, `link`, `endDate`, `endTime`, `timerText`), `preload`, `arrows`, `dots`, `interval`. |
| Imagem do hero | `Picture preload={lcp}` + `Source` (`fetchPriority`, `loading`, `media`, `width`, `height`) + `Image` com `aspect-[768/500] lg:aspect-[1920/450]`. `lcp` é hardcoded `index === 0`. Fator `IMAGE_REDUCTION_FACTOR = 0.75`. | Igual, com `lcp={index === 0 && preload}`. Caixa `aspect-[430/412] lg:aspect-[1920/540]`. `preload` default `true` só no fallback de código; no CMS é checkbox. |
| Slider JS | `SliderJS` importado de `components/ui/SliderJS.tsx` (não é island na Miess). | `SliderJS` importado de `islands/SliderJS.tsx`. Cronômetro: `islands/BannerCarouselCountdown.tsx`. |
| Card | `components/product/ProductCard.tsx`. `Image` width/height = `355 * 0.75` desktop e `160 * 0.75` mobile, `sizes`, `preload`, `loading`, `aspect-square`. Sem `fetchPriority`. Hover (`vitrineVira`) é segundo `Image` com `loading="lazy"`. A shelf (`ProductShelf.tsx`) não repassa `preload`. Compra: island `islands/Product/AddToCartWithQuantitySelector.tsx`. Selo: `div.konfidency-badges`. | `components/product/ProductCard.tsx`. Layout lista (80×80) respeita `preload`. Layout de vitrine (346×346, `aspectRatio` no `<figure>`) fixa `loading="lazy"` e `fetchPriority="low"` e ignora `preload`. `ProductGallery` manda `preload` só no índice 0; a shelf não. Islands: `islands/AddToCartButton/vtex.tsx`, `islands/ProductCountdown.tsx`. |
| Galeria PDP | `components/product/ProductDetails/ImageSlider.tsx`. Primeira: `preload`, `loading="eager"`, `fetchPriority="high"`. Thumbs: `fetchPriority="low"` + `loading="lazy"`. Zoom desktop: island `islands/ZoomableImage.tsx`. | `components/product/ProductImageGallery.tsx`. Container `aspect-square`. Primeira `Image` 712×712 eager/high; zoom desktop é island. |
| Newsletter / cookies / CEP | `sections/Newsletter/`, `islands/Newsletter.tsx`, `islands/popup.tsx`, `sections/Modals/`. CEP: `islands/ShippingSimulation.tsx`. Cookie/GTM: `sections/Analytics/SoureiCookieShield.tsx`. | `sections/Newsletter/Newsletter.tsx`, `islands/Newsletter.tsx`, `islands/NewsletterPopup.tsx`, `islands/ButtonCookies.tsx`. CEP: `islands/ShippingSimulation.tsx`. |
| Scripts | Sourei injeta `soureicdn.miess.com.br/{loja}.js` no lugar de `gtm.js`, mais iframe `ns.html?id=GTM-5PCJKR3`. Ponte `DECO.events` → `dataLayer` na mesma section. Konfidency entra em `components/GlobalTags.tsx` (`reviews.konfidency.com.br/.../loader.js`, `defer`, mais observers inline). | Global em `.deco/blocks/site.json`: `website/sections/Analytics/Analytics.tsx` com `dangerouslyRunOnMainThread: true` e `GTM-MGK7C49`, mais Algolia e Smarthint. `sections/ThirdPartyScripts.tsx` é camada extra: `scriptDataArray[]` (`url`, `htmlID`, `delay` default 5000, `active`). |

Outros blocos de mídia: `sections/Images/ShoppableBanner.tsx`, `sections/Images/ImageGallery.tsx` (mosaico, `loading="lazy"`).

## 2. Armadilhas reais

**LCP**

- Miess marca LCP em todo primeiro slide, mesmo com o carrossel abaixo da dobra ou em LP. Phytoterapica só marca se `preload` estiver ligado no bloco — desligar no CMS tira `fetchpriority` e `preload` do hero.
- `Image` de fallback usa `src` desktop dentro do `Picture`. O `Source` mobile existe; se o matcher de `media` falhar, o fallback baixa a arte desktop (Miess: 1920×0.75).
- `IMAGE_REDUCTION_FACTOR` pede arquivo menor que o layout. Ajuda bytes; não substitui `preload` no `<head>`.
- Slider + `SendEventOnView` / `SendEventOnClick` em cada slide adicionam JS no elemento candidato a LCP.
- Vídeo de hero não é o padrão dessas duas homes (hero é `Picture`). Se uma section usar `<video>` sem `poster`, tratar como hero vídeo da tabela de horas.

**CLS**

- Aspect no hero está na classe Tailwind (`aspect-[…]`). Tirar a classe sem `width`/`height` coerentes reabre CLS.
- Countdown da Phytoterapica é island absoluto (`bottom-4`) sobre o banner. Sem caixa reservada no SSR, o texto do timer empurra ou sobrepõe depois da hidratação.
- `konfidency-badges` na Miess é div vazia preenchida por script de review. Sem `min-height`, o selo desloca o card. O loader em `GlobalTags.tsx` ainda observa o DOM em intervalo curto depois do load.
- As duas lojas fixam `defaultImageQuality: "low"` em `.deco/blocks/Site.json` (Miess) e `.deco/blocks/site.json` (Phytoterapica). Isso piora nitidez e peso do candidato de LCP; mudar é config do site Deco, com efeito visual na compressão. Tratar como opcional, separado da hora de tema, e não como garantia de nota.
- `NewsletterPopup` / `ButtonCookies` / `popup.tsx` montam overlay depois da ilha. Popup que ocupa fluxo (não `fixed`) gera CLS; popup `fixed` gera INP e, se empurrar o body, CLS.
- `ShippingSimulation` é island: o bloco de CEP nasce vazio e cresce ao hidratar.

**TBT / INP**

- Cada card de vitrine instancia island de add-to-cart (Miess e Phytoterapica) e, quando há oferta, `TimerJS` / `ProductCountdown`. Uma home com 4 vitrines multiplica ilhas.
- Phytoterapica: `SliderJS` do hero é island. Miess: o slider do hero é componente de servidor com JS de carrossel no bundle da página, não uma ilha isolada — o custo não some, só não aparece em `islands/`.
- Filtros, minicart, searchbar, wishlist e zoom são islands (`islands/Header/`, `islands/Searchbar.tsx`, `islands/WishlistButton.tsx`, `islands/ZoomableImage.tsx`).
- Sourei (Miess) e `ThirdPartyScripts` (Phytoterapica, delay 5s) competem com hidratação. O delay reduz disputa com LCP; não tira o JS da main thread quando dispara.

## 3. Não cotar como código de tema

- Compressão e escolha de candidato do CDN Deco (`srcset` do `Image`). Ajustar `width`/`height` muda o tamanho pedido; não desliga o otimizador.
- SSR Fresh / Deno Deploy (TTFB, cold start). Não é prop de section.
- Hidratação parcial é o modelo da plataforma. "Remover todas as islands" quebra compra, CEP, popup e slider. Cotar só adiar ou reduzir ilhas que não são a ação do bloco.
- Blocos salvos no admin. Nova prop (`preload`, `poster`, dimensão) não aparece na loja até o lojista salvar o bloco de novo.
- Scripts cujo `url` aponta para GTM/pixels entram por `ThirdPartyScripts` ou Sourei. Desligar no código apaga a tag da loja; a limpeza de tags dentro do container é do lojista.

## 4. Handoff

| Alvo | Arquivo | O que editar |
|---|---|---|
| Hero Miess | `components/ui/BannerCarousel.tsx` | Manter `lcp={index === 0}`. Ajustar `width`/`height` dos `Source`/`Image` para a arte real (hoje 768×500 e 1920×450 × 0.75). Não remover `Picture preload`. Aspect da classe tem que bater com esses números. |
| Hero Phytoterapica | `components/ui/BannerCarousel.tsx` | Prop `preload` do schema. Garantir o bloco da home com `preload: true` no CMS. `width`/`height` atuais: mobile 430×412, desktop 1920×540. Countdown continua island; não transformar o banner inteiro em island. |
| Card | `components/product/ProductCard.tsx` | Miess: a shelf precisa passar `preload` no primeiro card e o `Image` precisa de `fetchPriority`. Phytoterapica: no ramo 346×346, trocar o `lazy`/`low` fixos para respeitar `preload` (eager/high só no primeiro card acima da dobra). Hover permanece `lazy`. Não remover a island de add-to-cart. |
| PDP | `ImageSlider.tsx` (Miess) e `ProductImageGallery.tsx` (Phytoterapica) | Primeiro índice `eager` + `fetchPriority="high"` + `preload`. Demais e thumbs `lazy` / `low`. `width`/`height` (Phyto 712) alinhados ao `aspect-square`. |
| Modais | `islands/NewsletterPopup.tsx`, `islands/ButtonCookies.tsx`, `islands/popup.tsx`, `islands/ShippingSimulation.tsx` | Reservar espaço no fallback SSR do island (altura mínima do slot), sem mudar o layout aprovado. Popup `fixed` não empurra o documento. |
| Scripts | Miess: `SoureiCookieShield.tsx` e `GlobalTags.tsx`. Phytoterapica: `.deco/blocks/site.json` (`dangerouslyRunOnMainThread` no Analytics) e `components/ThirdPartyScripts.tsx` | Não criar um segundo GTM. Na Phytoterapica o container `GTM-MGK7C49` já roda na main thread pelo bloco global; o `delay` do `ThirdPartyScripts` não adia esse GTM. Tirar `dangerouslyRunOnMainThread` é decisão de tagueamento, fora da hora de tema se o lojista não autorizar. |

Schema novo (`poster`, dimensão extra) exige recadastro do bloco no admin Deco. IDs de coleção e loader de produto não se perdem se o campo for opcional.
