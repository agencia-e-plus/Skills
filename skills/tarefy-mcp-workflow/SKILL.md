---
name: tarefy-mcp-workflow
description: Orienta o uso do MCP Tarefy e do MCP Figma: entender o chamado pela descrição inicial e anexos, extrair observações nos comentários sobre a proposta inicial, localizar o comentário de cotação (escopo técnico e link Figma) e usar o MCP Figma quando houver link. Usar quando mencionar Tarefy, chamado, task_id ou desenvolver a partir de um chamado.
---

# Workflow Tarefy MCP

## Objetivo

Entender o chamado em três camadas, nesta ordem: (1) descrição inicial e anexos da abertura, (2) observações nos comentários sobre a proposta inicial, (3) comentário de cotação com o que fazer de forma técnica e o link Figma para o layout. Só depois desenvolver.

## Passo 1 — Obter o chamado completo

Usar **sempre** `mcp_tarefy_get_task_complete(task_id)`:

- Retorna: dados da tarefa (incluindo descrição inicial), comentários e anexos.
- Os anexos podem estar associados à tarefa; conferir na resposta se há anexos da abertura/descrição inicial e considerá-los no entendimento do escopo.

## Passo 2 — Entender o chamado pela descrição inicial (e anexos)

**O mais importante:** a base do entendimento é a **descrição inicial** do chamado (texto da abertura).

- Ler com atenção o texto da descrição inicial da tarefa.
- **Verificar também os anexos da descrição inicial:** imagens, documentos ou arquivos anexados na abertura fazem parte do escopo. Não ignorar anexos; usá-los para complementar o que foi pedido.
- Com isso fica claro o pedido original e o contexto do chamado.

## Passo 3 — Comentários: observações sobre a proposta inicial

Nos **comentários** do chamado:

- Identificar se houve **observações adicionais sobre a proposta inicial**: ajustes, esclarecimentos, mudanças ou complementos que alteram ou detalham o que foi pedido na abertura.
- Essas observações podem refinar escopo, prioridades ou critérios de aceite. Usar como segunda camada de contexto antes de implementar.

## Passo 4 — Comentário de cotação: escopo técnico e link Figma

Procurar pelo **comentário de cotação** (o comentário em que a cotação/ orçamento é formalizada ou detalhada). Esse comentário costuma conter:

- **Descrição técnica do que tem que ser feito:** o que implementar de forma mais técnica (entregas, requisitos, escopo de desenvolvimento). É a referência principal para a implementação.
- **Link do Figma (se existir):** para ver em **layout** o que foi pedido. O design no Figma mostra visualmente o resultado esperado.

Ações:

- Localizar esse comentário de cotação no conjunto de comentários retornados.
- Extrair do texto: (a) a descrição técnica do que fazer, (b) a URL do Figma, se houver.
- Se houver URL Figma (`https://figma.com/design/...` ou `https://www.figma.com/design/...`):
  - **fileKey:** trecho após `/design/` (ex.: `figma.com/design/AbCdEfGh/Nome?node-id=1-2` → fileKey `AbCdEfGh`).
  - **nodeId:** query param `node-id` com `-` trocado por `:` (ex.: `1-2` → `1:2`).
  - Chamar o **MCP Figma** com esses dados (ex.: `mcp_Figma_get_design_context`) para obter o contexto de layout e usar na implementação.

## Passo 5 — Usar o MCP Figma quando houver link

Se no comentário de cotação (ou em qualquer parte do chamado) existir link Figma:

- Extrair `fileKey` e `nodeId` como acima.
- Chamar **antes de codar**: `mcp_Figma_get_design_context(nodeId, fileKey)` (ou `get_screenshot`/`get_metadata` conforme necessidade).
- Usar o retorno (código de referência, screenshot, assets) para alinhar layout e detalhes visuais ao que foi pedido. Adaptar ao stack do projeto; o output do Figma é referência.

## Passo 6 — Desenvolver conforme o chamado

Implementar com base em:

1. **Descrição inicial** (e anexos da abertura) — entendimento do pedido.
2. **Observações nos comentários** — ajustes à proposta inicial.
3. **Comentário de cotação** — descrição técnica do que fazer.
4. **Figma (se houver link)** — layout e detalhes visuais via MCP Figma.

## Resumo da ordem de leitura

| Ordem | Onde | O que extrair |
|-------|------|----------------|
| 1 | Descrição inicial + anexos da abertura | Entendimento do chamado e do pedido original |
| 2 | Comentários | Observações sobre a proposta inicial |
| 3 | Comentário de cotação | Descrição técnica do que fazer + link Figma (se existir) |
| 4 | MCP Figma (se há link) | Layout para ver o que foi pedido |

## Checklist

- [ ] Chamado obtido com `get_task_complete(task_id)`.
- [ ] Descrição inicial lida; anexos da descrição inicial verificados e considerados.
- [ ] Comentários analisados para observações sobre a proposta inicial.
- [ ] Comentário de cotação localizado; descrição técnica e link Figma extraídos.
- [ ] Se há link Figma: fileKey e nodeId extraídos; MCP Figma chamado antes de implementar.
- [ ] Desenvolvimento alinhado à descrição inicial, observações, cotação técnica e (se aplicável) layout do Figma.

## Ferramentas

| Ferramenta | Uso |
|------------|-----|
| `mcp_tarefy_get_task_complete` | Chamado completo (dados + comentários + anexos) — **sempre usar primeiro**. |
| `mcp_Figma_get_design_context` | Contexto de design a partir do link Figma (quando existir no chamado). |

Sempre iniciar com `get_task_complete(task_id)`. Não desenvolver sem ter considerado descrição inicial, anexos da abertura, observações nos comentários e o comentário de cotação (incluindo Figma quando houver link).
