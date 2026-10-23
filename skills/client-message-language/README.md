# client-message-language

Define como escrever qualquer mensagem que vai direto para o cliente da loja:
perguntas, relatório para o cliente, respostas e avisos. O texto é
profissional, humano e claro para quem não é técnico.

O relatório interno da Agência e-Plus continua técnico e **não** usa esta
skill.

## Quando usar

Sempre que for escrever um texto que o cliente da loja vai ler. A
`request-pre-analysis` usa esta skill em toda mensagem para o cliente.

## Exemplos

```text
/client-message-language
Escreve uma resposta para a Kolplast dizendo que o banner já foi trocado
Reescreve esse texto para mandar ao cliente
```

## Regras principais

**Saudação** (só na primeira mensagem do chamado):

- Com o nome da pessoa: "Bom dia/Boa tarde/Boa noite, [nome]! Tudo bem?" (em todos os tons),
  pelo horário de Brasília (5h–11h59, 12h–17h59, 18h–4h59).
- Sem o nome: "Olá, equipe [nome da loja]! Tudo bem?".

**Assinatura** (em toda mensagem, na última linha): `Atendimento Agência
e-Plus`.

**Tom**

- Segunda pessoa ("você", "sua loja"), como um retorno de alguém da agência.
- Frases curtas, uma ideia por frase.
- Fora: "foi identificado", "procederemos", "ressaltamos", "conforme
  solicitado", "gentileza", "estamos à disposição para quaisquer
  esclarecimentos" e outras expressões de texto automático.

**Humor do cliente**

Antes de escrever, ler o humor da pessoa e ajustar a mensagem:

| Nível | Como responder |
|---|---|
| Bom humor | Tom padrão, um pouco mais leve, sem piada nem emoji. |
| Neutro | Tom padrão. |
| Irritado | Abrir com empatia, reconhecendo o incômodo em uma frase concreta; mostrar que a equipe já agiu e está junto; ir ao ponto com cordialidade, sem frase seca. |
| Muito irritado (xinga, ameaça cancelar, processar, Procon/Reclame Aqui, tudo em maiúsculas, várias cobranças sem resposta) | Só uma das três falas de encaminhamento ao time de atendimento e suporte, sem resumo nem perguntas. Vence qualquer outro retorno: feedback, suporte com terceiro e falha na plataforma VTEX. |

Na fala de encaminhamento, escolher a variação pelo que a pessoa disse: geral (1), impacto na venda ou operação (2) ou cobrança sem resposta (3). Na dúvida, tratar como irritado. Nunca comentar o humor da pessoa.

**Cordialidade**

Direto não é seco, ainda mais com cliente irritado:

- falar como quem está do lado da pessoa ("Conferimos", "Deixamos pronto");
- não soar como defesa nem como quem passa a culpa adiante ("o contrato é
  seu", "precisa partir de você");
- quando a pessoa precisa agir, explicar o motivo real com cuidado e já
  oferecer ajuda (por exemplo, a mensagem pronta para o provedor);
- no texto corrido, pedir em vez de mandar; o imperativo fica para listas de
  passos;
- fechar dizendo o que a equipe faz em seguida.

**Chamado de feedback**

Quando o chamado só traz um retorno sobre o serviço, o projeto ou a loja, a
mensagem é só uma fala fixa de encaminhamento ao time de atendimento e
suporte: uma para feedback negativo e outra para positivo. Elogio e
reclamação juntos usam a do negativo; muito irritado tem prioridade.

**Termos**

- Palavras do dia a dia. Termo técnico só com explicação na mesma frase.
- Não usar: arquivo, branch, commit, pull request, componente, cache, SSR, API.
- Exceção: texto copiado de uma tela do admin, entre aspas, e mensagem pronta
  que a pessoa vai repassar a um terceiro (por exemplo, ao provedor de
  pagamento) podem trazer termos técnicos.
- Quando a troca é no código e não no cadastro, dizer isso de forma simples,
  sem citar arquivo nem repositório.
- Não falar de banco de horas e não prometer correção que a análise não
  confirmou.
- Nunca prometer entrega até uma data, para um evento ou período, ou em X
  dias. Se a pessoa perguntar se dá tempo, não responder sim nem não: a data
  fica anotada para a equipe avaliar na cotação.

**Perguntas**

Sempre abrem com a frase fixa "Para podermos seguir com a análise, pedimos que
você responda às perguntas abaixo:" e vêm numeradas, mesmo quando é uma só.

## Exemplo

Evite:

```text
Identificamos que a categoria encontra-se cadastrada como departamento raiz, fora da árvore de Gourmet.
```

Prefira:

```text
Hoje essa categoria está como uma seção própria, ao lado de Gourmet, e não dentro dele.
```

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Saudação, assinatura, humor do cliente, tom, cordialidade, termos, perguntas e exemplo |
