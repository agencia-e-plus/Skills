---
name: find-store-repository
description: >-
  Localiza a URL e os repositórios GitHub de uma loja de e-commerce e devolve
  o que encontrou, sem analisar o chamado. Também guarda as regras do cadastro
  de lojas (lojas.json) e do uso do gh, que as outras skills seguem. Use
  quando o usuário pedir para achar, buscar ou confirmar o repositório de uma
  loja, incluir ou atualizar uma loja no cadastro, ou quando a pré-análise
  precisar da identidade da loja.
---

# Localizar repositório da loja

Devolve a URL da loja e as URLs dos repositórios. Não analisa chamado, não
estima hora e não altera repositório.

## Cadastro (lojas.json)

O cadastro de lojas é `${CLAUDE_SKILL_DIR}/lojas.json`, na pasta deste
`SKILL.md`. As outras skills chegam a ele por
`../find-store-repository/lojas.json`, a partir da pasta delas. É o único
`lojas.json` que as skills leem e gravam.

Cada loja tem `nome` e pode ter `url`, `repositorios`, `vendor` e
`semRepositorio`. `"semRepositorio": true` marca uma conta que não tem
repositório de loja (como a da própria Agência e-Plus) e só é gravado quando o
usuário pedir. A chave de uma loja nova é o nome em minúsculas, com os espaços
e acentos do nome.

**Slug.** Para comparar um nome com as chaves, normalize os dois do mesmo
jeito: minúsculas, sem acento, sem espaço e sem hífen. O nome inteiro precisa
coincidir: `Miess`, `miess` e `MIESS` acham `miess`. `Phytoterapica` acha
`phytoterápica`. `Agencia e-Plus` acha `agência e-plus`. `Miess Shop` não acha
`miess`. `Banana Brasil` não acha `banana brasil b2c`.

**Vendor.** Depois de convertido para minúsculas, o vendor só pode ter letras,
números e hífens internos: `^[a-z0-9]+(?:-[a-z0-9]+)*$`. Não remova
separadores nem aceite `/`, `..`, aspas ou outros caracteres especiais: essa
validação protege a URL do admin. Nunca invente vendor.

**Quem grava.**
- Esta skill, só quando o usuário pedir para incluir ou atualizar uma loja.
  Preserve o `vendor` e o `semRepositorio` ao incluir ou atualizar.
- `vtex-admin-login`, só o campo `vendor`, nos casos descritos lá. Ela
  preserva os demais campos. Chave nova recebe só `nome` e `vendor`, sem
  inventar URL ou repositório.

Toda gravação é feita num arquivo temporário na mesma pasta, renomeado de
forma atômica por cima do `lojas.json`. O retorno registra o que mudou.

## Uso do gh

Vale para esta skill e para as que a citam.

- Só leitura: `gh auth status`, `gh api --method GET`, `gh search code`,
  `gh pr view` e `gh pr list`. `gh search repos` só roda nesta skill.
- `api`, `search code`, `pr view` e `pr list` só nos repositórios da loja já
  identificados. Nesta skill, `api` também valida um repositório candidato.
- Proibido: `gh api` sem `--method GET`, ou com `--input`, `-f`, `-F`, `POST`,
  `PATCH`, `PUT` ou `DELETE`, e qualquer comando que crie, altere ou apague
  algo.
- Se `gh auth status` disser que o token é inválido, rode de novo fora do
  sandbox antes de pedir novo login. Se continuar inválido, peça
  `gh auth login -h github.com` ou `gh auth refresh -h github.com -s repo`.
  Não peça token colado no chat.

## Entrada

Nome da loja. URL da loja e URLs de repositório são opcionais: se já vieram na
mensagem, use-as e não peça de novo.

## Ordem

1. Se a mensagem já trouxe uma ou mais URLs de repositório, valide cada uma
   antes de usá-la e não busque outras no GitHub. A URL precisa ser HTTPS,
   apontar para `github.com/agencia-e-plus/` ou `github.com/deco-sites/` e
   identificar um repositório existente. URL inválida, inacessível ou de outra
   organização não fecha a identidade: a situação é `incompleto` e o retorno
   pede um link válido.
2. Procure a loja no cadastro, pelo slug.
3. Se a chave existir e tiver URL e pelo menos um repositório, valide os
   repositórios. Se a URL da loja e ao menos um repositório forem válidos, o
   retorno fecha com origem `cadastro`. Não procure repositórios adicionais.
4. Se a chave tiver `"semRepositorio": true`, não busque no GitHub. A situação
   é `incompleto`. O `vendor` continua no cadastro para o admin.
5. Se a chave não existir, ou se faltar repositório no cadastro (inclusive
   chave só com `nome` e `vendor`, gravada pela `vtex-admin-login`) e a
   mensagem não trouxe URL de repositório, busque no GitHub. A URL que já veio
   na mensagem continua valendo. Não busque se o repositório já está no
   cadastro, se veio na solicitação ou no caso do passo 4.
6. Se faltar a URL da loja e houver repositório identificado (mensagem,
   cadastro, correspondência forte ou a única fraca), leia o README desses
   repositórios e use a URL só se estiver escrita lá. Não invente URL a partir
   do nome. Em `ambiguo`, não escolha um README.

## Busca no GitHub

Consulta somente leitura, nas organizações `agencia-e-plus` e `deco-sites`.
Não use busca na web, não clone e não faça checkout. O GET somente leitura na
home da loja, descrito abaixo, é permitido.

Busque pelo slug do nome da loja:

```bash
gh search repos --owner agencia-e-plus "SLUG" --limit 20
gh search repos --owner deco-sites "SLUG" --limit 20
```

Se a busca pelo slug não achar correspondência forte e a URL da loja for
conhecida (mensagem ou cadastro), leia o account no HTML da home, como no
passo "HTML da home" da `identify-store-vendor`, e repita a busca com ele. O
nome do repositório costuma conter o vendor mesmo quando não contém o nome da
loja: `b2bgruposoares` (Soares Atacado), `lojasupersaudavel` (Super Saudável
Shopping), `faststore-b2cthamaracapelao` (Thamara Capelão). Nessa busca, o
account faz o papel do slug nas regras de correspondência abaixo.

Valide cada repositório com
`gh api --method GET repos/ORGANIZACAO/REPOSITORIO`. Se a resposta for 404, o
acesso for negado ou o caminho não for de uma organização permitida, o
repositório é inválido e não fecha a identidade.

Um repositório é correspondência forte quando o nome, sem hífen e em
minúsculas:

- é igual ao slug
- é o slug seguido só de dígitos, como `miess01` (`miess-01`)
- é o slug seguido de `b2c`, `b2b`, `checkout`, `io` ou `master`
- é o slug seguido de `b2ccheckout` ou `b2bcheckout`, como
  `bananabrasilb2c-checkout`
- é `site` ou `faststore` seguido do slug, como `siteultrafeu` e
  `faststoretorra`

Várias correspondências fortes da mesma loja entram juntas.
`deco-sites/miess-01` e `agencia-e-plus/miess` são as fortes da Miess.
Repositório de checkout entra junto com o da loja.

Correspondência fraca é nome que contém o slug e não segue a regra acima. Se
houver correspondência forte, liste as fortes e mencione as fracas à parte. Se
não houver forte e houver exatamente uma fraca válida, a situação é
`confirmacao`, com esse repositório. Se houver várias fracas e nenhuma forte,
a situação é `ambiguo`. Se não houver nenhuma, é `incompleto`. Correspondência
forte, ou a única fraca, não fecha ainda: a situação fica `confirmacao`, até o
usuário responder.

## Confirmação antes de seguir

A busca no GitHub pode achar o repositório. Antes de seguir adiante, pergunte
ao usuário se deve seguir com o repositório ou os repositórios encontrados, ou
se ele deseja usar outro link de repositório.

Essa pausa vale quando a busca aconteceu: o link não estava no cadastro e não
veio na solicitação inicial. Repositório que já estava no cadastro, ou que o
usuário enviou na solicitação, segue sem essa pergunta.

Quando a busca achar correspondência forte, ou exatamente uma fraca válida, a
situação fica `confirmacao`. A resposta lista o que foi encontrado e pergunta
se deve seguir com ele ou se a pessoa deseja enviar outro link. Não analise o
chamado, não leia código da loja e não trate como `fechado`.

`ambiguo` lista os candidatos e pede que a pessoa escolha um repositório. A
resposta também pede a URL da loja se ela ainda não estiver disponível.
`incompleto` informa o que faltou e pede a URL da loja ou um repositório
válido, conforme o caso.

Se o usuário confirmar os encontrados, valide-os novamente e só passe a
`fechado` com origem `GitHub` se houver URL da loja e pelo menos um
repositório válido. Se faltar a URL, continue em `incompleto`. Se ele enviar
outro link, valide-o; não busque de novo e não feche sem os dois requisitos.

## Retorno

Situação `fechado` exige URL HTTPS da loja e pelo menos um repositório
validado de correspondência forte, a única fraca confirmada pelo usuário, ou
um repositório informado pelo usuário. `confirmacao`, `ambiguo` e `incompleto`
não seguem para a pré-análise.

```markdown
## Loja
[Nome informado e chave do cadastro, ou "sem chave".]

## URL da loja
[URL e origem: mensagem, cadastro ou README. Se faltar: "não encontrada".]

## Repositórios
- [URL — origem: mensagem, cadastro ou GitHub. Diga por que o nome entrou (slug ou account).]

## Situação
[fechado, confirmacao, ambiguo ou incompleto.]

## Fora da lista
[Correspondências fracas, ou "nenhuma".]

## Cadastro
["Não alterei o lojas.json", ou exatamente o que foi incluído ou atualizado.]
```
