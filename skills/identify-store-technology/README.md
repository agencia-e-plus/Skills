# identify-store-technology

Descobre em qual tecnologia a frente de uma loja VTEX é montada:

| Tecnologia | O que é |
|---|---|
| CMS | Portal legado da VTEX |
| IO | Store Framework (VTEX IO) |
| Deco | Deco.cx (Fresh/Deno) |
| FastStore | FastStore (Next.js) |
| `nao_identificada` | Nenhum sinal claro das quatro |

A classificação vale para a vitrine (home, categoria, produto,
institucional). O checkout das quatro é o da VTEX.

## Quando usar

- Você pergunta qual a tecnologia, stack ou plataforma de uma loja.
- A `request-pre-analysis` precisa saber onde a loja é montada.

Não analisa chamado e não altera nada.

## Exemplos

```text
/identify-store-technology https://loja.kolplast.com.br/
Qual a tecnologia da Ultrafeu?
A Banana Brasil é IO ou FastStore?
```

## Entrada

URL da loja. Repositórios são opcionais (só confirmam). Com só o nome da loja,
a skill usa a `find-store-repository`.

## Como decide

1. **Cabeçalhos HTTP** da home (sinal principal), por `curl` ou, se bloqueado,
   pelo Playwright:

   | Tecnologia | Cabeçalho decisivo |
   |---|---|
   | Deco | `x-powered-by: deco@…` |
   | FastStore | `x-vtex-janus-router-backend-app: faststore-…` |
   | IO | `x-vtex-janus-router-backend-app: io-…` |
   | CMS | `x-vtex-janus-router-backend-app: portal-…` |

2. **HTML da home** (confirmação): `/_frsh/` (Deco), `__NEXT_DATA__`
   (FastStore), `__RUNTIME__` (IO), `<vtex:` e `vtex.js` (CMS).
3. **Repositórios** (só confirmam): `deno.json` com Fresh, `@faststore/core`,
   `manifest.json` com builder `store`, templates `.html` do Portal. Cada
   repositório recebe um papel (vitrine, checkout, apps).
4. **Admin VTEX**, só quando os passos 1 e 2 não fecham, e nunca quando a
   chamada vem da `request-pre-analysis` ou da `identify-store-vendor`.

## Confiança

| Nível | Quando |
|---|---|
| Alta | Cabeçalho e HTML apontam a mesma tecnologia |
| Média | Só um dos dois respondeu, ou o repositório confirma o HTML |
| Baixa | Sinais em conflito (por exemplo, loja em migração) |

## Retorno

```markdown
## Tecnologia
## Evidências
## Onde se altera a vitrine
```

"Onde se altera a vitrine" orienta a análise: templates/Layout (CMS), blocos
`.jsonc` e Site Editor (IO), sections e admin da Deco (Deco), código e
Headless CMS (FastStore).

## Lojas-modelo

Vila Romana (CMS), Kolplast (IO), Ultrafeu (Deco) e Banana Brasil B2C
(FastStore), conferidas em 19/10/2026. Os detalhes estão no `SKILL.md`.

## Depende de

- `find-store-repository` (URL, repositórios e regras do `gh`)
- `setup-playwright` (quando o `curl` é bloqueado)
- `vtex-admin-login` (só em último caso)

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Sinais de cada tecnologia, lojas-modelo e retorno |
