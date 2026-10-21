---
name: vtex-admin-login
description: >-
  Abre o admin VTEX da loja (https://{vendor}.myvtex.com/admin) numa janela
  visível do Chromium, espera a pessoa entrar e confere se a conta é a da
  loja. Só leitura: nada no admin pode ser editado, incluído, excluído ou
  alterado. Use quando o usuário pedir para entrar no admin, no myvtex ou na
  conta de uma loja, ou quando a request-pre-analysis precisar ler o
  cadastro. Resolve o vendor pela mensagem, pelo cadastro ou pela skill
  identify-store-vendor e grava no lojas.json o vendor conferido. Não
  analisa chamado.
---

# Entrar no admin VTEX

Abre o admin da loja e deixa a sessão pronta para leitura. Não analisa
chamado, não estima hora e não altera repositório da loja.

`${CLAUDE_SKILL_DIR}` é a pasta deste `SKILL.md`, e as outras skills ficam ao
lado dela, em `${CLAUDE_SKILL_DIR}/../NOME/`. Nos comandos, use o caminho
absoluto.

## Só leitura

Esta é a regra do admin para todas as skills. No admin, só leia: abra menu,
tela, busca, filtro, paginação e registro para ver a informação. Preencher e
enviar uma busca ou um filtro read-only é permitido, e abrir na janela logada
um endereço de leitura (GET) também. Nada no admin pode ser editado, incluído,
excluído, duplicado, ativado, desativado, salvo ou publicado. Isso vale para
cadastro, pedido, preço, promoção, conteúdo, e-mail, app, configuração e
qualquer outro dado da conta. Não preencha campos de edição, não confirme
modal e não acione ação que altere a loja. A única ação fora da leitura é o
login da pessoa na janela do Chromium.

Não use chave de API. Não peça senha, código nem token no chat.

## Vendor

Entrada: nome e URL da loja (do cadastro ou da conversa) e, se houver, o
vendor informado pela pessoa e o retorno da `identify-store-vendor` trazido
por quem chamou. Procure a loja no cadastro conforme a seção Cadastro da
`find-store-repository`, que define o caminho do `lojas.json`, o slug, o
formato do vendor e a forma de gravar.

Use o primeiro que houver:

1. Vendor informado explicitamente pela pessoa na mensagem atual.
2. `vendor` do cadastro.
3. Retorno da `identify-store-vendor`: o que quem chamou trouxe para a mesma
   loja ou, se não houver, rode a skill agora com a URL e os repositórios do
   cadastro ou da conversa. `confirmado` ou `provavel`: use esse vendor.
   `conflito` ou `nao_encontrado`: a situação é `vendor_ausente`; devolva os
   candidatos e peça o vendor à pessoa.

Vendor fora do formato do cadastro: `entrada_invalida`, dizendo o que está
errado. Sem vendor depois disso: `vendor_ausente`, dizendo exatamente o que
falta.

Gravação no cadastro, sempre só do campo `vendor`, depois do passo 6:

- Conta conferida (domínio da loja encontrado): grave o vendor usado, se a
  loja não tiver vendor no cadastro ou tiver outro.
- Conta não conferida: grave só o vendor informado pela pessoa ou `confirmado`
  pela identificação, e só se a loja não tiver vendor no cadastro. Vendor
  `provavel` não é gravado.
- Conta incorreta: não grave.

## Navegador

O admin usa o servidor MCP `playwright-admin` (janela visível, perfil salvo),
configurado pela `setup-playwright`. Não use o servidor `playwright`, que
é o da loja no ar. Se o namespace `playwright-admin` não existir ou o
navegador não abrir, rode a `setup-playwright` com o servidor
`playwright-admin` e a URL do admin. Se ela devolver `aguardando_instalacao`
ou `falhou`, a resposta é só esse retorno.

Login com Google nesse Chromium costuma ser recusado. A pessoa entra com
e-mail e senha da VTEX.

**Limpeza semanal.** O perfil guarda as sessões de login de todas as contas e
é apagado quando completa 7 dias. O mesmo script apaga os prints com mais de 7
dias, porque prints do admin podem ter dados de clientes e pedidos. Antes de
abrir o admin, rode:

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/limpar-perfil-admin.sh"
```

Saída `0`: siga. Saída `2`: o perfil venceu, mas o navegador do admin está
aberto. Feche-o com `browser_close` do servidor `playwright-admin` e rode o
script de novo. Se der `2` outra vez, o navegador está aberto em outra
conversa: a situação é `falhou`, e a pessoa precisa fechar aquela janela do
Chromium. Qualquer outra saída: `falhou`, com a mensagem do script. Depois de
uma limpeza, a pessoa precisa entrar de novo.

## Estados

- `pronto`: o admin abriu, a conta foi conferida (ou ficou registrada como não
  conferida) e a sessão pode ser lida.
- `aguardando_login`: a janela está aberta na tela de login e a pessoa precisa
  entrar manualmente.
- `aguardando_instalacao`: falta preparar ou reconectar o Playwright; não há
  janela pronta para login.
- `vendor_ausente`: não há vendor utilizável: nem informado, nem no cadastro,
  e a identificação deu `conflito` ou `nao_encontrado`.
- `vendor_incorreto`: o login abriu uma conta que não é a da loja.
- `entrada_invalida`: o nome ou o vendor não passou na validação.
- `falhou`: o navegador não abriu, a navegação falhou ou a leitura não pôde
  começar.

## Passos

1. Resolva o vendor (seção Vendor).
2. Rode a limpeza semanal.
3. Abra `https://{vendor}.myvtex.com/admin` com `browser_navigate` do servidor
   `playwright-admin`. Descubra as ferramentas do namespace antes de chamar.
4. Se a página for login, SSO ou código, a situação é `aguardando_login`. A
   resposta é só o retorno. Diga para a pessoa entrar na janela do Chromium,
   com e-mail e senha da VTEX, inclusive o código de verificação se aparecer.
   Não digite a senha, não clique em entrar e não peça credenciais no chat.
5. Quando a pessoa disser que entrou, abra a URL de novo. Ainda no login:
   `aguardando_login`.
6. Com o admin aberto, confira se a conta é a da loja, uma vez por vendor
   nesta conversa. Na mesma janela, abra
   `https://{vendor}.myvtex.com/api/vlm/account/stores` (leitura) e procure o
   domínio da URL da loja, com ou sem `www`, entre os hosts. Se a resposta não
   trouxer hosts, procure o domínio nas configurações da conta, na tela que
   lista as lojas e os hosts. Nem esse endereço nem essa tela foram conferidos
   ainda: registre o que encontrou.
   - Domínio encontrado: `pronto`. Grave conforme a seção Vendor.
   - Domínio ausente: `vendor_incorreto`. Não grave. Peça para a pessoa
     informar o vendor correto e, se a identificação trouxe outro vendor,
     sugira-o. Se o vendor errado veio do cadastro, diga isso. Com o vendor
     novo, volte ao passo 1.
   - Sem URL da loja, ou sem acesso a essa informação: `pronto`, com "conta
     não conferida" no retorno. Grave conforme a seção Vendor.
7. Desafio que não puder ser resolvido manualmente, timeout ou erro de
   navegação: `falhou`. Não use apenas o título como critério.

## Retorno

Situação diferente de `pronto`: a resposta é só este retorno. `pronto` devolve
a sessão para quem chamou.

```markdown
## Admin VTEX
[pronto, aguardando_login, aguardando_instalacao, vendor_ausente, vendor_incorreto, entrada_invalida ou falhou.]

## Loja
[Nome informado e chave do cadastro, ou "sem chave".]

## Vendor
[Vendor usado e a origem: mensagem, cadastro ou identificação automática (com a situação). Em vendor_ausente, os candidatos. Ou "não informado".]

## Conta
[Conferida (domínio encontrado), não conferida (motivo) ou incorreta (o que apareceu).]

## Cadastro
["Não alterei o lojas.json", ou o vendor gravado ou substituído, com o valor anterior.]

## URL
[URL do admin aberta, ou a URL que não abriu.]

## Evidência
[Título da página, o que a pessoa precisa fazer na janela, ou o erro.]
```
