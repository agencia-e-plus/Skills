# vtex-admin-login

Abre o admin VTEX da loja (`https://{vendor}.myvtex.com/admin`) numa janela
visível do Chromium, espera você fazer login e confere se a conta aberta é
mesmo a da loja. Depois disso, a sessão fica pronta para leitura.

## Regra principal: só leitura

Esta skill define a regra do admin para todas as outras: **nada no admin pode
ser editado, incluído, excluído, duplicado, ativado, desativado, salvo ou
publicado**. Pode abrir menus, telas, buscas, filtros, paginação e registros.
A única ação fora da leitura é o seu login na janela do Chromium.

A skill não usa chave de API e nunca pede senha, código ou token no chat.

## Quando usar

- Você pede para entrar no admin, no myvtex ou na conta de uma loja.
- A `request-pre-analysis` precisa ler o cadastro da loja.

Ela não analisa chamado.

## Exemplos

```text
/vtex-admin-login Kolplast
Entra no admin da Banana Brasil B2C
Abre o myvtex da ofnerio
```

## Como o vendor é escolhido

Na ordem, vale o primeiro que existir:

1. O vendor que você informou na mensagem.
2. O `vendor` do cadastro (`lojas.json`).
3. O retorno da `identify-store-vendor` (`confirmado` ou `provavel`).

Se nada disso der um vendor válido, a skill para e pede o vendor.

## Passo a passo

1. Resolve o vendor.
2. Roda a limpeza semanal (`scripts/limpar-perfil-admin.sh`).
3. Abre o admin pelo servidor `playwright-admin`.
4. Se cair no login, para e pede que você entre na janela com **e-mail e senha
   da VTEX** (login com Google costuma ser recusado nesse Chromium).
5. Quando você disser que entrou, abre de novo.
6. Confere a conta em `https://{vendor}.myvtex.com/api/vlm/account/stores`,
   procurando o domínio da loja entre os hosts.

## Gravação no cadastro

A skill grava só o campo `vendor` no `lojas.json`:

- Conta conferida: grava o vendor usado, se a loja não tinha ou tinha outro.
- Conta não conferida: grava só vendor informado por você ou `confirmado`, e
  só se a loja ainda não tiver vendor.
- Conta incorreta: não grava.

## Limpeza semanal

O script `scripts/limpar-perfil-admin.sh`:

- apaga os prints com mais de 7 dias (podem ter dados de clientes e pedidos);
- apaga o perfil do admin (os logins salvos) quando ele completa 7 dias.

| Saída | Significado |
|---|---|
| `0` | Perfil pronto para uso |
| `2` | Perfil vencido, mas o navegador do admin está aberto. Feche e rode de novo |

Depois de uma limpeza, é preciso entrar de novo nas contas. Para rodar à mão,
a partir da pasta desta skill:

```bash
bash scripts/limpar-perfil-admin.sh
```

## Estados de retorno

| Estado | Significado |
|---|---|
| `pronto` | Admin aberto e conta conferida (ou registrada como não conferida) |
| `aguardando_login` | Janela aberta no login; você precisa entrar |
| `aguardando_instalacao` | Falta preparar ou reconectar o Playwright |
| `vendor_ausente` | Não há vendor utilizável |
| `vendor_incorreto` | O login abriu uma conta que não é a da loja |
| `entrada_invalida` | Nome ou vendor fora do formato |
| `falhou` | Navegador não abriu ou navegação falhou |

Formato:

```markdown
## Admin VTEX
## Loja
## Vendor
## Conta
## Cadastro
## URL
## Evidência
```

## Depende de

- `setup-playwright` (servidor `playwright-admin`)
- `identify-store-vendor` (quando o vendor não está no cadastro)
- `find-store-repository` (regras do `lojas.json`)

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Regras, estados e passos |
| `scripts/limpar-perfil-admin.sh` | Limpeza semanal do perfil do admin e dos prints |
