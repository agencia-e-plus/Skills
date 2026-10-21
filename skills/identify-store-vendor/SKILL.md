---
name: identify-store-vendor
description: >-
  Descobre o vendor (account name VTEX) de uma loja a partir da URL da loja e
  dos repositórios, para montar https://{vendor}.myvtex.com/admin sem a pessoa
  precisar informar. Funciona para lojas CMS, IO, Deco e FastStore. Use quando
  o usuário perguntar o vendor, account ou admin de uma loja, quando a
  request-pre-analysis conferir a loja ou quando a vtex-admin-login
  precisar do vendor. Só lê; não abre o admin nem altera nada.
---

# Identificar vendor da loja

Devolve o vendor da VTEX (o `account name`, o mesmo de
`https://{vendor}.myvtex.com/admin`) e a situação. Não analisa chamado, não
abre o admin e não altera loja, repositório nem cadastro.

Esta skill não pede o vendor à pessoa: devolve a situação, e quem chamou
decide o que fazer.

## Entrada

URL da loja e, se houver, as URLs dos repositórios. Se vier só o nome da loja,
use o retorno da `find-store-repository`. Use a tecnologia já
identificada nesta conversa pela `identify-store-technology`; se ainda não
houver, rode essa skill antes. Com tecnologia `nao_identificada`, procure
todos os sinais.

Todo candidato precisa ter o formato de vendor do cadastro (seção Cadastro da
`find-store-repository`).

## 1. Repositório: o código decide

O vendor nem sempre é o nome do domínio nem o do repositório, e a loja pode
mostrar outras contas VTEX no site, nas imagens e no catálogo público (veja as
lojas-modelo). Por isso, o arquivo do repositório da vitrine decide:

| Tecnologia | Arquivo que decide | Com o arquivo |
|---|---|---|
| IO | `manifest.json` do tema (`manifest.json` ou `src/manifest.json`): `vendor` | `confirmado` |
| FastStore | `discovery.config.js`: `api.storeId` (em geral `process.env.NEXT_PUBLIC_STORE_ID \|\| "{vendor}"`) | `confirmado` |
| Deco | bloco do app VTEX em `.deco/blocks/` (`deco-vtex.json`, `vtex.json` ou parecido): `account` | `confirmado` |
| CMS | `config/default.json`: `accountName` e `dashboardUrl` (`https://{vendor}.myvtex.com/admin`) | `confirmado` só com mais um sinal no mesmo vendor: HTML (passo 2) ou `manifest.json` do checkout |

Em IO, FastStore e Deco, com o arquivo encontrado, nenhum outro sinal muda o
vendor: contas vistas no HTML, nas imagens ou no catálogo vão para "Candidatos
descartados", sem gerar conflito.

Em CMS, o `config/default.json` pode ter ficado com o valor genérico do
modelo: `"accountName": "store"` e `https://store.myvtex.com/admin`. Trate
como arquivo ausente: o vendor sai do HTML, com situação `provavel`.

Leia os arquivos com `gh api --method GET` (Uso do gh, na
`find-store-repository`), só nos repositórios da loja. Outros
repositórios da loja servem de apoio:

- Repositório IO de checkout: `vendor` do `manifest.json`. Se divergir do
  arquivo da vitrine, vale o da vitrine.
- Monorepo de apps, como `ultrafeu-master`: `vendor` dos `manifest.json` em
  `frontend/apps/*` e as `dependencies` do `.eplusrc.json`.
- `vendor` de app de terceiro ou da agência, em `manifest.json` de apps
  reutilizáveis, não é sinal: vale o do tema da loja ou do checkout.

## 2. HTML da home

Serve para confirmar o CMS, para a loja sem repositório ou sem o arquivo que
decide, e para a `find-store-repository` buscar repositório pelo account.
Faça um GET somente leitura na home, ou leia o documento pelo Playwright.

| Tecnologia | Marca no HTML |
|---|---|
| CMS | `"accountName":"{vendor}"` (dataLayer / `vtex.events`), imagens de produto em `{vendor}.vteximg.com.br/arquivos/ids/` |
| IO | `__RUNTIME__` com `"account":"{vendor}"`, assets em `{vendor}.vtexassets.com` |
| Deco | imagens de produto em `{vendor}.vtexassets.com/arquivos/ids/`, quando a home tiver |
| FastStore | subdomínio mais frequente de `vtexassets.com` / `vteximg.com.br`, só como apoio: imagens de conteúdo podem ser de outra conta |

Conte os subdomínios com, por exemplo,
`grep -oE '[a-z0-9-]+\.(vtexassets\.com|vteximg\.com\.br)' | sort | uniq -c` e
separe os que estão em `/arquivos/ids/` (produto) dos demais. Conta que só
aparece em imagem de conteúdo (banner, menu, ícone, rodapé,
`assets-builder/…theme`) não é sinal de vendor.

## 3. Catálogo público (apoio)

GET somente leitura em
`{URL_DA_LOJA}/api/catalog_system/pub/products/search?_from=0&_to=0`; leia o
subdomínio das imagens (`{conta}.vteximg.com.br`). Vale para CMS, IO e Deco. O
domínio pode responder por outra conta, então o catálogo nunca decide contra o
repositório.

Não use endpoints que criam ou alteram dados (`orderForm`, `sessions` com
POST, carrinho, login).

## 4. A conta existe

GET somente leitura em
`https://{vendor}.vtexcommercestable.com.br/api/catalog_system/pub/category/tree/0`.
`200`: a conta existe. `404`: a conta não existe e o candidato cai. Isso só
confirma a existência, não que a conta é da loja.

## Situação

- **confirmado:** IO, FastStore ou Deco com o arquivo que decide; ou CMS com
  `config/default.json` e mais um sinal no mesmo vendor (HTML ou
  `manifest.json` do checkout). Em todos, a conta existe.
- **provavel:** um sinal só achou o vendor, sem o arquivo que decide, e a
  conta existe. Por exemplo: CMS com `config/default.json` e sem marca no
  HTML; só o `manifest.json` do checkout, sem o repositório da vitrine; ou só
  os sinais do site (sem repositório, arquivo ausente ou `store` genérico).
- **conflito:** sinais fortes apontam vendors diferentes e nenhum arquivo
  decide. Por exemplo, CMS com `config/default.json` e HTML diferentes, ou
  loja sem repositório com HTML e catálogo diferentes. Liste os candidatos com
  a origem de cada um.
- **nao_encontrado:** nenhum sinal.

A prova final é o login: a `vtex-admin-login` confere se a conta aberta é a
da loja.

## Lojas-modelo (conferidas em 19/10/2026)

| Loja | Tecnologia | Vendor | O que decide | O que confunde |
|---|---|---|---|---|
| Vila Romana | CMS | `vilaromana` | `config/default.json` e HTML `"accountName":"vilaromana"` | nada |
| Reconflex | CMS | `reconflex` (provavel) | HTML `"accountName":"reconflex"` | `config/default.json` com o `store` genérico |
| Kolplast | IO | `kolplast` | `src/manifest.json` | nada |
| Soares Atacado | IO | `b2bgruposoares` | `manifest.json` | catálogo público responde `gruposoares`; vendor diferente do domínio |
| Ultrafeu | Deco | `ultrafeu` | `deco-sites/siteultrafeu`: `.deco/blocks/deco-vtex.json` | nada |
| Sex Shop Atacadão | Deco | `atacadaosexyshop` | bloco VTEX em `.deco/blocks/` | vendor diferente do domínio e do repositório |
| Banana Brasil B2C | FastStore | `bananabrasilb2c` | `discovery.config.js` (checkout `src/manifest.json` igual) | imagens de conteúdo e catálogo público em `bananabrasil`, a conta da B2B |
| Lojas Torra | FastStore | `torratorra` | `discovery.config.js` | todos os assets do site vêm de `torrafaststore` |

## Retorno

```markdown
## Vendor
[vendor, ou "não encontrado". Situação: confirmado, provavel, conflito ou nao_encontrado.]

## Admin
[https://{vendor}.myvtex.com/admin, ou "sem vendor".]

## Evidências
- Repositórios: [arquivo e valor de cada um]
- HTML: [marcas encontradas, ou "não usado"]
- Catálogo público: [conta, ou "não usado"]
- Conta existe: [200 ou 404]

## Candidatos descartados
[Outras contas vistas e por que caíram, ou "nenhum".]
```
