# Exemplos

Os exemplos mostram só a saída; as regras estão no `SKILL.md` e nos outros
arquivos desta pasta. Nos exemplos, a mensagem não traz o nome da pessoa,
então a saudação usa "Olá, equipe [loja]!". Com o nome, use a saudação do
horário, como manda a `client-message-language`.

# Anexo que não abre

Entrada: a Banana Brasil pede reestruturação do Fale Conosco, lista campos
novos e manda um link de artefato como referência da nova exibição. O link
abre "Page not found". A loja e o código já mostram o formulário atual.

Saída, na primeira mensagem para o cliente:

```markdown
Olá, equipe Banana Brasil! Tudo bem?

Para podermos seguir com a análise, pedimos que você responda às perguntas abaixo:

1. Você consegue reenviar a referência do formulário? O link abre como página não encontrada. Pode ser um print, um arquivo ou outro link.
2. Os campos de quantidade comprada, local da compra, data da compra e lote entram sempre, ou só quando o contato é sobre produto?
3. O que você chama de local da compra: o nome da loja, a cidade ou o canal, como o site ou um marketplace?
4. A reorganização vale só para a aba Sac, ou a aba Trabalhe Conosco também muda?

Atendimento Agência e-Plus
```

# Vídeo sem reprodução confirmada

Entrada: o cliente descreve por escrito o que viu na loja e anexa um mp4. A
loja no ar, conferida pelo que o texto diz, não mostra o problema.

Trecho do relatório interno:

```markdown
## Cobrança

Não classificado. Vídeo não assistido.

## Próximos passos

1. Encaminhar ao time de atendimento e suporte para uma apuração mais detalhada.
```

Trecho do relatório para o cliente:

```markdown
Estamos direcionando esse chamado para a equipe de atendimento e suporte, para conferirem o vídeo e seguirem a apuração.
```

# Loja inacessível

Entrada: a Degusta Casa relata um erro na loja, sem vídeo. A
`setup-playwright` devolveu `falhou` e a página não carregou.

Saída, na primeira mensagem para o cliente:

```markdown
Olá, equipe Degusta Casa! Tudo bem?

Tentamos simular o erro navegando pela loja, mas não conseguimos ver o que você descreveu. Você poderia nos enviar mais detalhes, como prints da tela ou o passo a passo da simulação do problema?

Atendimento Agência e-Plus
```

# Evolução com layout, sem referência visual

Entrada: a Miess pede, em texto, o número da nota fiscal, a chave de acesso e
o PDF no e-mail de faturamento e em Meus Pedidos. Não há print, Figma,
Photoshop nem link de referência.

Saída, na primeira mensagem para o cliente:

```markdown
Olá, equipe Miess! Tudo bem?

Para podermos seguir com a análise, pedimos que você responda às perguntas abaixo:

1. Você tem uma referência de como quer ver essas informações? Pode ser um print, uma imagem ou o link de outra loja que mostre algo parecido.
2. No e-mail de faturamento, as informações da nota entram em qual parte: logo no início, junto do resumo do pedido ou no final?
3. Em Meus Pedidos, elas aparecem dentro de cada pedido, ou também na lista de pedidos?
4. O PDF da nota abre em um botão ou em um link? Qual texto deve aparecer nele?

Atendimento Agência e-Plus
```

# Troca de dado no código, sem o valor novo

Entrada: a Hector Albertazzi pergunta onde alterar o telefone do aviso depois
do cadastro B2B, em português e inglês, e marca no print o
`+55 11 99592-2595`. O número está no código. O número novo não veio na
mensagem.

Saída, na primeira mensagem para o cliente:

```markdown
Olá, equipe Hector Albertazzi! Tudo bem?

Para podermos seguir com a análise, pedimos que você responda às perguntas abaixo:

1. Qual é o telefone novo que entra no lugar de +55 11 99592-2595, na mensagem de WhatsApp da tela "Solicitação enviada com sucesso!"? Esse número vale para o português e para o inglês.

Atendimento Agência e-Plus
```

Relatório para o cliente, depois da resposta com o número novo. Não é mais a
primeira mensagem, então não tem saudação:

```markdown
Resumo da evolução:

O telefone da mensagem de WhatsApp da tela "Solicitação enviada com sucesso!" vai mudar de +55 11 99592-2595 para [número novo], em português e em inglês. Essa alteração é no código dessa tela, não no cadastro da loja, e a equipe de desenvolvimento faz a troca.

Estamos direcionando essa demanda de evolução para a equipe de desenvolvimento.

Encaminhamos a sua solicitação para cotação. Em breve você vai receber o valor e mais detalhes.

É isso mesmo que você precisava? Se quiser corrigir ou acrescentar alguma informação, fique à vontade para nos contar agora, antes de seguirmos com o chamado para a próxima etapa.

Atendimento Agência e-Plus
```

# Correção que depende de uma escolha da pessoa

Entrada: a Ofner relata que, no celular, o "Regulamento" do rodapé não abre e
que a vitrine "Encontre o presente ideal" não carrega. No Site Editor, versão
celular, os itens do rodapé estão sem link; no computador, com link. A
vitrine usa a coleção "Recomendação de presentes", e os 12 produtos dela
estão com estoque zero. Corrigir a vitrine depende do que a Ofner escolher.

Saída, na primeira mensagem para o cliente:

```markdown
Olá, equipe Ofner! Tudo bem?

Conferimos os dois pontos na loja.

No celular, o "Regulamento" do rodapé está sem link, por isso o toque não abre nada. O mesmo acontece com "Quem somos", "Política e Segurança", "Política de Cookies" e "Trabalhe Conosco". No computador, esses links funcionam.

A vitrine "Encontre o presente ideal" mostra os produtos da lista "Recomendação de presentes". Os 12 produtos dessa lista estão sem estoque no site, como o Tablete Biscofner, o Tablete Dubai e o Bombom Art de L'Ocean. Como a vitrine mostra só produtos disponíveis para compra, ela fica vazia, no celular e no computador.

Para podermos seguir com a análise, pedimos que você responda às perguntas abaixo:

1. Como você quer seguir com a vitrine "Encontre o presente ideal"? Você pode repor o estoque desses 12 produtos, trocar os produtos dessa lista por outros com estoque ou usar outra lista de produtos na vitrine. Se for trocar, diga quais produtos ou qual lista entram.

Atendimento Agência e-Plus
```

# Passo a passo no cadastro

Entrada: a Ofner aprovou tirar a "Política de Cookies" do menu Institucional
do rodapé no celular. O item está no Site Editor, versão celular, e a
alteração é de cadastro. Os prints foram tirados na leitura do admin, sem
salvar.

Trecho do relatório interno:

```markdown
## Próximos passos

1. Revisar o passo a passo abaixo e, se estiver certo, encaminhar para a Ofner fazer a alteração.

### Passo a passo: tirar a Política de Cookies do rodapé no celular

1. Abra o Site Editor da loja: https://ofnerio.myvtex.com/admin/cms/site-editor. Pelo menu da esquerda, o caminho é Storefront > Site Editor.
   Print: [ofner-passo-01-site-editor.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-01-site-editor.png)
2. Na barra de cima, à direita do campo URL, clique no primeiro dos três ícones de dispositivo, "Visualização para celular". A pré-visualização muda para a versão do celular.
   Print: [ofner-passo-02-dispositivo-celular.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-02-dispositivo-celular.png)
3. Na coluna "Blocos", à direita, clique na setinha ao lado de "Rodapé".
   Print: [ofner-passo-03-rodape.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-03-rodape.png)
4. Abra pela setinha, nessa ordem: "Mobile", "Footer Menu Mobile", "Institucional" e "editor.menu.submenu.title". Depois, clique no nome "Menu Rodapé Institucional".
   Print: [ofner-passo-04-menu-institucional.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-04-menu-institucional.png)
5. O painel "Menu" abre, com 7 linhas chamadas "Item" em "Item do Menu". Para confirmar qual é a Política de Cookies, clique na quarta linha: o painel "Item do Menu" mostra o Texto "Politica de Cookies" e o href "/politica-de-cookies". Não mude nada aqui e clique em "VOLTAR", no topo do painel.
   Print: [ofner-passo-05-item-politica-de-cookies.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-05-item-politica-de-cookies.png)
6. De volta à lista, passe o mouse na quarta linha "Item" e clique no botão azul de três pontinhos, à direita dela. No menu que abre, clique em "Excluir".
   Print: [ofner-passo-06-excluir-item.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-06-excluir-item.png)
7. Confira que a lista ficou com 6 linhas e clique em "SALVAR", no canto de baixo do painel. A faixa amarela avisa que você está editando a loja em produção: a mudança vale na hora.
   Print: [ofner-passo-07-salvar.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-07-salvar.png)
8. Abra https://www.ofner.com.br/ no celular, desça até o rodapé e toque em "Institucional". A lista deve mostrar Quem somos, Politica e Segurança, Nossas Lojas, Trabalhe Conosco e Regulamento, sem a Politica de Cookies.
   Print: [ofner-passo-08-rodape-celular.png](/home/USUARIO/.claude/playwright/prints/ofner-passo-08-rodape-celular.png)
```

# Chamado de feedback negativo

Entrada: a Central Cabos relata que uma alteração no rodapé, feita pelo Site
Editor, aparece no celular e não no computador, e que o botão do WhatsApp
sumiu. Depois, diz que problemas aparecem depois de cada intervenção
(avaliações, código do vendedor no checkout, WhatsApp) e pede para a agência
avaliar se há testes depois de cada alteração e orientar como garantir mais
estabilidade. O peso da mensagem está nesse retorno; os problemas entram como
exemplo. A análise dos pontos concretos mostrou que o rodapé tem um texto para
o computador e outro para o celular no Site Editor, e que o botão do WhatsApp
já foi corrigido.

Trecho do relatório interno:

```markdown
## O que o chamado pede

Feedback negativo. A Central Cabos diz que, depois de intervenções na loja, outras funções param de funcionar, e pede para avaliarmos os testes feitos depois de cada alteração. Cita como exemplo o rodapé desatualizado no computador e o botão do WhatsApp.

## Humor do cliente

Irritado. A mensagem é educada, mas mostra frustração com problemas que se repetem: "a frequência dessas situações está chamando nossa atenção". Ficou entre neutro e irritado; pela regra, irritado. Tom: fala de feedback negativo, com saudação e assinatura.

## Próximos passos

1. Passar o chamado ao time de atendimento e suporte: "a frequência dessas situações está chamando nossa atenção" e "como garantir maior estabilidade nas próximas alterações?".
2. Explicar à Central Cabos que o rodapé tem duas versões no Site Editor e que só a do celular foi alterada; oferecer replicar o texto na versão do computador.
3. Confirmar com a Central Cabos que o botão do WhatsApp já aparece no computador e no celular.
```

Saída para o cliente, na primeira mensagem:

```markdown
Olá, equipe Central Cabos! Tudo bem?

Agradecemos por compartilhar esse retorno com a gente. Ele é importante para melhorarmos o nosso trabalho. Estamos direcionando o seu chamado para o time de atendimento e suporte, que vai avaliar os pontos que você trouxe e entrar em contato com você em breve.

Atendimento Agência e-Plus
```

# Chamado de feedback positivo

Entrada: a Kolplast escreve só para agradecer a nova página de categoria, que
ficou como ela esperava. Não há pedido nem problema. Loja, código e admin não
são conferidos.

Trecho do relatório interno:

```markdown
## O que o chamado pede

Feedback positivo. A Kolplast agradece a entrega da nova página de categoria.

## Humor do cliente

Bom humor: "ficou exatamente como a gente queria, obrigada a todos". Tom: fala de feedback positivo, com saudação e assinatura.

## O que está no ar e no código

Feedback, sem ponto concreto na loja para analisar.

## Cobrança

Não se aplica: feedback.

## Próximos passos

1. Passar o chamado ao time de atendimento e suporte: "ficou exatamente como a gente queria, obrigada a todos".
```

Saída para o cliente, na primeira mensagem:

```markdown
Olá, equipe Kolplast! Tudo bem?

Muito obrigado pelo retorno! Ficamos felizes em saber que a entrega atendeu ao que você esperava, e vamos compartilhar a sua mensagem com o time. Estamos direcionando o seu chamado para o time de atendimento e suporte, que vai dar seguimento com você.

Atendimento Agência e-Plus
```

# Pagamento recusado pelo provedor

Entrada: a Bivik diz que, desde ontem, os clientes não conseguem pagar com Pix
nem com cartão. O checkout chega ao pagamento normalmente. Em Pedidos >
Transações, todos os Pix desde 21/10 às 12:39 estão cancelados, e os eventos
mostram MaxiPagoV4 com `Authorization response received: [200 OK]` e
`Message: denied.`. O boleto, também pelo maxiPago, falha com "The provider
did not returned a valid Bank Issued Invoice URL". No cartão, uma tentativa
foi negada pelo banco do cartão (código 57), mas o pedido seguinte, um
Mastercard, foi autorizado e liquidado pela CieloEcommerce.

Trecho do relatório interno:

```markdown
## Humor do cliente

Irritado. A mensagem é cordial ("Pessoal bom dia", "porfavor", "Valeu"), mas mostra pressa e impacto na venda: "Estamos desde ontem com um problema" e "Preciso arrumar isso urgente". Ficou entre neutro e irritado; pela regra, irritado. Tom: abertura com empatia sobre as vendas paradas, equipe ao lado dele, o contato com o provedor explicado com cuidado e a mensagem pronta para facilitar.

## Causa mais provável

Configuração ou conteúdo, sem mudança de código, do lado do provedor de pagamento. O maxiPago recusa todos os Pix (`Message: denied.`) e não gera boleto desde 21/10, às 12:39. O cartão, pela CieloEcommerce, está funcionando: o pedido 529622 foi autorizado em 23/10 às 15:06. A recusa do 529602 (código 57) foi do banco daquele cartão.

## Cobrança

Suporte com terceiro: não consome do banco de horas. Orientação para contato com o terceiro (maxiPago), sem código, sem cotação e sem passo a passo no cadastro.

## Próximos passos

1. Enviar à Bivik o relatório abaixo, com os links das transações e a mensagem pronta para o maxiPago. Não pedir novos testes: o diagnóstico está fechado.
2. Contingência, só como informação: a regra "Pix - MercadoPago" está desligada. Quem decide ligá-la é a Bivik.
3. Quando a Bivik avisar que o maxiPago respondeu, conferir em Pedidos > Transações se os novos Pix estão sendo aprovados.
```

Trecho do relatório para o cliente:

````markdown
Sabemos o quanto é preocupante ver os clientes sem conseguir pagar, e já conferimos tudo para você ter um caminho claro.

Resumo do problema:

Testamos uma compra na sua loja e analisamos as transações de pagamento no painel da VTEX. A boa notícia é que a loja está funcionando e enviando os pagamentos normalmente, e o cartão também está sendo aprovado: um pedido com Mastercard passou hoje, às 15h06. A recusa de cartão que apareceu antes foi do banco do próprio comprador.

O que está travando é o Pix e o boleto. Desde 21/10, por volta das 12h40, a maxiPago, empresa que processa esses pagamentos na sua loja, está recusando todas as tentativas. Por envolver pagamentos e a integração com um provedor externo à plataforma, esse contato é feito diretamente por você com a maxiPago. Para facilitar, deixamos abaixo onde ver a recusa e uma mensagem pronta para enviar.

**Onde ver a recusa no painel da VTEX**

1. No menu da esquerda, abra Pedidos > Transações: https://bivik.myvtex.com/admin/pci-gateway/#/transactions
2. Clique na transação. Os links abaixo já abrem direto nela.
3. Desça até Eventos da transação. No Pix, aparece "MaxiPagoV4" com "Message: denied.".

Transações recusadas pela maxiPago:
- Pedido 529552, Pix, 21/10 às 12h39, a primeira recusa: https://bivik.myvtex.com/admin/pci-gateway/#/transactions/60E107A1E24A454B918C8BD0753912BE

**Mensagem para enviar à maxiPago**

Pedimos que você envie o texto abaixo pelo suporte da maxiPago, junto com um print da tela de Eventos da transação.

```text
Olá, equipe maxiPago.

Somos a Bivik Jeans (loja VTEX, conta "bivik"). Desde 21/10/2026, por volta das 12h40, todos os pagamentos com Pix da nossa loja estão sendo recusados por vocês, e os boletos não estão sendo gerados. O último Pix aprovado foi em 21/10/2026, às 09h56.

Exemplo:
- Pedido 529552, Pix, 21/10/2026 12h39, transação VTEX 60E107A1E24A454B918C8BD0753912BE, resposta "Message: denied."

Pedimos que verifiquem com urgência o que mudou na nossa conta e nos digam o que precisamos fazer para voltar a receber.

Obrigado,
[seu nome] – Bivik Jeans
```

Assim que a maxiPago responder, nos avise, e conferimos com você no painel se os pagamentos voltaram a ser aprovados.

Estamos direcionando essa demanda de suporte para a equipe de atendimento e suporte.
````
