# Skill: PageSpeed & Web Vitals Triage (Diagnóstico & Cotação On Going)

## Objetivo

Analisar chamados de lentidão e relatórios mensais de performance do Google PageSpeed Insights enviados por clientes via link direto de auditoria. A skill inspeciona as métricas do relatório fornecido, isola os gargalos reais de Laboratório versus dados de Campo (CrUX), diferencia problemas de código de impactos causados por scripts de terceiros/marketing, e gera uma cotação modular de horas (Home, PLP, PDP) com foco em **otimizações funcionais/invisíveis (sem redesign)** e termos formais de blindagem para o chamado no atendimento (Compass).

---

## Diretrizes de Negócio & Blindagem de Escopo

1. **Premissa de Impacto Visual (Sem Redesign):**
   - **Regra Padrão:** As otimizações propostas devem ser estritamente funcionais e invisíveis para o usuário final (preservar 100% do layout, proporções, animações e comportamento aprovados).
   - Não sugerir remoção de elementos funcionais que agradem o lojista (ex.: retirar carrossel, remover vídeo do hero, excluir vitrines).
   - A atuação técnica foca em: `width`/`height` explícitos, `loading="lazy"` condicional, posters otimizados para vídeos, reserva de espaço em containers (`aspect-ratio`/`min-height`), `fetchpriority` e prioridade de carregamento.
   - Caso uma melhoria drástica dependa obrigatoriamente de mudança visual ou estrutural de design (ex.: substituir vídeo pesado por banner estático), classificar como **Sugestão Opcional de Redesign/UX**, cotada separadamente.

2. **Blindagem Comercial da Plataforma (VTEX IO / FastStore / Deco.cx / Shopify Liquid / Nuvemshop):**
   - **Sem garantia de pontuação fixa:** Métricas de campo (CrUX) oscilam com o perfil de dispositivos dos visitantes, oscilações de operadoras 4G/5G e limitações nativas da infraestrutura/SSR da plataforma (ex.: TTFB no runtime VTEX ou nos servidores da Nuvemshop, CDN de imagem Deco/Shopify/Nuvemshop).
   - **Janela de Atualização do CrUX:** Alertar sempre que o relatório de campo do Google consolida os últimos 28 dias. O impacto em produção só é mensurável após ~27 a 28 dias da publicação.
   - **Ciclos Futuros:** Medições futuras após o ciclo de 28 dias demandam nova análise técnica e nova cotação.

3. **Integrações de Terceiros e Painel de Conteúdo:**
   - Scripts de marketing/rastreamento (GTM, Meta, TikTok, Google Ads, Edrone, chats ao vivo, widgets) ficam fora do escopo de desenvolvimento do tema, cabendo revisão ou limpeza pelo lojista no admin das respectivas ferramentas.
   - Se a proposta criar ou ampliar propriedades de schema/configurações do tema (ex.: poster, dimensões), alertar recadastro pontual no painel da stack analisada, reforçando que IDs de coleções e configurações de prateleira permanecem intactos. Nome do painel: VTEX IO → Site Editor; FastStore → Headless CMS; Deco.cx → Admin Deco; Shopify → Editor de Temas; Nuvemshop → Painel / Personalizador do Tema. Se a proposta for só ajuste direto de código/CSS, não mencionar recadastro.

4. **Lojas em Faixa Verde / Scores de Excelência (90+):**
   - Se a página analisada (ou um dos dispositivos, ex.: Desktop) já apresentar pontuação de Laboratório igual ou superior a 90 e métricas de campo (CrUX) aprovadas no verde, a postura técnica padrão é Cotação Zero (0h) para o respectivo escopo.
   - Justificativa formal: intervir em componentes estabilizados nessa faixa gera retorno decrescente (diminishing returns), esbarra na margem de variação natural do Lighthouse (±3 a 5 pontos) e introduz risco desnecessário de regressão sem ganho prático de conversão ou SEO.
   - Nesses casos, o parecer ao cliente deve parabenizar a performance da loja e formalizar que não há necessidade de atuação em código.

5. **Acessibilidade e SEO fora deste chamado:**
   - Apontamentos de Acessibilidade (a11y) ou SEO presentes no relatório do Google ficam fora do escopo deste chamado de performance/Core Web Vitals. Caso o lojista deseje auditar ou corrigir contrastes, hierarquia semântica ou meta tags, deve ser orientado a abrir uma demanda específica de SEO Técnico ou Acessibilidade.

---

## Modo de Execução & Entrada

1. **Entrada de Dados:**
   - Link direto do relatório PageSpeed (Mobile e Desktop) enviado pelo cliente.
   - O agente analisa o snapshot aberto (inspecionando o DOM/CDP ou lendo os dados estruturados de Lab e CrUX).
   - Não depende de variáveis de ambiente nem de chamadas de API externas sujeitas a rate limit.

2. **Inspeção de Código (Opcional & Pontual):**
   - Inspecionar blocos no repositório (workspace local; não usar GitHub MCP se a pasta da loja já estiver clonada) para checar como as imagens, sliders e vitrines foram declarados no tema.
   - Repositórios Deco.cx ficam na organização `deco-sites` (`github.com/deco-sites/{loja}`). As demais plataformas (VTEX IO, FastStore, Shopify, Nuvemshop) e apps customizados ficam em `agencia-e-plus` (`github.com/agencia-e-plus/{loja}`).
   - Identificar a plataforma e ler **somente** a referência correspondente antes de cotar e antes de escrever o handoff:
     - VTEX IO: [references/vtex-io.md](references/vtex-io.md)
     - Deco.cx: [references/deco.md](references/deco.md)
     - Shopify Liquid: [references/shopify.md](references/shopify.md)
     - FastStore: [references/faststore.md](references/faststore.md)
     - Nuvemshop (Tiendanube): [references/nuvemshop.md](references/nuvemshop.md)
   - Escopo restrito a essas cinco stacks. Nomear no handoff os arquivos e as props da seção "Handoff" da referência lida. Itens da seção "Não cotar" ficam fora das horas de tema.

3. **Apps VTEX IO (portão estreito, nunca o `manifest` inteiro):**
   - Só VTEX IO. FastStore, Deco, Shopify e Nuvemshop não herdam este passo: o equivalente já está no repositório da loja.
   - A triagem começa no tema. Abrir um app **somente** se o bloco da região (LCP, CLS ou script bloqueante) não puder ser tratado no JSONC/CSS do tema — a prop não existe no schema, o React do app ignora a prop, ou o seletor do PSI aponta para um fork nosso.
   - Do relatório, traduzir o prefixo da classe (`{vendor}-{app}-{major}-x`) ou o bloco `vendor.app:interface` para `vendor.app`. Não abrir dependência que não pintou o achado.
   - Teto: 2 ou 3 apps por chamado, os da região afetada.
   - Destino por vendor:
     - `vtex.*`: fica no tema. Se a prop nativa não existir, registrar na seção “Não cotar” — não há repositório nosso para alterar.
     - Vendor da loja ou `agenciaeplus`: abrir `agencia-e-plus/{app}` (workspace local primeiro; senão GitHub MCP). Branch da loja (`lojasupersaudavel`); se não houver, `master` e avisar que o release pode atingir outras lojas.
     - Pixel instalado no Admin (GTM, Meta, TikTok): continua fora.
   - No app, ler só o que decide o achado: `contentSchemas` / `interfaces.json` e o componente React que pinta `img`, `video` ou `script`. Se o schema já aceita a prop e o React a aplica, a hora permanece no tema e no Site Editor. Se a prop for ignorada ou inexistente, a hora muda para release do app (deploy separado do tema).
   - O parecer ao cliente não lista repositório de app. O destino (tema vs app, branch) fica só no handoff interno.

---

## Tabela de Referência de Horas (On Going e-Plus)

| Bloco / Componente                                      | Otimizações Funcionais Padrão                                                                                                                | Faixa de Horas    |
| ------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| **Banner Hero (Vídeo)**                                 | Poster otimizado (desktop/mobile), preload de metadados, poster como LCP                                                                     | 4h a 6h           |
| **Banner Hero (Imagem/Slider)**                         | `fetchpriority="high"`, dimensões explícitas, `sizes`/`srcset`, remoção de lazy                                                              | 2h a 4h           |
| **Bloco Estático / Diferenciais / Banners Secundários** | Dimensões (`width`/`height`), lazy load nativo, preservando visual                                                                           | 1h a 2h por bloco |
| **Grid / Mosaicos de Banners**                          | Dimensões desktop/mobile, lazy load e aspect-ratio                                                                                           | 2h por grid       |
| **Prateleiras / Vitrines de Produtos**                  | Card unificado: dimensões na imagem (`~280-300px`), lazy load abaixo da dobra, reserva de espaço contra CLS em carrosséis (home, busca, PDP) | 4h a 6h           |
| **Modais com CLS (CEP, Cookies, Newsletter)**           | Estabilizar renderização tardia para evitar saltos visuais na sessão                                                                         | 3h a 5h           |
| **Galeria de Produto (PDP)**                            | `fetchpriority` e eager na 1ª mídia; lazy nas miniaturas e demais imagens                                                                    | 3h                |
| **Lista de Produtos (PLP / Busca)**                     | Otimização dos cards de busca e lazy loading progressivo                                                                                     | 2h                |
| **Ícones Flutuantes (WhatsApp, etc.)**                  | Dimensões explícitas para evitar deslocamento tardio de layout                                                                               | 1h                |
| **App fork VTEX IO (só se o tema não resolver)**        | Expor/honrar prop no schema + React (`fetchpriority`, `poster`, `async`/`defer`, caixa da imagem) na branch da loja                          | 2h a 4h por app   |

---

## Formato do Retorno ao Desenvolvedor e ao Atendimento

A resposta da skill deve ser formatada segundo o modelo abaixo.

Na seção **Importante** do parecer ao cliente, o 4º bullet (recadastro no painel de conteúdo) só entra se a proposta criar ou ampliar propriedades de schema/configurações do tema (ex.: poster, dimensões). Ajuste direto de código ou CSS não inclui esse item. Quando incluído, `{painel_conteudo}` usa o nome da stack: **VTEX IO** → Site Editor; **FastStore** → Headless CMS; **Deco.cx** → Admin Deco; **Shopify** → Editor de Temas; **Nuvemshop** → Painel / Personalizador do Tema.

```text
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TRIAGEM TÉCNICA INTERNA (PAGESPEED)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Loja: {url} | Plataforma: {plataforma}
• Links Analisados:
  - Mobile: {link_mobile}
  - Desktop: {link_desktop}
• Resumo das Métricas:
  - Lab (Mobile/Desktop): Scores {score_m}/{score_d} | LCP {lcp_lab} | TBT {tbt_lab} | CLS {cls_lab}
  - Campo (CrUX - 28 dias): LCP {lcp_campo} | CLS {cls_campo} | INP {inp_campo} ({status_geral})
• Divergência Lab vs. Campo: [Explicar onde o lab e o campo divergem, ex: overlays e scripts de terceiros]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PARECER FORMAL AO CLIENTE (ATENDIMENTO)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Esta demanda é referente à análise de desempenho, não tendo atuação neste momento em código. Segue o resultado técnico. Caso aprovado, a demanda retorna para a fila e alocação de um desenvolvedor.

Importante:
• Não é possível garantir ganhos fixos nas métricas do {plataforma}. Elas dependem de fatores externos (perfil dos usuários, rede, dispositivo, navegação) e de limitações da própria plataforma (arquitetura, SSR, scripts de terceiros).
• Após a publicação em produção, o CrUX (Chrome User Experience Report) leva cerca de 28 dias para consolidar as métricas reais. Se, após esse prazo, o resultado não for o esperado, deverá ser aberta uma nova análise, com nova cotação.
• A abordagem foca exclusivamente em otimizações funcionais nos componentes já utilizados na loja, preservando 100% o layout e identidade visual atuais (sem redesign).
• Se o schema de algum bloco for ampliado (ex.: inclusão de poster ou dimensões), pode haver recadastro pontual no {painel_conteudo} pelo lojista; isso já está previsto nas horas. IDs de coleção e prateleiras não se perdem.
• Scripts de terceiros (GTM, Meta, TikTok, ferramentas de chat, CRM e popups) ficam fora desta demanda, podendo ser revisados pelo lojista no painel de cada ferramenta.

1. Home
1.1 [Nome do Bloco / Banner Principal]:
    Otimizações funcionais: [ex: poster para vídeo, fetchpriority, dimensões]
    Tempo estimado: {X}h

1.2 [Diferenciais / Banners Secundários]:
    Otimizações funcionais: [dimensões e lazy load, mantendo o visual atual]
    Tempo estimado: {X}h

1.3 [Prateleiras / Vitrines de Produtos]:
    Otimizações funcionais: [ajuste no card unificado, dimensões corretas, lazy load e reserva de espaço]
    Tempo estimado: {X}h

[... Demais blocos mapeados. Se a correção for no app fork, manter o nome do bloco da loja; não citar repositório. Somar as horas do app neste item ou no total. ...]

2. Departamento / Busca (PLP)
2.1 Lista de produtos:
    Otimizações funcionais: [aplicar otimizações do card de produto]
    Tempo estimado: {X}h

3. Página de Produto (PDP)
3.1 Galeria de imagens:
    Otimizações funcionais: [prioridade na 1ª imagem, lazy nas demais, dimensões]
    Tempo estimado: {X}h

─────────────────────────────────
Tempo estimado total de desenvolvimento: {Total_Horas}h
Classificação: Ajuste técnico (Sem redesign).

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HANDOFF PARA O AGENTE DE CODING (COMPASS / DAYTONA)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Plataforma detectada: {VTEX IO | FastStore | Deco.cx | Shopify Liquid | Nuvemshop}
• Arquivo de referência utilizado: {references/vtex-io.md | references/faststore.md | references/deco.md | references/shopify.md | references/nuvemshop.md}
• Repositório / Workspace alvo: {pasta local ou deco-sites/{repo} (Deco.cx) | agencia-e-plus/{repo} (demais stacks)}
• Apps inspecionados (VTEX IO): {nenhum | vendor.app @ branch — motivo: prop ausente / React ignora / seletor do PSI}
• Destino da correção: {tema | app fork | limitação vtex.* / não cotar}

• Componentes / Arquivos que devem ser alterados:
  - {caminho relativo no tema ou no app} — {bloco, section, snippet ou prop de schema}

• Ações técnicas específicas a executar (sem redesign):
  - {ação funcional: fetchpriority, width/height, poster, lazy condicional, aspect-ratio, preload}
  - Preservar layout, proporções, animações, autoplay, IDs de coleção e comportamento aprovados.

• O que NÃO alterar / limites de escopo:
  - {itens da seção "Não cotar" da referência: TTFB/SSR da plataforma, CDN de imagem, pixels e GTM do admin, checkout}
  - Não remover carrossel, vídeo, vitrine ou popup.
  - Não aplicar sugestão de redesign nesta execução.
```
