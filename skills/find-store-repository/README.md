# find-store-repository

Encontra a URL e os repositórios GitHub de uma loja e devolve o que achou, sem
analisar o chamado. Também é a "dona" de duas regras que as outras skills
seguem:

- o **cadastro de lojas** (`lojas.json`);
- o **uso do `gh`** (só leitura).

## Quando usar

- Você pede para achar, buscar ou confirmar o repositório de uma loja.
- Você pede para incluir ou atualizar uma loja no cadastro.
- A `request-pre-analysis` precisa da identidade da loja.

## Exemplos

```text
/find-store-repository Miess
Qual o repositório da Degusta Casa?
Inclui no cadastro a loja Reconflex com a URL https://...
```

## Entrada

Nome da loja. URL da loja e URLs de repositório são opcionais: se já vierem na
mensagem, não são pedidas de novo.

## Ordem de busca

1. URLs de repositório que vieram na mensagem: valida e usa (precisam ser de
   `github.com/agencia-e-plus/` ou `github.com/deco-sites/`).
2. Cadastro (`lojas.json`), pelo slug do nome.
3. Cadastro com URL e repositório válidos: fecha com origem `cadastro`.
4. Loja com `"semRepositorio": true`: não busca no GitHub.
5. Sem repositório: busca no GitHub (`gh search repos`) nas organizações
   `agencia-e-plus` e `deco-sites`, pelo slug e, se preciso, pelo account do
   HTML da loja.
6. Sem URL da loja: procura no README do repositório encontrado.

Repositório achado pela busca **sempre** pede sua confirmação antes de seguir.

## Correspondência

Forte, quando o nome do repositório (sem hífen, minúsculo):

- é igual ao slug (`miess`);
- é o slug + dígitos (`miess-01`);
- é o slug + `b2c`, `b2b`, `checkout`, `io` ou `master`;
- é o slug + `b2ccheckout`/`b2bcheckout`;
- é `site` ou `faststore` + slug (`siteultrafeu`, `faststoretorra`).

Fraca: o nome contém o slug, mas não segue as regras acima.

## Situações

| Situação | Significado |
|---|---|
| `fechado` | URL da loja e pelo menos um repositório válido |
| `confirmacao` | A busca achou; espera você confirmar |
| `ambiguo` | Várias correspondências fracas; você escolhe |
| `incompleto` | Faltou URL ou repositório válido |

Só `fechado` segue para a pré-análise.

## Cadastro (`lojas.json`)

Único cadastro lido e gravado pelas skills: o `lojas.json` desta pasta. As
outras skills chegam a ele por `../find-store-repository/lojas.json`.

```json
"banana brasil b2c": {
  "nome": "Banana Brasil B2C",
  "url": "https://www.bananabrasil.com.br/",
  "repositorios": ["https://github.com/agencia-e-plus/bananabrasilb2c"],
  "vendor": "bananabrasilb2c"
}
```

- **Chave:** o nome em minúsculas, com espaços e acentos.
- **Slug** (para comparar): minúsculas, sem acento, espaço nem hífen. O nome
  inteiro precisa coincidir (`Miess Shop` não acha `miess`).
- **Vendor:** `^[a-z0-9]+(?:-[a-z0-9]+)*$`. Nunca inventado.
- **Quem grava:** esta skill, só quando você pede; e a `vtex-admin-login`,
  só o campo `vendor`. A gravação é atômica (arquivo temporário + rename).

## Uso do `gh`

- Permitido: `gh auth status`, `gh api --method GET`, `gh search code`,
  `gh pr view`, `gh pr list`. `gh search repos` só nesta skill.
- Proibido: `gh api` sem `--method GET`, com `-f`/`-F`/`--input`, ou
  qualquer `POST`, `PATCH`, `PUT`, `DELETE`.
- Token inválido: pedir `gh auth login -h github.com`. Nunca pedir token no
  chat.

## Retorno

```markdown
## Loja
## URL da loja
## Repositórios
## Situação
## Fora da lista
## Cadastro
```

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Regras de busca, cadastro, `gh` e retorno |
| `lojas.json` | Cadastro de lojas usado por todas as skills |
