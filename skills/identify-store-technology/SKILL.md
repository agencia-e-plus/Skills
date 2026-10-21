---
name: identify-store-technology
description: >-
  Identifica a tecnologia da frente de loja VTEX de um cliente: CMS (Portal
  legado), IO (Store Framework), Deco ou FastStore, ou devolve
  "nao_identificada". Lê os cabeçalhos HTTP e o HTML da loja no ar e confirma
  pelos repositórios. Use quando o usuário perguntar qual a tecnologia, stack
  ou plataforma de uma loja, ou quando a skill request-pre-analysis
  precisar saber onde a loja é montada. Não analisa chamado e não altera nada.
---

# Identificar tecnologia da loja

Devolve a tecnologia da frente de loja (a parte que o cliente vê): CMS, IO,
Deco, FastStore ou `nao_identificada`. Não analisa chamado, não estima hora e
não altera loja, repositório, admin nem cadastro.

O checkout das quatro tecnologias é o da VTEX. Por isso a classificação vale
para a vitrine (home, categoria, produto, institucional), não para
`/checkout`.

## Entrada

URL da loja. Repositórios são opcionais e servem para confirmar. Se a pessoa
der só o nome da loja, pegue a URL e os repositórios no retorno da skill
`find-store-repository`.

## 1. Cabeçalhos HTTP da loja no ar (sinal principal)

Faça uma requisição GET somente leitura na home, seguindo redirecionamentos, e
leia os cabeçalhos da resposta final:

```bash
curl -sSL -A 'Mozilla/5.0 Chrome/120' -D - -o /dev/null "URL_DA_LOJA"
```

Se o `curl` falhar (bloqueio, WAF, desafio de bot), abra a URL pelo servidor
MCP `playwright` e leia os cabeçalhos do documento na lista de requisições de
rede. Se o Playwright não estiver pronto, rode a `setup-playwright` com a
URL da loja. Se ela devolver `aguardando_instalacao`, a resposta é só esse
retorno. Se devolver `falhou`, siga sem cabeçalhos e sem HTML: com os
repositórios apenas, a tecnologia fica `nao_identificada` (passo 3), com o
papel de cada repositório no retorno.

| Tecnologia | Cabeçalho decisivo | Cabeçalhos de apoio |
|---|---|---|
| Deco | `x-powered-by: deco@<versão>` | `x-deco-platform`, `server: cloudflare` |
| FastStore | `x-vtex-janus-router-backend-app: faststore-…` | `x-powered-by: Next.js`, `x-nextjs-cache` |
| IO | `x-vtex-janus-router-backend-app: io-…` | `x-vtex-renderer: render@…`, `x-vtex-io-cluster-id`, `x-vtex-router-version`, `x-vtex-product: store`, `x-router-cache` |
| CMS | `x-vtex-janus-router-backend-app: portal-…` | `x-powered-by-vtex-cache`, `x-vtex-processed-at`, `x-vtex-processado-em` |

Um cabeçalho decisivo basta para classificar, desde que o HTML não aponte
outra tecnologia.

## 2. HTML da home (confirmação)

Busque estas marcas no HTML da mesma resposta:

| Tecnologia | Marcas no HTML |
|---|---|
| Deco | `/_frsh/` (Fresh), muitas ocorrências de `fresh`, `deco.cx` |
| FastStore | `__NEXT_DATA__`, `_next/static`, `faststore` |
| IO | `__RUNTIME__`, `vtex.render-runtime`, `vtex-render`, `render-server`, classes `vtex-*-0-x-*` |
| CMS | `<vtex:` (controles do Portal), `vtex.js`/`vtexjs`, imagens em `vteximg.com.br/arquivos/ids/…`, nenhuma marca das outras três |

Não servem para separar: `/arquivos/` e `vtexassets.com`, que aparecem nas
quatro.

## 3. Repositórios (confirmação, nunca sozinhos)

Leia a raiz e os arquivos de configuração com `gh api --method GET` (Uso do
gh, na `find-store-repository`). Um mesmo cliente pode ter repositórios
de tecnologias diferentes: lojas Deco e FastStore costumam ter também um
repositório IO para checkout e apps. Por isso, classifique cada repositório
pelo papel dele e deixe a decisão da loja para os passos 1 e 2.

| Tecnologia | Sinais no repositório |
|---|---|
| Deco | `deno.json` importando `deco-cx/deco` e `$fresh/`, `fresh.config.ts`, `manifest.gen.ts`, pastas `sections/`, `islands/`, `loaders/`, `.deco/`. Costuma estar na organização `deco-sites` (ex.: `siteultrafeu`). |
| FastStore | `package.json` com `@faststore/core` e/ou `@faststore/cli` (há lojas só com `@faststore/cli` 4.x, como a Lojas Torra) (scripts `faststore build/start/cms-sync`), `discovery.config.js`, pasta `cms/`, `next-env.d.ts`. |
| IO | `manifest.json` com `vendor`, `name` e `builders` (`store`, `react`, `styles`, `checkout-ui-custom`…), pasta `store/` com `blocks` em `.jsonc`, `eplus.config.js` com `@pluslab/io-builder`. |
| CMS | Templates, subtemplates e prateleiras em `.html` do Portal (o nome e o lugar das pastas mudam de projeto para projeto), `webpack.config.js`, sem `manifest.json` com builder `store`. |

Repositório com só `frontend/` e `backend/` (como `ultrafeu-master`) é um
conjunto de apps auxiliares: leia dentro das pastas antes de classificar.

## 4. Admin VTEX (só quando 1 e 2 não fecharem)

O admin não é necessário quando os cabeçalhos e o HTML concordam. Se não
concordarem, ou a loja não responder, leia o admin pela skill
`vtex-admin-login`, sem alterar nada. Se ela devolver situação diferente de
`pronto`, a resposta é só esse retorno. Não abra o admin aqui quando esta
skill for chamada pela `request-pre-analysis` (ela abre o admin no passo
dela, se precisar) ou pela `identify-store-vendor`: devolva o que os outros
sinais mostraram. Sinais esperados (ainda não conferidos nas lojas-modelo;
registre o que encontrar):

- CMS: Loja virtual > Layout (CMS) com templates e subtemplates em uso.
- IO: Loja virtual > Site Editor com as páginas da loja, e o tema
  (`vendor.nome`) instalado em Apps.
- FastStore: área de Headless CMS / FastStore no menu da loja virtual.
- Deco: a vitrine não é editada no admin VTEX; o conteúdo fica no admin da
  Deco (`deco.cx`). O admin VTEX cuida de catálogo, preço e checkout.

## Lojas-modelo (conferidas em 19/10/2026)

| Loja | Tecnologia | Cabeçalho decisivo | HTML | Repositórios |
|---|---|---|---|---|
| Vila Romana (`shopvilaromana.com.br`) | CMS | `janus-router-backend-app: portal-v1.8.5-k8s` | `<vtex:`, `vtex.js`, `vteximg.com.br` | `vilaromana`: templates `.html` e webpack |
| Kolplast (`loja.kolplast.com.br`) | IO | `janus-router-backend-app: io-production-vstore…`, `x-vtex-renderer: render@8` | `__RUNTIME__`, `vtex.render-runtime` | `kolplast-io`: `manifest.json` com builder `store` |
| Ultrafeu (`ultrafeu.com.br`) | Deco | `x-powered-by: deco@1.199.0`, `x-deco-platform` | `/_frsh/`, `deco.cx` | `deco-sites/siteultrafeu`: `deno.json` e Fresh. `ultrafeu-master`: apps e checkout |
| Banana Brasil B2C (`bananabrasil.com.br`) | FastStore | `janus-router-backend-app: faststore-prod…`, `x-powered-by: Next.js` | `__NEXT_DATA__`, `_next/static` | `bananabrasilb2c`: `@faststore/core`. `bananabrasilb2c-checkout`: IO de checkout |

## Confiança

- **Alta:** cabeçalho decisivo e HTML apontam a mesma tecnologia.
- **Média:** só um dos dois respondeu, ou o repositório confirma o que só o
  HTML mostrou.
- **Baixa:** sinais em conflito (por exemplo, loja em migração, com parte das
  páginas em CMS e parte em IO). Nesse caso, teste também uma página de
  produto e uma de categoria, e diga qual tecnologia atende cada uma.

**`nao_identificada`:** nenhum cabeçalho decisivo nem marca de HTML das quatro
tecnologias, e o admin não fechou ou não pôde ser aberto aqui. Não force uma
das quatro: diga o que os sinais mostraram.

## Retorno

```markdown
## Tecnologia
[CMS, IO, Deco, FastStore ou nao_identificada. Confiança: alta, média ou baixa (não se aplica a nao_identificada).]

## Evidências
- Cabeçalhos: [os decisivos encontrados]
- HTML: [as marcas encontradas]
- Repositórios: [cada um, com o papel: vitrine, checkout, apps]
- Admin: [o que foi lido, ou "não necessário"]

## Onde se altera a vitrine
[CMS: templates e placeholders no admin (Layout/CMS) e arquivos do repositório.
IO: blocos `.jsonc` do tema e Site Editor.
Deco: sections do repositório Deco e admin da Deco.
FastStore: código do repositório FastStore e Headless CMS.
nao_identificada: não se aplica; diga o que os sinais mostraram.]
```
