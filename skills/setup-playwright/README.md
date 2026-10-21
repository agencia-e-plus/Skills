# setup-playwright

Instala e configura no Claude Code os dois servidores Playwright MCP que as
skills usam, e define a pasta onde ficam os prints.

| Servidor | Para quê | Como abre |
|---|---|---|
| `playwright` | Loja no ar | Chromium headless, sessão isolada |
| `playwright-admin` | Admin VTEX (via `vtex-admin-login`) | Janela visível, perfil salvo (mantém o login) |

Um servidor não substitui o outro: a loja nunca abre no perfil do admin e o
admin nunca abre headless.

## Quando usar

- O namespace `playwright` ou `playwright-admin` não existe.
- O navegador não abre, ou a mensagem cita `/opt/google/chrome/chrome`.
- Faltam bibliotecas do sistema (`libnss3`, `libnspr4`, `not found` no `ldd`).
- Outra skill precisa do navegador e ele não está pronto.

Ela não analisa chamado nem loja.

## Exemplos

```text
/setup-playwright
O Playwright não está abrindo, configura pra mim
Configura o playwright-admin e abre https://kolplast.myvtex.com/admin
```

## Entrada

- URL para abrir no fim (padrão: `https://example.com`).
- Servidor a conferir: `playwright` (padrão) ou `playwright-admin`.

## O que a skill faz

1. Confere Node.js 20+ e `npx`.
2. Cria `~/.claude/playwright/prints/`, `~/.claude/playwright/vtex-admin/`
   (permissão 700) e os dois arquivos de configuração.
3. Cria ou recria só o servidor que estiver ausente ou diferente, com
   `claude mcp add-json ... -s user` (`@playwright/mcp@0.0.83`).
4. Baixa o Chromium para `~/.cache/ms-playwright`.
5. Instala as dependências do sistema (`install-deps chromium`). Se o `sudo`
   pedir senha, entrega o comando para você rodar no terminal.
6. Se criou ou alterou um servidor, pede para reconectar pelo `/mcp` ou abrir
   uma conversa nova.
7. Abre a URL e confirma pelo snapshot que a página carregou.

## Onde fica cada coisa

| O quê | Onde |
|---|---|
| Configuração da loja no ar | `~/.claude/playwright/playwright-vitrine.json` |
| Configuração do admin | `~/.claude/playwright/playwright-admin.json` |
| Perfil do admin (logins) | `~/.claude/playwright/vtex-admin/` |
| Prints | `~/.claude/playwright/prints/` |
| Chromium | `~/.cache/ms-playwright` |
| Servidores MCP | escopo de usuário do Claude Code (`claude mcp`) |

O perfil do admin e os prints com mais de 7 dias são apagados pelo script de
limpeza da `vtex-admin-login`. Não apague à mão e não edite o
`~/.claude.json` diretamente.

## Estados de retorno

| Estado | Significado |
|---|---|
| `pronto` | O servidor abriu a URL e a página carregou |
| `aguardando_instalacao` | Falta Node.js, falta você rodar um comando com `sudo`, ou falta reconectar o servidor |
| `falhou` | O navegador não iniciou, a navegação falhou ou apareceu desafio/erro |

Formato:

```markdown
## Playwright
## URL
## Evidência
```

## Usada por

`request-pre-analysis`, `vtex-admin-login`, `identify-store-technology`.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Passos de instalação, JSON dos servidores e estados |
