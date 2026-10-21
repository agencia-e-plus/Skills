#!/usr/bin/env bash
# Limpeza semanal do Playwright das skills:
# - apaga os prints com mais de 7 dias (podem ter dados de clientes e pedidos);
# - apaga o perfil do admin VTEX (guarda as sessões de login das contas) quando completa 7 dias.
# Saída 0: perfil pronto para uso. Saída 2: perfil vencido com o navegador do admin aberto.
set -euo pipefail

BASE="$HOME/.claude/playwright"
PERFIL="$BASE/vtex-admin"
PRINTS="$BASE/prints"
MARCA="$PERFIL/.criado-em"
LIMITE=$((7 * 24 * 60 * 60))
agora=$(date +%s)

if [ -d "$PRINTS" ]; then
  apagados=$(find "$PRINTS" -type f -mmin +$((LIMITE / 60)) -print -delete | wc -l)
  [ "$apagados" -eq 0 ] || echo "Prints com mais de 7 dias: $apagados apagado(s)."
fi

navegador_aberto() {
  if pgrep -f -- "--user-data-dir=$PERFIL" >/dev/null 2>&1; then
    return 0
  fi
  local trava="$PERFIL/SingletonLock" pid
  if [ -L "$trava" ]; then
    pid=$(readlink "$trava" | sed 's/.*-//')
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

if [ -f "$MARCA" ]; then
  criado=$(cat "$MARCA" 2>/dev/null || echo 0)
  case "$criado" in ''|*[!0-9]*) criado=0 ;; esac
  idade=$((agora - criado))
  if [ "$idade" -lt "$LIMITE" ]; then
    echo "Perfil com $((idade / 86400)) dia(s): mantido."
    exit 0
  fi
  if navegador_aberto; then
    echo "Perfil vencido, mas o navegador do admin está aberto. Feche-o e rode de novo."
    exit 2
  fi
  rm -rf -- "$PERFIL"
  echo "Perfil com $((idade / 86400)) dia(s): apagado. Será preciso entrar de novo nas contas."
fi

mkdir -p "$PERFIL"
chmod 700 "$PERFIL"
[ -f "$MARCA" ] || echo "$agora" > "$MARCA"
exit 0
