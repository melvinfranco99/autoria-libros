#!/usr/bin/env bash
# Firma y sella en Bitcoin la versión definitiva del libro.
# Uso (desde la carpeta del libro): ../firmar_y_sellar.sh <libro>.pdf
set -euo pipefail

PDF="${1:?Indica el PDF definitivo}"
KEY="melvinfrancopedraza@gmail.com"

command -v ots >/dev/null || { echo "Falta OpenTimestamps: python3 -m venv ~/.local/share/ots-venv && ~/.local/share/ots-venv/bin/pip install opentimestamps-client && ln -s ~/.local/share/ots-venv/bin/ots ~/.local/bin/ots"; exit 1; }

sha256sum "$PDF" | tee "$PDF.sha256"
gpg --local-user "$KEY" --armor --detach-sign --yes "$PDF"
gpg --verify "$PDF.asc" "$PDF"
[ -f "$PDF.ots" ] && echo "Ya existe $PDF.ots: no se vuelve a sellar." || ots stamp "$PDF"

echo
echo "Hecho: $PDF.sha256, $PDF.asc y $PDF.ots"
echo "Dentro de unas horas ejecuta:  ots upgrade $PDF.ots"
echo "y comprueba con:               ots verify $PDF.ots"
