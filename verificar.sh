#!/usr/bin/env bash
# Comprueba hash, firma y sello en Bitcoin de los archivos de un libro.
# Uso (desde la carpeta del libro): ../verificar.sh [<archivo> ...]
# Sin argumentos, comprueba todos los archivos que tienen .sha256.
set -uo pipefail
HUELLA="440E03B5ABD0934513199D1AB2470D65B902C107"
DIR="$(cd "$(dirname "$0")" && pwd)"
gpg --import "$DIR/clave_publica_melvin.asc" 2>/dev/null
PY=python3; $PY -c "import opentimestamps" 2>/dev/null || PY=~/.local/share/ots-venv/bin/python

if [ $# -eq 0 ]; then set -- $(ls *.sha256 | sed 's/\.sha256$//'); fi
ERRORES=0
for F in "$@"; do
  echo "================ $F"
  echo -n "1. Hash:  "; sha256sum -c "$F.sha256" >/dev/null 2>&1 && echo "OK, el archivo es el original" || { echo "ERROR: el archivo ha cambiado"; ERRORES=1; continue; }
  echo -n "2. Firma: "
  if [ -f "$F.asc" ] && gpg --status-fd 1 --verify "$F.asc" "$F" 2>/dev/null | grep -q "VALIDSIG $HUELLA"; then
    echo "OK, firmado por Melvin Franco ($HUELLA)"
  else
    echo "ERROR o falta la firma"; ERRORES=1
  fi
  echo "3. Sello:"
  $PY - "$F" <<'PYEOF' || ERRORES=1
import sys, hashlib
from opentimestamps.core.timestamp import DetachedTimestampFile
from opentimestamps.core.serialize import StreamDeserializationContext
from opentimestamps.core.notary import BitcoinBlockHeaderAttestation
f = sys.argv[1]
try:
    d = DetachedTimestampFile.deserialize(StreamDeserializationContext(open(f + '.ots', 'rb')))
except FileNotFoundError:
    print("   ERROR: falta el sello .ots"); sys.exit(1)
if d.file_digest != hashlib.sha256(open(f, 'rb').read()).digest():
    print("   ERROR: el sello no corresponde a este archivo"); sys.exit(1)
bloques = [(a.height, m) for m, a in d.timestamp.all_attestations() if isinstance(a, BitcoinBlockHeaderAttestation)]
if not bloques:
    print("   PENDIENTE: aún no está en Bitcoin. Ejecuta 'ots upgrade " + f + ".ots' más tarde."); sys.exit(0)
altura, m = min(bloques)
print(f"   Bloque de Bitcoin {altura}. El explorador debe mostrar esta Merkle Root:")
print(f"   {m[::-1].hex()}")
print(f"   https://www.blockchain.com/explorer/blocks/btc/{altura}")
PYEOF
done
exit $ERRORES
