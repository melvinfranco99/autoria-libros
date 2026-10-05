#!/usr/bin/env bash
# Comprueba hash, firma y sello en Bitcoin de un libro.
# Uso (desde la carpeta del libro): ../verificar.sh <libro>.pdf
set -uo pipefail
PDF="${1:?Indica el PDF}"
HUELLA="440E03B5ABD0934513199D1AB2470D65B902C107"

echo "== 1. Hash del archivo"
sha256sum -c "$PDF.sha256" || exit 1

echo; echo "== 2. Firma del autor"
gpg --import ../clave_publica_melvin.asc 2>/dev/null
gpg --status-fd 1 --verify "$PDF.asc" "$PDF" 2>/dev/null | grep -q "VALIDSIG $HUELLA" \
  && echo "OK: firmado por la clave $HUELLA (Melvin Franco)" || { echo "ERROR: firma no válida"; exit 1; }

echo; echo "== 3. Sello en Bitcoin"
PY=python3; $PY -c "import opentimestamps" 2>/dev/null || PY=~/.local/share/ots-venv/bin/python
$PY - "$PDF" <<'PYEOF'
import sys, hashlib
from opentimestamps.core.timestamp import DetachedTimestampFile
from opentimestamps.core.serialize import StreamDeserializationContext
from opentimestamps.core.notary import BitcoinBlockHeaderAttestation
pdf = sys.argv[1]
d = DetachedTimestampFile.deserialize(StreamDeserializationContext(open(pdf + '.ots', 'rb')))
assert d.file_digest == hashlib.sha256(open(pdf, 'rb').read()).digest(), "el .ots no corresponde a este PDF"
for msg, att in d.timestamp.all_attestations():
    if isinstance(att, BitcoinBlockHeaderAttestation):
        print(f"Bloque de Bitcoin: {att.height}")
        print(f"Merkle root que debe mostrar el explorador:\n  {msg[::-1].hex()}")
        print(f"Compruébalo en https://www.blockchain.com/explorer/blocks/btc/{att.height}")
PYEOF
