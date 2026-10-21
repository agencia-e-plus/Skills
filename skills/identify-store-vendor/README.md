# identify-store-vendor

Descobre o vendor (account name VTEX) de uma loja a partir da URL e dos
repositórios, para montar `https://{vendor}.myvtex.com/admin` sem ninguém
precisar informar. Funciona com lojas CMS, IO, Deco e FastStore.

## Quando usar

- Você pergunta o vendor, o account ou o admin de uma loja.
- A `request-pre-analysis` confere a loja.
- A `vtex-admin-login` precisa do vendor.

Só lê: não abre o admin, não altera nada e não pede o vendor a ninguém. Ela
devolve a situação e quem chamou decide o que fazer.

## Exemplos

```text
/identify-store-vendor Lojas Torra
Qual o vendor da Soares Atacado?
Qual o admin da https://www.ultrafeu.com.br/?
```

## Entrada

URL da loja e, se houver, os repositórios. Com só o nome, usa a
`find-store-repository`. Usa a tecnologia da
`identify-store-technology` (roda antes, se ainda não rodou).

## Como decide

O vendor nem sempre é o nome do domínio nem o do repositório, e a loja pode
mostrar outras contas VTEX nas imagens. Por isso, **o arquivo do repositório
decide**:

| Tecnologia | Arquivo que decide |
|---|---|
| IO | `manifest.json` do tema: `vendor` |
| FastStore | `discovery.config.js`: `api.storeId` |
| Deco | bloco VTEX em `.deco/blocks/`: `account` |
| CMS | `config/default.json`: `accountName` (precisa de mais um sinal) |

Depois vêm os sinais de apoio:

1. **HTML da home**: `"accountName"`, `__RUNTIME__` com `"account"`, e
   subdomínios de `vtexassets.com`/`vteximg.com.br` em imagens de produto.
2. **Catálogo público**: subdomínio das imagens em
   `/api/catalog_system/pub/products/search`. Nunca decide contra o
   repositório.
3. **A conta existe**: GET em
   `https://{vendor}.vtexcommercestable.com.br/api/catalog_system/pub/category/tree/0`
   (`200` existe, `404` não existe).

## Situações

| Situação | Quando |
|---|---|
| `confirmado` | Arquivo que decide encontrado (CMS: mais um sinal igual) e a conta existe |
| `provavel` | Um sinal só, sem o arquivo que decide, e a conta existe |
| `conflito` | Sinais fortes com vendors diferentes e nenhum arquivo decide |
| `nao_encontrado` | Nenhum sinal |

A prova final é o login, na `vtex-admin-login`.

## Retorno

```markdown
## Vendor
## Admin
## Evidências
## Candidatos descartados
```

## Lojas-modelo

Vila Romana, Reconflex, Kolplast, Soares Atacado, Ultrafeu, Sex Shop
Atacadão, Banana Brasil B2C e Lojas Torra, conferidas em 19/10/2026. O
`SKILL.md` mostra o que decidiu e o que confundiu em cada uma.

## Depende de

- `find-store-repository` (URL, repositórios, formato do vendor, regras
  do `gh`)
- `identify-store-technology`

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Sinais, situações, lojas-modelo e retorno |
