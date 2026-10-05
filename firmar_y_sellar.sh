#!/usr/bin/env bash
# Calcula el hash, firma y sella en Bitcoin uno o varios archivos definitivos.
# Uso (desde la carpeta del libro): ../firmar_y_sellar.sh <archivo> [<archivo> ...]
# Los archivos que ya tienen firma o sello no se vuelven a firmar ni a sellar.
set -euo pipefail

KEY="melvinfrancopedraza@gmail.com"
[ $# -gt 0 ] || { echo "Indica los archivos a firmar"; exit 1; }
command -v ots >/dev/null || { echo "Falta OpenTimestamps: python3 -m venv ~/.local/share/ots-venv && ~/.local/share/ots-venv/bin/pip install opentimestamps-client && ln -s ~/.local/share/ots-venv/bin/ots ~/.local/bin/ots"; exit 1; }

for F in "$@"; do
  echo "== $F"
  [ -f "$F.sha256" ] || sha256sum "$F" > "$F.sha256"
  sha256sum -c "$F.sha256"
  if [ -f "$F.asc" ]; then
    echo "Ya está firmado."
  else
    gpg --local-user "$KEY" --armor --detach-sign "$F"
  fi
  gpg --verify "$F.asc" "$F"
  [ -f "$F.ots" ] && echo "Ya está sellado." || ots stamp "$F"
  echo
done

echo "Dentro de unas horas ejecuta:  ots upgrade *.ots"
