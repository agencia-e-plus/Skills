---
name: setup-playwright
description: >-
  Instala e configura no Claude Code os dois servidores Playwright MCP das
  skills: playwright (loja no ar: Chromium headless, sessão isolada) e
  playwright-admin (admin VTEX: janela visível, perfil salvo). Define também a
  pasta dos prints. Use quando o namespace playwright ou playwright-admin não
  existir, o navegador não abrir, a mensagem citar /opt/google/chrome/chrome,
  faltarem bibliotecas do sistema, ou outra skill precisar do navegador e ele
  não estiver pronto. Não analisa chamado nem loja.
---

# Configurar Playwright

Deixa os servidores MCP do Playwright abrindo páginas com o Chromium
empacotado pelo Playwright. Não analisa chamado, não estima hora e não altera
repositório. Altera só a configuração MCP do Claude Code (pelo comando
`claude mcp`), os arquivos de `~/.claude/playwright/` e o cache do navegador.

Nos arquivos JSON e no `claude mcp add-json`, `$HOME` é só um marcador:
escreva o caminho absoluto da pasta pessoal (o valor de `echo $HOME`), porque
nem o JSON nem o `claude mcp` expandem `~` ou variáveis.

## Onde fica cada coisa

| O quê | Onde |
|---|---|
| Configuração da loja no ar | `~/.claude/playwright/playwright-vitrine.json` |
| Configuração do admin | `~/.claude/playwright/playwright-admin.json` |
| Perfil do admin (sessões de login) | `~/.claude/playwright/vtex-admin/`, apagado quando completa 7 dias pelo script da `vtex-admin-login` |
| Prints | `~/.claude/playwright/prints/`, com os prints de mais de 7 dias apagados pelo mesmo script |
| Chromium | `~/.cache/ms-playwright` (`PLAYWRIGHT_BROWSERS_PATH`), o cache padrão do Playwright |
| Servidores MCP | escopo de usuário do Claude Code, só pelo comando `claude mcp` |

Não edite o `~/.claude.json` à mão: o Claude Code reescreve esse arquivo. Não
apague perfis, prints nem o cache de navegadores à mão; a única limpeza é a
semanal (perfil do admin e prints antigos), feita pelo script da
`vtex-admin-login`.

## Servidores

| Servidor | Uso | JSON do servidor |
|---|---|---|
| `playwright` | Loja no ar | `{"type":"stdio","command":"npx","args":["-y","@playwright/mcp@0.0.83","--config","$HOME/.claude/playwright/playwright-vitrine.json","--headless"],"env":{"PLAYWRIGHT_BROWSERS_PATH":"$HOME/.cache/ms-playwright"}}` |
| `playwright-admin` | Admin VTEX, pela `vtex-admin-login` | `{"type":"stdio","command":"npx","args":["-y","@playwright/mcp@0.0.83","--config","$HOME/.claude/playwright/playwright-admin.json"],"env":{"PLAYWRIGHT_BROWSERS_PATH":"$HOME/.cache/ms-playwright"}}` |

Um servidor não substitui o outro: a loja no ar nunca abre no perfil do admin,
e o admin nunca abre headless nem isolado. Não use `--browser chromium` nem
`--user-data-dir` na linha de comando: o Chromium empacotado e o perfil vêm
dos arquivos de configuração.

`playwright-vitrine.json`:

```json
{
  "browser": {
    "browserName": "chromium",
    "isolated": true
  },
  "outputDir": "$HOME/.claude/playwright/prints"
}
```

`playwright-admin.json`:

```json
{
  "browser": {
    "browserName": "chromium",
    "userDataDir": "$HOME/.claude/playwright/vtex-admin"
  },
  "outputDir": "$HOME/.claude/playwright/prints"
}
```

## Prints

Todo print fica em `~/.claude/playwright/prints/`. No
`browser_take_screenshot`, não informe `filename` (o arquivo vai para essa
pasta, com nome automático) ou informe um caminho absoluto dentro dela, como
`$HOME/.claude/playwright/prints/kolplast-revendedor.png` (com `$HOME`
expandido). Nome relativo cai na pasta do projeto aberto: não use. Nunca salve
print em pasta de skill.

## Entrada

URL para abrir no fim e o servidor a conferir: `playwright` (padrão) ou
`playwright-admin` (quando a `vtex-admin-login` chamar). Sem URL, use
`https://example.com`.

## Estados

- `pronto`: o servidor abriu a URL e a página carregou.
- `aguardando_instalacao`: falta Node.js, a instalação de dependências precisa
  de ação da pessoa, ou um servidor foi criado ou alterado e o Claude Code
  ainda não o carregou. Não há janela para login nesse estado.
- `falhou`: o navegador não iniciou, a navegação falhou ou a página mostrou
  desafio/erro antes de carregar.

`aguardando_instalacao` não é `aguardando_login`: só a `vtex-admin-login`
devolve `aguardando_login`.

## Quando rodar

O navegador não está pronto quando o namespace do servidor não existe, a
navegação não abre o browser, a mensagem cita `/opt/google/chrome/chrome`,
falta biblioteca (`libnss3`, `libnspr4` ou `not found` no `ldd`), ou o
servidor está diferente da tabela.

Se esta conversa já tiver `pronto` para o mesmo servidor e o namespace
continuar no ar, não instale de novo: abra a URL e devolva `pronto`.

## Passos

1. Confira `node` e `npx` no `PATH`, com Node.js 20 ou mais novo. Se faltar, a
   situação é `aguardando_instalacao`: peça Node.js 20+ e pare.
2. Crie as pastas `~/.claude/playwright/prints/` e
   `~/.claude/playwright/vtex-admin/` (esta com permissão 700) e os dois
   arquivos de configuração, se faltarem ou estiverem diferentes do conteúdo
   acima.
3. Confira os servidores com `claude mcp get playwright` e
   `claude mcp get playwright-admin`. Servidor ausente ou diferente da tabela:
   remova só ele (`claude mcp remove NOME -s user`, se existir) e crie de novo
   com `claude mcp add-json NOME 'JSON_DA_TABELA' -s user`. Não mexa nos
   outros servidores.
4. Baixe o Chromium para o cache. Se o download falhar dentro do sandbox, rode
   fora dele:

   ```bash
   PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/ms-playwright" npx -y @playwright/mcp@0.0.83 install-browser chromium
   ```

5. Instale as bibliotecas do sistema com o `playwright` da mesma versão do
   MCP. Ache `node_modules/playwright/cli.js` no cache do `npx` de
   `@playwright/mcp@0.0.83` e rode:

   ```bash
   PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/ms-playwright" node CAMINHO/cli.js install-deps chromium
   ```

   Se o `sudo` pedir senha, a situação é `aguardando_instalacao`: entregue
   esse comando para a pessoa rodar no terminal dela e pare.
6. Se o passo 3 criou ou alterou um servidor, o Claude Code só o carrega
   depois de reconectar. A situação é `aguardando_instalacao`: peça para a
   pessoa reconectar o servidor pelo `/mcp` ou abrir uma nova conversa, e
   pare.
7. Abra a URL com `browser_navigate` do servidor da entrada e confirme com
   `browser_snapshot`. `pronto` exige que o navegador tenha iniciado, a URL
   tenha respondido e o documento não seja tela de desafio ou erro. Não use
   somente o título da página como critério. Sem navegador, timeout, erro de
   navegação ou desafio: `falhou`, com a URL e a evidência.

## Retorno

`aguardando_instalacao`: a resposta é só este retorno, sem HTML. `pronto`
devolve a navegação para quem chamou. `falhou` autoriza ler o HTML somente se
a página tiver respondido; se não tiver respondido, a skill que chamou usa o
retorno de falha de navegação.

```markdown
## Playwright
[pronto, aguardando_instalacao ou falhou. Servidor: playwright ou playwright-admin.]

## URL
[URL aberta, ou a URL que não abriu.]

## Evidência
[Estado do documento; o comando que a pessoa precisa rodar ou a reconexão pedida; ou o erro.]
```
