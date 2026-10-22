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

Para podermos seguir com a análise, responda às perguntas abaixo:

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

Não foi possível simular o erro navegando pela loja. Você consegue fornecer mais dados, como prints da tela ou um vídeo da navegação?

Atendimento Agência e-Plus
```

# Evolução com layout, sem referência visual

Entrada: a Miess pede, em texto, o número da nota fiscal, a chave de acesso e
o PDF no e-mail de faturamento e em Meus Pedidos. Não há print, Figma,
Photoshop nem link de referência.

Saída, na primeira mensagem para o cliente:

```markdown
Olá, equipe Miess! Tudo bem?

Para podermos seguir com a análise, responda às perguntas abaixo:

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

Para podermos seguir com a análise, responda às perguntas abaixo:

1. Qual é o telefone novo que entra no lugar de +55 11 99592-2595, na mensagem de WhatsApp da tela "Solicitação enviada com sucesso!"? Esse número vale para o português e para o inglês.

Atendimento Agência e-Plus
```

Relatório para o cliente, depois da resposta com o número novo. Não é mais a
primeira mensagem, então não tem saudação:

```markdown
Resumo da evolução:

O telefone da mensagem de WhatsApp da tela "Solicitação enviada com sucesso!" vai mudar de +55 11 99592-2595 para [número novo], em português e em inglês. Essa alteração é no código dessa tela, não no cadastro da loja, e a equipe de desenvolvimento faz a troca.

Estamos direcionando essa demanda de evolução para a equipe de desenvolvimento.

Sua solicitação foi encaminhada para cotação. Em breve você receberá o valor e mais detalhes.

É isso mesmo que você precisava? Se quiser corrigir ou adicionar mais alguma informação, pode fazer isso agora, antes de seguirmos com o encaminhamento do chamado para a próxima etapa.

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

Para podermos seguir com a análise, responda às perguntas abaixo:

1. Como você quer seguir com a vitrine "Encontre o presente ideal"? Você pode repor o estoque desses 12 produtos, trocar os produtos dessa lista por outros com estoque ou usar outra lista de produtos na vitrine. Se for trocar, diga quais produtos ou qual lista entram.

Atendimento Agência e-Plus
```
