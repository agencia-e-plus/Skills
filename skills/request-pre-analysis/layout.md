# Evolução com layout

Parte da `request-pre-analysis`. Vale quando a classificação é evolução com
layout (veja o [classificacao.md](classificacao.md), onde também estão a
cobrança, a cotação e a aprovação).

Por enquanto, não há etapa de design nem de protótipo: o desenvolvedor monta o
layout enquanto codifica, a partir da seção "Layout a desenvolver" do
relatório interno, e o desenvolvimento cota as horas a partir dessa descrição.

## Referência visual

O layout precisa de uma referência visual do que o cliente quer: print,
imagem, Figma, Photoshop, link de outro site ou de outra página da própria
loja. Se o cliente não mandou nenhuma, siga Perguntas, no `SKILL.md`, e peça.
Pergunte também o que a referência e o texto não definem e muda o resultado:
ordem dos elementos, o que entra em cada bloco, textos e imagens (quem
fornece), cores ou destaque, comportamento (carrossel, link, botão), diferença
entre computador e celular, e o que o cliente quer editar sozinho pelo Site
Editor. Não invente o layout para preencher a lacuna.

## O que está no ar e no código

Na evolução com layout, essa seção do relatório interno descreve a página no
ar e o que o anexo muda. Isso só vale com o anexo aberto. Um print de
carrossel é um quadro: diga os slides que estão no ar.

## Layout a desenvolver

A seção só entra depois de haver referência visual. Quem lê é o desenvolvedor
que vai montar a tela sem protótipo: ele precisa entender, só por esta seção,
o que construir e como. Junte tudo o que o cliente mandou (mensagem,
respostas, anexos, referências) e o que a análise da loja e do código mostrou.
Escreva assim:

- Página e endereço: onde o layout entra, rota e arquivo, e se é página nova
  ou troca de conteúdo.
- Estrutura geral: o que continua (cabeçalho, menu lateral, breadcrumb,
  rodapé) e o que sai.
- Blocos, na ordem de cima para baixo, numerados. Para cada bloco: o que
  mostra, o conteúdo (texto, imagem, produtos), de onde vem o conteúdo (Site
  Editor, coleção, código, cliente fornece), o comportamento (carrossel,
  autoplay, link, botão e destino, clique) e a diferença entre computador e
  celular.
- Identidade visual: cores, fontes, espaçamentos e estilo pedidos, ou a
  página/site de referência e o que copiar dela. Cores em hexadecimal, quando
  a loja ou a referência mostrarem.
- Referências: cada link ou anexo, e o que o cliente quer aproveitar de cada
  um.
- O que reaproveitar da loja: blocos, prateleiras, componentes ou scripts já
  existentes, com o arquivo.
- O que o cliente edita sozinho: os campos que precisam ficar no Site Editor.
- Pendências: material que o cliente ainda vai enviar (imagens, textos) e quem
  envia.

Não deixe para o desenvolvedor adivinhar. Se algo da lista não foi definido e
muda o resultado, volte a Perguntas antes de entregar os relatórios.
