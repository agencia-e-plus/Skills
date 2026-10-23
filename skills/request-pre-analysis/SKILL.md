---
name: request-pre-analysis
description: >-
  Faz a pré-análise de um chamado de cliente de loja VTEX (problema, dúvida,
  pedido de mudança ou feedback): confere a loja no ar pelo Playwright, o
  código nos repositórios e, quando necessário, o admin VTEX, sem alterar
  nada; classifica como evolução ou suporte e devolve o relatório interno para
  a Agência e-Plus e o relatório para o cliente, ou as perguntas que faltam.
  Chamado que só traz feedback, negativo ou positivo, vai direto ao time de
  atendimento e suporte. Use
  quando o usuário pedir pré-análise ou análise de chamado, ticket ou
  solicitação e informar a mensagem do cliente e o nome da loja, mesmo sem
  defeito descrito. Não use só para localizar repositório.
---

# Pré-análise de solicitação

Analisa um chamado de loja e devolve os próximos passos por escrito. Quem faz
a solicitação é sempre o cliente da loja, não alguém da Agência e-Plus. Como
falar com ele está na `client-message-language`.

## Arquivos e skills

Arquivos desta pasta, lidos quando o caso pedir:

- [classificacao.md](classificacao.md): evolução ou suporte, causa, cobrança e
  encaminhamento.
- [layout.md](layout.md): evolução com layout.
- [video.md](video.md): mensagem com arquivo de vídeo.
- [examples.md](examples.md): exemplos de resposta.

Skills usadas, sempre pelo `SKILL.md` em `${CLAUDE_SKILL_DIR}/../NOME/`, ao
lado desta skill (`${CLAUDE_SKILL_DIR}` é a pasta deste `SKILL.md`; nos
comandos, use o caminho absoluto): `find-store-repository`,
`identify-store-technology`, `identify-store-vendor`, `setup-playwright`,
`vtex-admin-login` e `client-message-language` (toda mensagem para o
cliente).

## Entradas

Só comece com a mensagem do cliente (com os anexos, se houver) e o nome da
loja. Se faltar alguma, peça antes de analisar.

## Limites

- Não altera repositório (editar, formatar, commitar, abrir pull request, dar
  push), arquivo local do projeto da loja (mesmo com o checkout na máquina)
  nem cadastro da loja.
- Admin VTEX: só leitura, pela regra da `vtex-admin-login`.
- Navegador: a configuração do Playwright é só da `setup-playwright`; a
  limpeza semanal (perfil do admin e prints) é do script da
  `vtex-admin-login`.
- `lojas.json`: esta skill não grava.
- Repositório: esta skill não procura; quem procura é a
  `find-store-repository`.
- `gh`: só leitura e só nos repositórios identificados (Uso do gh, na
  `find-store-repository`).
- Requisições permitidas à loja: a página no ar e os GET das skills
  `find-store-repository`, `identify-store-technology` e
  `identify-store-vendor`. Esses GET não substituem o Playwright na
  conferência do trecho.
- Carrinho e checkout: no fluxo do passo 4. Nunca clique no botão final de
  "Finalizar compra".
- Não estime hora.
- Não prometa prazo nem diga se a entrega cabe numa data, num evento ou num
  período (seção Prazo, na `client-message-language`). Se a pessoa citar uma
  data ou perguntar se dá tempo, registre a data no relatório interno, em
  Próximos passos, para a equipe avaliar na cotação. Não decida se dá tempo.

## Quando a resposta é outra

Quando uma linha desta tabela vale, a resposta traz só o que ela diz, sem
relatórios. As quatro primeiras param o fluxo na hora. A última espera o passo
8.

| Situação | A resposta traz só |
|---|---|
| A `find-store-repository` devolveu `confirmacao`, `ambiguo` ou `incompleto` | Esse retorno, com o que ele pede à pessoa. A análise segue depois da resposta. |
| A `setup-playwright` devolveu `aguardando_instalacao` | Esse retorno. Não analise, não use HTML e não espere login. |
| A `vtex-admin-login` devolveu situação diferente de `pronto` | Esse retorno. |
| O Playwright falhou, a página não carregou e a mensagem não tem vídeo | A fala do passo 4 que couber (problema ou pedido de mudança). |
| Falta algo para entender ou executar o pedido (veja Perguntas) | As perguntas, no passo 8, depois de olhar a loja e o código. O que eles respondem não vira pergunta. |

Mensagem com vídeo cuja reprodução não confirmou o problema segue o
[video.md](video.md), que também entrega os relatórios.

Não param a análise: chegar ao trecho sem ver o erro (em suporte, a causa pode
ser inconclusiva) e o trecho fora do HTML com a página carregada (passo 4).

## Chamado de feedback

Alguns chamados não pedem nada da loja: a pessoa vem dar um retorno sobre o
serviço da agência, o andamento do projeto ou a loja. Esse retorno pode ser
negativo (reclamação, preocupação com problemas que se repetem, cobrança de
mais testes ou de mais cuidado) ou positivo (elogio, agradecimento, "ficou
ótimo"). Esse chamado vai direto para o time de atendimento e suporte, como o
do cliente muito irritado.

É chamado de feedback quando o peso da mensagem está no retorno, e não num
pedido de correção, mudança ou resposta sobre a loja. Sinais: a pessoa pede
para "avaliar", "entender" ou "nos orientar" sobre o serviço; fala da
frequência dos problemas, da forma de trabalhar ou dos testes; agradece ou
elogia uma entrega; cita problemas como exemplo do que está dizendo, e não
para pedir a correção de cada um. Uma frase de agradecimento ou reclamação
num chamado que pede uma correção não muda o chamado: ela entra só no humor
(veja a `client-message-language`).

Na dúvida entre feedback e pedido, conte o que a mensagem pede de fato. Se a
pessoa quer que algo na loja seja corrigido, mudado ou explicado, e o retorno
só acompanha esse pedido, siga o fluxo normal.

Como seguir:

- Só feedback, sem ponto concreto na loja (elogio, agradecimento, reclamação
  geral): não confira loja, código nem admin. Leia a mensagem e os anexos
  (passo 3) e vá para o Retorno.
- Feedback que cita pontos concretos da loja (por exemplo, "o botão do
  WhatsApp sumiu" como exemplo de problema recorrente): faça o fluxo para
  esses pontos, do passo 1 ao 8, para o atendimento receber os fatos. Não
  pergunte nada à pessoa: o que faltaria perguntar vai para os Próximos
  passos.

Cliente muito irritado tem prioridade: se o feedback vier com os sinais do
nível muito irritado, use a fala de encaminhamento desse nível.

## Fluxo

Mensagem com arquivo de vídeo: leia o [video.md](video.md) antes do passo 3.

### 1. Identidade da loja

A pré-análise usa a URL da loja e as URLs dos repositórios. Se esta conversa
já tiver o retorno `fechado` da `find-store-repository`, use-o e não peça
de novo o que já veio nele ou na solicitação. Se não tiver, rode essa skill.
Siga só com `fechado`.

### 2. Tecnologia e vendor

Rode a `identify-store-technology` com a URL e os repositórios. Rode a
`identify-store-vendor` aqui só se o cadastro não tiver `vendor`; se tiver,
ela roda no passo 7, e só se o admin for aberto. Se esta conversa já tiver o
retorno de uma delas para a mesma loja, use-o.

- A tecnologia diz o papel de cada repositório (vitrine, checkout, apps) e
  onde o conteúdo se altera ("Onde se altera a vitrine", no retorno). Procure
  o trecho da vitrine só no repositório com esse papel. Com confiança baixa,
  diga no relatório interno qual tecnologia atende a página do chamado.
  Tecnologia `nao_identificada`: diga isso e siga pelos repositórios.
- Com o cadastro sem `vendor`, o resultado não bloqueia a análise. Vendor
  `conflito` ou `nao_encontrado` só pesa se o admin for necessário (passo 7).

### 3. Mensagem e anexos

Leia a mensagem e os anexos. Abra cada link, print ou arquivo que a pessoa
mandou para mostrar a mudança. Anexo que não abre (página não encontrada,
login, timeout ou arquivo ilegível) vai para Perguntas, no passo 8; a análise
continua. Nomeie o trecho da página que o cliente aponta. Um print é estático:
não prova que animação, carrossel ou contador parou.

Veja também se a mensagem é um chamado de feedback (seção Chamado de
feedback). Só feedback, sem ponto concreto: vá direto para o Retorno.

### 4. Loja no ar

Confira o trecho na URL da loja pelo servidor MCP `playwright` (Chromium
headless, sessão isolada). Antes, rode a limpeza semanal, que apaga os prints
com mais de 7 dias:
`bash "${CLAUDE_SKILL_DIR}/../vtex-admin-login/scripts/limpar-perfil-admin.sh"`.
Aqui, a saída `2` não bloqueia: siga. Descubra as ferramentas do namespace e
abra a URL. Navegue até o trecho: clique, hover e viewport. Espere o trecho
aparecer. Não use `networkidle`. Se a queixa for animação, carrossel ou
contador, amostre o estado duas vezes. Prints vão para a pasta definida na
`setup-playwright`. Carrinho e checkout seguem a reprodução no
carrinho, abaixo. Não entre no admin neste passo.

Navegador não pronto (critérios na `setup-playwright`): rode essa skill
com a URL da loja. `pronto`: volte ao início deste passo. `falhou`: siga para
o HTML somente se a página tiver respondido.

HTML, só depois de `falhou` com resposta da página. Use apenas a leitura
read-only do mesmo servidor, como snapshot ou avaliação de
`document.documentElement.outerHTML`. Não use shell, `curl` nem o HTML lido
pelas outras skills para contornar a falha. Confira o trecho no HTML, no CSS e
no JavaScript do repositório que o controla. Sem forma read-only de obter o
documento, trate como página não carregada. Se o trecho não estiver no
documento, a página pode depender de JavaScript: siga para o passo 5, com a
reprodução visual pendente.

Página não carregada e mensagem sem vídeo: não analise o código e não entregue
os relatórios. A resposta traz só uma destas falas, conforme o que a mensagem
descreve:

- Problema, erro ou dúvida: "Não foi possível simular o erro navegando pela
  loja. Você consegue fornecer mais dados, como prints da tela ou um vídeo da
  navegação?"
- Pedido de mudança ou de algo novo: "Não foi possível acessar a loja para
  conferir o trecho da sua solicitação. Você consegue fornecer mais dados,
  como prints da tela atual e o link da página que você quer alterar?"

Reprodução no carrinho e no checkout, quando o chamado envolver carrinho,
frete, promoção, pagamento ou outra etapa da compra. Use a sessão isolada do
servidor `playwright`. Pode adicionar produto(s), ajustar quantidade, aplicar
cupom, informar CEP, simular e escolher o frete, avançar pelas etapas do
checkout e selecionar a forma de pagamento. Para avançar, use dados de teste,
nunca dados reais de pessoas. A única ação proibida no checkout é clicar no
botão final "Finalizar compra" (ou equivalente), que aparece depois de
selecionada a forma de pagamento: pare antes dele. Não altere cadastro,
estoque, preço, promoção ou configuração. Ao terminar, descarte a sessão
isolada e não registre cookies nem tokens. Registre loja, produto, quantidade,
CEP, etapa alcançada e evidência observada (por exemplo, `listPrice` e `price`
do frete no `orderForm`).

### 5. Código

Nos repositórios identificados, ache a branch padrão e o arquivo, sempre com
`gh` só de leitura: `gh api --method GET repos/ORG/REPO` (campo
`default_branch`), `gh api --method GET repos/ORG/REPO/contents/CAMINHO` para
listar pastas e ler arquivos, e `gh search code "TERMO" --repo ORG/REPO` para
achar o texto, a classe ou o componente do trecho. Cite PR e data só quando um
commit explica a mudança; não cite PR para preencher o relatório. Se um PR
recente introduziu o comportamento, o próximo passo aponta para essa tarefa:
não trate como funcionalidade nova.

### 6. Classificação

Classifique pelo [classificacao.md](classificacao.md): evolução ou suporte e,
em suporte, a causa. Evolução com layout segue também o
[layout.md](layout.md).

### 7. Admin

Abra o admin quando ele for necessário para completar a análise, em suporte ou
em evolução. Rode depois de cruzar loja e código.

- Suporte: abra se qualquer parte puder vir do cadastro. Separe o chamado em
  partes quando computador e celular, ou dois blocos, puderem ter causas
  diferentes: um defeito no código publicado não dispensa o admin se outra
  parte puder vir do cadastro. O admin fica de fora só quando o arquivo e o PR
  explicam o comportamento, o conteúdo do bloco não vem de Site Editor, banner
  ou binding, e a pessoa não alterou o cadastro. Carrossel, CSS ou hover cujo
  conteúdo vem de banner, Site Editor ou binding pede o admin.
- Evolução: abra quando a análise ou a descrição do layout depende de algo que
  só o cadastro mostra, como a coleção de uma prateleira que vai ser
  reaproveitada, o conteúdo atual do Site Editor, placeholders ou uma
  configuração da conta.

Cadastro inclui conteúdo, preço, promoção, produto, categoria, banner, e-mail
transacional, checkout, frete, pagamento, app, Master Data e qualquer
configuração da conta. Entram o Site Editor, o texto ou a imagem que a pessoa
diz ter alterado, e um bloco que pode ter valor diferente por dispositivo,
binding ou página. Uma prop que o admin sobrescreve, como visibilidade, texto
ou imagem, pede o registro mesmo quando o arquivo tem um padrão.

Site Editor por dispositivo. O Site Editor guarda o conteúdo de cada versão
(computador, tablet e celular) separado, e blocos como `footer-layout.mobile`,
`header-layout.mobile` e `responsive-layout.mobile` só aparecem na versão do
dispositivo deles. Quando o chamado cita um dispositivo, ou o comportamento
muda de um dispositivo para outro, leia o bloco em cada versão que o chamado
envolve, trocando o dispositivo na barra do Site Editor. Registre o valor de
cada versão (link, texto, imagem, coleção, visibilidade). Não conclua o valor
de uma versão pelo site no ar nem pelo valor de outra versão. Abra o bloco só
para ler: não altere campo, não salve e não publique; saia sem salvar.

Para chegar a um campo, clique só no nome do bloco ou do item que abre a
leitura. Não clique em Adicionar, Remover, Duplicar, chave, caixa de seleção
nem opção de lista. Se o botão Salvar ficar ativo sem que você tenha mudado
nada, ou se um clique criar ou mudar algo na tela, saia por Cancelar e
Descartar, e confira na loja no ar que nada mudou.

Quando a correção ou a mudança for no cadastro, tire nessa mesma leitura os
prints do passo a passo (seção Passo a passo no cadastro): cada tela do
caminho, do menu até o campo que muda.

O que o admin mostra em leitura não vira próximo passo. Não deixe "conferir no
Site Editor" ou "ver no admin" para quem segue o chamado quando você mesmo
podia ler. Se a tela não abriu ou não mostrou o valor, diga isso no relatório
interno.

Antes de abrir, rode a `identify-store-vendor`, se ela ainda não rodou nesta
conversa para a mesma loja. Se o vendor identificado divergir do cadastro,
registre os dois no relatório interno. O admin usa o do cadastro; se a conta
não for a da loja, a `vtex-admin-login` pede o vendor correto e sugere o
identificado.

Use a `vtex-admin-login` com o nome e a URL da loja e o retorno da
`identify-store-vendor`; não peça o vendor antes disso. Com `pronto`, use o
que foi lido para fechar a causa (ou rever a classificação do passo 6) e
completar a descrição, e cite a tela e o registro em "O que está no ar e no
código".

### 8. Resposta

Antes de responder, confira a base da causa e da classificação. Liste cada
fato em que elas se apoiam e marque se você viu (na loja no ar, no código ou
no admin) ou se deduziu. Fato deduzido que a loja, o código ou o admin podem
mostrar precisa ser lido agora, antes da resposta, e não vai para os próximos
passos. Exemplos: o valor de um link no Site Editor do celular, deduzido pelo
site no ar ou pela versão do computador; o estoque de um produto, deduzido
pela vitrine vazia. Se o admin for necessário e ainda não estiver aberto,
volte ao passo 7. Quando a leitura não for possível (tela que não abre,
permissão), diga isso no relatório interno e trate o ponto como não
confirmado: a causa que depende dele fica inconclusiva, e a correção não é
prometida.

Comparação com um bloco que funciona. Quando a loja tem um bloco parecido
funcionando (outra vitrine, outro menu, o mesmo bloco em outro dispositivo ou
em outra página), compare os dois antes de fechar a causa: as props no código,
a configuração no Site Editor e a consulta que cada um faz na loja no ar (por
exemplo, as variáveis da query `Products` de cada vitrine). A diferença entre
eles costuma ser a causa, ou mostra que a causa é outra. Não use o bloco que
funciona como prova de que um dado está certo (estoque, link, coleção) sem ver
por que ele funciona: uma vitrine que mostra produtos pode estar só sem o
filtro de indisponíveis. Registre a comparação em "O que está no ar e no
código".

Se faltar algo, siga Perguntas. Se não, entregue os relatórios (Retorno).

## Perguntas

Antes de entregar a pré-análise, tire toda dúvida sobre o que a pessoa espera
ou quer. Se a solicitação não ficou clara, se você não entendeu ou se falta
informação, pergunte direto a ela: quantas perguntas forem necessárias, mas só
sobre o que a mensagem, os anexos, a loja e o código não respondem. A resposta
traz só as perguntas, no formato da `client-message-language`, com o contexto
antes delas quando a pergunta é uma escolha sobre o que a análise encontrou. A
pré-análise sai depois das respostas, já alinhada ao que foi confirmado. Com
cliente muito irritado ou chamado de feedback, não pergunte: siga o Retorno.

Também vão para Perguntas:

- Anexo que mostra a mudança e não abriu (não abre, pede login, dá página não
  encontrada ou não dá para ler). Peça o material de novo, em print, arquivo
  ou outro link, e pergunte o que a mensagem, a loja e o código não mostram.
  Não descreva a proposta que você não viu. Não deixe "pedir para reenviar"
  nos próximos passos. O texto do e-mail não substitui esse anexo, e ter lido
  a loja e o código não libera os relatórios. Arquivo de vídeo não entra aqui
  (veja o video.md).
- Dado que a pessoa quer trocar, sem o valor novo: telefone, texto, e-mail,
  link ou outro valor que já está na loja. Pergunte qual valor entra no lugar,
  citando o valor de hoje e o trecho que ela vê. O mesmo valor em mais de um
  idioma: uma pergunta só, dizendo que vale para esses idiomas. Saber o
  arquivo não libera os relatórios, e a pergunta de confirmação do relatório
  não recolhe esse valor.
- Evolução com layout sem referência visual, ou com item indefinido que muda o
  resultado (veja o [layout.md](layout.md)).
- Correção que depende de uma escolha da pessoa: a causa já está confirmada e
  há mais de um caminho, e quem escolhe é ela. Exemplo: a vitrine não mostra
  produtos porque todos os itens da coleção estão sem estoque, e ela pode
  repor o estoque, trocar os produtos da coleção ou usar outra coleção na
  vitrine. Explique o que encontrou e pergunte como ela quer seguir, citando
  os caminhos. A escolha não fica nos próximos passos para o atendimento
  perguntar depois. Num chamado com mais de um ponto, a mensagem já diz o que
  foi encontrado em cada ponto, e só pergunta o que depende da escolha.

## Retorno

Responda em português. Saem os dois relatórios, o interno e o relatório para o
cliente, exceto:

- Suporte com causa inconclusiva: o relatório interno e, no lugar do relatório
  para o cliente, só o aviso de apuração, com saudação e assinatura: "Estamos
  apurando o seu chamado com a equipe de atendimento e suporte e em breve
  entraremos em contato." Sem resumo, sem direcionamento, sem aviso de cotação
  e sem pergunta de confirmação. O relatório para o cliente só entra quando a
  causa já pode ser dita sem prometer correção errada.
- Mensagem com vídeo sem reprodução confirmada: como no video.md.
- Cliente muito irritado, pelo nível Humor do cliente da
  `client-message-language`: o relatório interno e, no lugar do relatório
  para o cliente ou das perguntas, só a fala de encaminhamento dessa skill,
  com saudação e assinatura. Vale mesmo quando ainda faltariam perguntas. No
  relatório interno, em Próximos passos, o primeiro item é passar o chamado
  ao time de atendimento e suporte, citando os trechos da mensagem que
  mostram a irritação.
- Chamado de feedback (seção Chamado de feedback): o relatório interno e, no
  lugar do relatório para o cliente ou das perguntas, só a fala de feedback
  da `client-message-language` (negativo ou positivo), com saudação e
  assinatura. No relatório interno:
  - O que o chamado pede: o tipo de feedback (negativo ou positivo) e, em
    uma ou duas frases, o que a pessoa diz.
  - Só feedback, sem ponto concreto: no lugar de "O que está no ar e no
    código" e de Causa ou Tipo de demanda, escreva "Feedback, sem ponto
    concreto na loja para analisar.". Cobrança: "Não se aplica: feedback."
  - Com pontos concretos: as seções de sempre, ponto a ponto, com a
    classificação e a cobrança de cada um.
  - Próximos passos: o primeiro item é passar o chamado ao time de
    atendimento e suporte, citando os trechos da mensagem que mostram o
    feedback. Depois, o que cada ponto concreto pede, e o que faltaria
    perguntar à pessoa.

Exemplos em [examples.md](examples.md).

```markdown
# Relatório interno para a Agência e-Plus

## O que o chamado pede
[Uma frase: trecho da loja e o que o cliente pede. Pode citar o nome do cliente.]

## O que está no ar e no código
[Primeira linha: tecnologia (CMS, IO, Deco, FastStore ou nao_identificada), repositório da vitrine e vendor, com a origem (cadastro ou identificação, com a situação); se a identificação rodou e divergiu do cadastro, os dois. Depois, arquivo (link do GitHub, com as linhas) e como funciona hoje. PR ou commit (link do GitHub) só quando explicam a mudança. Página conferida com a URL completa da loja. Em cadastro, a tela (URL do admin) e o registro. Veja Links.]

## Causa mais provável
[Só em suporte. Uma das quatro causas do classificacao.md, com a evidência que você viu: tela do admin, arquivo ou o que apareceu na loja no ar. Não use dedução no lugar de leitura (passo 8). Se houver mais de um candidato, diga qual falta reproduzir.]

## Tipo de demanda
[Só em evolução, no lugar de Causa mais provável: o valor da tabela do classificacao.md.]

## Layout a desenvolver
[Só em evolução com layout, logo depois de Tipo de demanda. Veja o layout.md.]

## Cobrança
[Evolução ou Suporte e o que é, pela coluna Cobrança do classificacao.md. Se houver cotação, diga como a coluna Cotação descreve. Sem estimar hora.]

## Próximos passos
1. [Ação concreta de quem vai seguir o chamado, na ordem das colunas Cotação e Depois da cotação do classificacao.md. Pode dizer "explicar para [nome do cliente]...".]
2. [...]
3. [Em alteração de cadastro: "Revisar o passo a passo abaixo e, se estiver certo, encaminhar para [nome do cliente] fazer a alteração."]

### Passo a passo: [o que muda no cadastro]
[Só em alteração de cadastro. Veja Passo a passo no cadastro.]

1. [Ação, com o nome exato do que clicar e onde fica na tela.]
   Print: [link do print]
2. [...]

# Relatório para o cliente

[Saudação, se for a primeira mensagem.]

Resumo do problema:
[O que foi pedido e o que encontramos.]

[Direcionamento, pelo classificacao.md.]

[Só quando a coluna Cotação do classificacao.md diz que a cotação vai para o cliente: "Sua solicitação foi encaminhada para cotação. Em breve você receberá o valor e mais detalhes."]

É isso mesmo que você precisava? Se quiser corrigir ou adicionar mais alguma informação, pode fazer isso agora, antes de seguirmos com o encaminhamento do chamado para a próxima etapa.

[Assinatura.]
```

O relatório interno é técnico: pode nomear o cliente e orientar a agência
("explicar para a Degusta Casa..."). A exceção é o passo a passo no
cadastro, escrito para o cliente (seção Passo a passo no cadastro). O relatório para o cliente segue a
`client-message-language`, inclusive na saudação e na assinatura.

No resumo, use o rótulo que couber: Resumo do problema, Resumo da solicitação
ou Resumo da evolução.

A pergunta de confirmação vem depois do direcionamento e do aviso de cotação,
sempre com o texto do modelo. Ela não entra no relatório interno e não
substitui Perguntas: se a análise ainda não saiu, a resposta continua trazendo
só as perguntas. Sem relatório para o cliente, ela não entra.

## Passo a passo no cadastro

Quando a correção ou a mudança, ou uma parte dela, é no cadastro da loja
(suporte de cadastro, evolução sem código ou solução de dúvida que indica uma
tela do admin), os Próximos passos trazem o passo a passo dessa alteração. A
equipe revisa o passo a passo e, se estiver certo, encaminha para o cliente
fazer. Por isso ele precisa funcionar sozinho, para quem nunca abriu aquela
tela.

Ele vale também quando a correção já foi feita e só falta uma parte: monte o
passo a passo do que falta. Não vale para o que é só código.

Como montar:

- Um passo a passo por alteração, com o título do que muda. Se a mesma
  alteração vale para mais de um dispositivo no Site Editor, cada versão tem
  os seus passos, começando pela troca do dispositivo.
- O primeiro passo abre a tela: a URL completa do admin, com o vendor
  conferido, e o caminho pelo menu como a pessoa vê (por exemplo, Storefront >
  Site Editor).
- Um passo por ação: abrir a tela, trocar o dispositivo, abrir o bloco, abrir
  o item, mudar o campo, salvar e conferir. Diga onde o elemento fica na tela
  (barra de cima, coluna da esquerda, painel da direita) e use os nomes
  exatamente como aparecem na tela, com as mesmas maiúsculas: bloco, item,
  campo e botão.
- No passo que muda o dado, diga o valor de hoje e o que fazer: o valor que
  entra, o item que sai ou a opção que liga ou desliga. Valor que a pessoa
  ainda não deu vai para Perguntas, não para o passo a passo.
- Diga o que a tela avisa ou pede antes de salvar ou publicar. No Site
  Editor, a alteração vale na hora para a loja em produção.
- O último passo confere na loja no ar: a URL completa, o dispositivo e o
  que deve aparecer depois da alteração.
- O texto vai para o cliente: siga os Termos da `client-message-language`,
  sem nome interno de bloco (como footer-layout.mobile ou menu#footerMenu1),
  caminho de árvore, arquivo ou código. Use a segunda pessoa e o imperativo
  ("Clique em", "Desligue"). Sem saudação e sem assinatura: o passo a passo
  fica no relatório interno.

Prints:

- Cada passo que mostra uma tela tem o seu print, logo depois do texto do
  passo ("Print: [link]"). Tire os prints no admin, pelo `playwright-admin`,
  na leitura do passo 7. O print mostra a tela no ponto do passo: o menu, o
  botão do dispositivo, o bloco aberto, o item aberto, o campo que muda.
- Pode destacar no print o que clicar, com um contorno desenhado só na página
  aberta no navegador (por exemplo, um `outline` vermelho aplicado pelo
  `browser_evaluate`). O destaque não clica, não muda campo e some ao
  recarregar.
- Nunca edite, salve ou publique para fazer um print. No passo de mudar o
  campo e no de salvar, o print mostra o campo com o valor de hoje e o botão
  Salvar, sem clicar nele; o texto do passo diz o que fazer.
- O passo de conferir na loja no ar usa um print da página de hoje, tirado
  pelo `playwright`, com o trecho que vai mudar.
- Nome do print: `[loja]-passo-[NN]-[o-que-mostra].png`, sem espaços. O link
  segue a regra de prints da seção Links.
- Se uma tela não abriu, ou se não deu para chegar ao ponto sem alterar algo,
  diga isso no passo e não invente o caminho.

## Links

Todo link do relatório interno precisa abrir uma página válida em qualquer
máquina: quem recebe o relatório não tem os arquivos desta máquina. Por isso,
nenhum link aponta para um caminho local (`/home/...`, `~/...`, `file://`) nem
para um caminho relativo como `src/manifest.json`, que a interface transforma
em link para a pasta de trabalho. A única exceção são os prints do Playwright
(último item abaixo).

- Código: use a URL do GitHub do repositório que você leu, na branch padrão
  (passo 5), com as linhas quando citar um trecho:
  `[src/manifest.json](https://github.com/ORG/REPO/blob/BRANCH/src/manifest.json)`
  e
  `[bupbaby.shipping-simulator.scss:402-404](https://github.com/ORG/REPO/blob/BRANCH/CAMINHO#L402-L404)`.
  Pasta: `https://github.com/ORG/REPO/tree/BRANCH/CAMINHO`. Commit:
  `https://github.com/ORG/REPO/commit/SHA`. PR:
  `https://github.com/ORG/REPO/pull/NUMERO`. Repositório:
  `https://github.com/ORG/REPO`.
- Loja: a URL completa da página conferida no Playwright, como
  `https://www.loja.com.br/produto/p`, e não só o nome do produto ou o SKU.
- Admin: a URL completa da tela lida, em
  `https://{vendor}.myvtex.com/admin/...`, com o vendor conferido.
- Caminho de arquivo sem link (o nome de uma classe, de um bloco ou de um
  arquivo citado no meio da frase) vai em texto, sem crase, para não virar
  link local. Quando o arquivo importa, use o link do GitHub.
- Print salvo pelo Playwright fica só na máquina de quem roda a análise.
  Cite cada print como link para o caminho absoluto do arquivo, para quem lê
  abrir a imagem com um clique:
  `[kolplast-revendedor.png](/home/USUARIO/.claude/playwright/prints/kolplast-revendedor.png)`.
  Use o caminho real, com o `$HOME` expandido: não use `~`, `$HOME`, caminho
  relativo nem `file://`. Salve o print com nome sem espaços, para o link não
  quebrar. Diga que ele está salvo localmente para ser anexado ao chamado.
  Esse link só entra no relatório interno, nunca no relatório para o cliente.

Antes de entregar, confira cada link: ele começa com `https://` e aponta para
o GitHub, a loja ou o admin, ou é o caminho absoluto de um print que existe
nesta máquina. Link que você não montou a partir do que leu
(arquivo, branch, linha, SHA ou URL da página) não entra.
