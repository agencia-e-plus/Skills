# request-pre-analysis

Faz a pré-análise de um chamado de cliente de loja VTEX (problema, dúvida ou
pedido de mudança). Confere a loja no ar, o código nos repositórios e, quando
precisa, o admin VTEX, **sem alterar nada**. Classifica o chamado como
evolução ou suporte e devolve:

- o **relatório interno** para a Agência e-Plus; e
- o **relatório para o cliente**;

ou, se faltar informação, só as **perguntas** para o cliente.

É a skill principal: ela orquestra todas as outras.

## Quando usar

Você pede uma pré-análise ou análise de chamado, ticket ou solicitação e
informa **a mensagem do cliente** (com anexos, se houver) e **o nome da
loja**. Sem essas duas coisas, a skill pede antes de começar.

Não use só para localizar repositório (para isso, `find-store-repository`).

## Exemplos

```text
/request-pre-analysis
Loja: Kolplast
Mensagem: "O carrossel da home parou de passar no celular."
```

```text
Faz a pré-análise desse chamado da Degusta Casa: [mensagem do cliente + prints]
```

## Fluxo

| Passo | O que acontece | Skill usada |
|---|---|---|
| 1 | Identidade da loja (URL e repositórios) | `find-store-repository` |
| 2 | Tecnologia (e vendor, se não estiver no cadastro) | `identify-store-technology`, `identify-store-vendor` |
| 3 | Leitura da mensagem e dos anexos | — |
| 4 | Conferência da loja no ar (Playwright headless) | `setup-playwright` |
| 5 | Leitura do código (`gh` só leitura) | — |
| 6 | Classificação: evolução ou suporte | `classificacao.md`, `layout.md` |
| 7 | Admin VTEX, quando o cadastro pode explicar o caso | `vtex-admin-login` |
| 8 | Resposta: perguntas ou relatórios | `client-message-language` |

Mensagem com arquivo de vídeo segue também o `video.md`.

## Classificação

| Classificação | Banco de horas | Vai para |
|---|---|---|
| Evolução com layout | Consome | Desenvolvimento (cotação para o cliente) |
| Evolução sem layout, com código | Consome | Desenvolvimento (cotação para o cliente) |
| Evolução sem layout, sem código | Consome | Atendimento e suporte (cotação para o cliente) |
| Suporte com código | Não consome | Desenvolvimento (cotação interna) |
| Suporte de cadastro | Não consome | Atendimento e suporte |
| Solução de dúvida | Não consome | Atendimento e suporte |

Regra rápida: se o que já foi entregue deixou de funcionar, é **suporte**. Se
o cliente quer que funcione ou apareça de outro jeito, é **evolução**.

## Quando a resposta é outra

A skill para e devolve só o retorno de uma skill auxiliar quando:

- a `find-store-repository` não fechou (`confirmacao`, `ambiguo`,
  `incompleto`);
- a `setup-playwright` está em `aguardando_instalacao`;
- a `vtex-admin-login` não está `pronto` (por exemplo, `aguardando_login`);
- a loja não carregou e não há vídeo (devolve uma fala fixa pedindo prints ou
  vídeo).

## Chamado de feedback

Quando o cliente só vem dar um retorno, negativo (reclamação, preocupação com
problemas que se repetem) ou positivo (elogio, agradecimento), sem pedir uma
correção ou mudança, o chamado vai direto para o time de atendimento e
suporte, como o do cliente muito irritado:

- o cliente recebe só a fala fixa de feedback da `client-message-language`
  (negativo ou positivo), sem resumo, perguntas nem pergunta de confirmação;
- o relatório interno diz o tipo de feedback e, como primeiro passo, passa o
  chamado ao atendimento e suporte;
- se o feedback cita pontos concretos da loja, eles são analisados
  normalmente para o atendimento receber os fatos; só feedback não confere
  loja, código nem admin.

## Limites

- Não altera repositório, arquivos locais da loja, cadastro nem `lojas.json`.
- Admin só leitura.
- No checkout, pode simular compra com dados de teste, mas **nunca** clica em
  "Finalizar compra".
- Não estima horas.
- Não promete prazo nem decide se a entrega cabe numa data; a data pedida vai
  para os próximos passos do relatório interno.

## Estrutura dos relatórios

```markdown
# Relatório interno para a Agência e-Plus
## O que o chamado pede
## O que está no ar e no código
## Causa mais provável      (suporte)
## Tipo de demanda          (evolução)
## Layout a desenvolver     (evolução com layout)
## Cobrança
## Próximos passos
### Passo a passo: [o que muda]   (alteração de cadastro, com print em cada passo)

# Relatório para o cliente
[saudação] / Resumo / Direcionamento / [aviso de cotação] / pergunta de confirmação / assinatura
```

## Passo a passo no cadastro

Quando a correção é no cadastro (Site Editor, coleção, produto, promoção ou
outra tela do admin), os próximos passos trazem um passo a passo detalhado da
alteração, com um print do admin em cada passo. A equipe revisa e, se estiver
certo, encaminha para o cliente fazer. Por isso o texto segue a linguagem do
cliente: nomes como aparecem na tela, sem nome interno de bloco nem código.
Os prints são tirados só na leitura: nada é editado, salvo ou publicado para
fazer o print.

## Links nos relatórios

Todo link abre em qualquer máquina: código com a URL do GitHub (arquivo na
branch padrão, com as linhas, commit ou PR), página da loja com a URL
completa e tela do admin com `https://{vendor}.myvtex.com/admin/...`. Nunca
caminho local ou relativo, exceto nos prints do Playwright: cada print entra
como link para o caminho absoluto do arquivo na máquina de quem rodou a
análise, para abrir com um clique, e é salvo localmente para anexar ao
chamado.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Fluxo completo, limites, perguntas e modelo de retorno |
| `classificacao.md` | Evolução x suporte, causas, cobrança, cotação e direcionamento |
| `layout.md` | Evolução com layout: referência visual e seção "Layout a desenvolver" |
| `video.md` | O que fazer quando a mensagem traz vídeo |
| `examples.md` | Exemplos de saída (anexo que não abre, vídeo, loja inacessível etc.) |

## Depende de

`find-store-repository`, `identify-store-technology`,
`identify-store-vendor`, `setup-playwright`, `vtex-admin-login` e
`client-message-language`.
