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

- Com o nome da pessoa: "Bom dia/Boa tarde/Boa noite, [nome]! Tudo bem?",
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

**Termos**

- Palavras do dia a dia. Termo técnico só com explicação na mesma frase.
- Não usar: arquivo, branch, commit, pull request, componente, cache, SSR, API.
- Quando a troca é no código e não no cadastro, dizer isso de forma simples,
  sem citar arquivo nem repositório.
- Não falar de banco de horas e não prometer correção que a análise não
  confirmou.

**Perguntas**

Sempre abrem com a frase fixa "Para podermos seguir com a análise, responda às
perguntas abaixo:" e vêm numeradas, mesmo quando é uma só.

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
| `SKILL.md` | Saudação, assinatura, tom, termos, perguntas e exemplo |
