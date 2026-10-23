# Classificação da demanda

Parte da `request-pre-analysis`. Classifique evolução ou suporte antes de
procurar a causa.

- **Evolução:** consome do banco de horas. Pode ser modificação em código, em
  plataforma, ou nos dois.
- **Suporte:** não consome do banco de horas. Correções em código ou no
  cadastro, soluções de dúvidas, orientação para o cliente falar com um
  terceiro (provedor de pagamento, ERP e outras ferramentas externas) e
  encaminhamento de falhas da própria VTEX.

Não trate suporte como evolução. Na cobrança, diga também o que é: mexer em
código, ajuste de um bug, mexer em cadastro, solução de dúvida, mudança de
layout, modificação em plataforma, orientação para contato com o terceiro,
encaminhamento para o suporte da VTEX, ou a combinação que couber.

## Como decidir

- **Outra exibição: evolução com layout.** A loja está de um jeito e o cliente
  pede outra exibição, mesmo quando manda só texto, print, Figma ou Photoshop.
  Outra exibição inclui informação, bloco, botão ou link novo no que a pessoa
  vê: página, e-mail transacional ou área logada, como Meus Pedidos. Mesmo que
  essa página, e-mail ou área já exista, é evolução com layout. Siga também o
  [layout.md](layout.md).
- **Mesma exibição, muda o que está por trás: evolução sem layout.** A pessoa
  continua vendo os mesmos blocos e os mesmos campos; muda regra, integração,
  origem do dado ou comportamento por trás dessa exibição. Pode ser código,
  plataforma ou os dois.
- **Dado que está no código: evolução sem layout, com código.** A pessoa
  pergunta onde muda um dado, ou pede a troca, e o valor está no código. Ela
  não altera isso no cadastro da loja: não é Site Editor, banner, binding nem
  outra tela do admin. É a mesma tela, com os mesmos blocos e campos e outro
  valor no que já aparece. Não é solução de dúvida e não vai para o
  atendimento para ela mesma alterar. No relatório para o cliente, diga que a
  alteração é no código (regra em Termos, na `client-message-language`).
  Sem o valor novo, siga Perguntas, no `SKILL.md`.
- **Quebra: suporte com código.** Bug, quebra de layout ou quebra de
  comportamento.
- **Problema só de cadastro, sem código: suporte de cadastro.** O chamado não
  precisa do time de desenvolvimento.
- **Problema em ferramenta de terceiro: suporte com terceiro.** A falha ou a
  recusa está numa ferramenta externa à plataforma, como provedor de
  pagamento, antifraude, ERP ou outra integração de terceiro, e não no código
  nem no cadastro da loja. Quem resolve é o terceiro, e o contato com ele é do
  cliente: o tema é sensível e o contrato da agência não inclui suporte a
  ferramentas externas. A equipe de atendimento e suporte orienta o cliente,
  com a evidência e uma mensagem pronta para o terceiro. Pagamento recusado
  pelo provedor segue também a seção Pagamento recusado pelo provedor, no
  `SKILL.md`.
- **Falha na própria VTEX: suporte com a plataforma.** A evidência aponta para
  a plataforma, e não para o código, o cadastro ou um terceiro (por exemplo, a
  tentativa de pagamento nem chega ao provedor). A equipe de atendimento e
  suporte abre o chamado com a VTEX. Siga a seção Falha na plataforma VTEX, no
  `SKILL.md`.
- **Solução de dúvida: suporte.** Quando a resposta encerra o pedido e ninguém
  precisa alterar a loja, ou quando o dado se altera no cadastro e o
  atendimento indica a tela.

Comportamento: se o que já foi entregue deixou de funcionar como foi feito, é
quebra (suporte). Se a pessoa quer que funcione de outro jeito, é evolução.

## Tabela

| Classificação | Tipo de demanda (relatório interno) | Cobrança | Cotação | Depois da cotação | Direcionamento (relatório para o cliente) |
|---|---|---|---|---|---|
| Evolução com layout | `Evolução. Precisa de layout.` | Evolução: consome do banco de horas | Uma só, de desenvolvimento, com o layout incluído. Vai para o cliente, com uma única aprovação | Aprovadas as horas, entra na sprint backlog de desenvolvimento. Com o desenvolvimento em produção na loja, e aprovado pelo cliente, a solicitação é encerrada | "Estamos direcionando essa demanda de evolução para a equipe de desenvolvimento." |
| Evolução sem layout, com código | `Evolução. Sem mudança de layout ou estrutura.` | Evolução: consome do banco de horas | Vai para o cliente | Aprovadas as horas, entra na sprint backlog de desenvolvimento | "Estamos direcionando essa demanda de evolução para a equipe de desenvolvimento." |
| Evolução sem layout, sem código | `Evolução. Sem mudança de layout ou estrutura.` | Evolução: consome do banco de horas | Vai para o cliente | Aprovadas as horas, vai para a equipe de atendimento e suporte, sem desenvolvimento | "Estamos direcionando essa demanda de evolução para a equipe de atendimento e suporte." |
| Suporte com código | Não tem (usa Causa mais provável) | Suporte: não consome do banco de horas | Horas cotadas internamente; não vai para o cliente | Entra na sprint backlog de desenvolvimento | "Estamos direcionando essa demanda de suporte para a equipe de desenvolvimento." |
| Suporte de cadastro | Não tem (usa Causa mais provável) | Suporte: não consome do banco de horas | Não há | Equipe de atendimento e suporte, sem desenvolvimento | "Estamos direcionando essa demanda de suporte para a equipe de atendimento e suporte." |
| Suporte com terceiro | Não tem (usa Causa mais provável) | Suporte: não consome do banco de horas | Não há | Equipe de atendimento e suporte, sem desenvolvimento e sem passo a passo no cadastro: orienta o cliente a falar com o terceiro, com a mensagem pronta | "Estamos direcionando essa demanda de suporte para a equipe de atendimento e suporte." |
| Suporte com a plataforma | Não tem (usa Causa mais provável) | Suporte: não consome do banco de horas | Não há | Equipe de atendimento e suporte, que abre chamado no suporte da VTEX com as evidências | Não tem: o cliente recebe só a fala de encaminhamento da seção Falha na plataforma VTEX |
| Solução de dúvida | Não tem (usa Causa mais provável) | Suporte: não consome do banco de horas | Não há | Equipe de atendimento e suporte | "Estamos direcionando essa demanda de suporte para a equipe de atendimento e suporte." |

Mensagem com vídeo sem reprodução confirmada não entra na tabela: siga o
[video.md](video.md).

Chamado de feedback também não entra na tabela como um todo: siga a seção
Chamado de feedback, no `SKILL.md`. Só os pontos concretos que ele citar são
classificados aqui.

## Mais de um time

Quando partes do chamado vão para times diferentes, o relatório para o cliente
explica a ordem, que é a mesma dos próximos passos. Uma frase por time: a
primeira diz para qual time vai agora e o que ele vai fazer; a seguinte, o
time de depois e o que ele vai fazer. O que cada time faz é dito com o que a
pessoa reconhece na loja. Exemplo: "Primeiro, essa demanda vai para a equipe
de atendimento e suporte, para ligar o texto na versão do celular. Depois, vai
para a equipe de desenvolvimento, para o restante do texto aparecer no
computador."

## Causa (só em suporte)

Cruze loja e código e classifique a causa como uma destas:

- defeito no código publicado
- configuração ou conteúdo, sem mudança de código (em Suporte com terceiro,
  do lado do terceiro)
- comportamento previsto (pausa no hover, `prefers-reduced-motion`, dado
  vazio)
- falha na plataforma VTEX (Suporte com a plataforma)
- inconclusivo

Em solução de dúvida, a causa costuma ser comportamento previsto ou
configuração ou conteúdo.

Causa inconclusiva: o próximo passo é reproduzir. Não invente correção.

Evolução não usa essas causas, não cai em inconclusivo e não tem o próximo
passo de reproduzir.
