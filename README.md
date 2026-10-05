# Autoría de los libros de Melvin Franco

Pruebas criptográficas públicas de autoría. No dependen de ningún Estado, registro ni empresa: cualquiera puede verificarlas con software libre.

Los libros son **libres**: puedes copiarlos, imprimirlos, venderlos, traducirlos o modificarlos sin pedir permiso. Este repositorio sólo deja constancia de quién los escribió y desde cuándo existen.

## Identidad del autor

- **Autor:** Melvin Franco &lt;melvinfrancopedraza@gmail.com&gt;
- **Clave pública OpenPGP (Ed25519):** [`clave_publica_melvin.asc`](clave_publica_melvin.asc)
- **Huella:** `440E 03B5 ABD0 9345 1319  9D1A B247 0D65 B902 C107`

## Libros

### Por qué Dios es libertario, versión 1.0 (2026-10-05)

| Edición | Archivo | SHA-256 |
|---|---|---|
| PDF de lectura (fondo oscuro) | [`Por_que_Dios_es_libertario_Melvin_Franco.pdf`](por-que-dios-es-libertario/Por_que_Dios_es_libertario_Melvin_Franco.pdf) | `cd4b7c52adb46c8388ce699255777906f195d59c12ee98a90ba42931556bc65b` |
| EPUB (Kindle y lectores electrónicos) | [`Por_que_Dios_es_libertario_Melvin_Franco.epub`](por-que-dios-es-libertario/Por_que_Dios_es_libertario_Melvin_Franco.epub) | `85e41f21ff23e96fba0d14f7774d138f4cc1734ce522d1c7b8e1b463406e2cf0` |
| Interior para imprimir (6 × 9 pulgadas) | [`Por_que_Dios_es_libertario_Melvin_Franco_impresion_interior.pdf`](por-que-dios-es-libertario/Por_que_Dios_es_libertario_Melvin_Franco_impresion_interior.pdf) | `0e24ea0136df5ea231d483f3f2d89ef48917bd6e6fdeb5108ad0b70a5887191d` |
| Cubierta para imprimir | [`Por_que_Dios_es_libertario_Melvin_Franco_impresion_cubierta.pdf`](por-que-dios-es-libertario/Por_que_Dios_es_libertario_Melvin_Franco_impresion_cubierta.pdf) | `ad7d7244e32170eb0336ad4a830b22870f82098efc46d18b201eb23afd31c64d` |
| Portada del libro electrónico | [`Por_que_Dios_es_libertario_Melvin_Franco_portada.jpg`](por-que-dios-es-libertario/Por_que_Dios_es_libertario_Melvin_Franco_portada.jpg) | `529c60b12bbadcb750e20aeb026153dde197fcc2ca3acf3d12db172fa7bbeb28` |

Cada archivo tiene al lado su `.sha256` (hash), su `.asc` (firma digital del autor) y su `.ots` (sello temporal de OpenTimestamps, anclado en Bitcoin).

## Sello en Bitcoin

| Archivo | Bloque | Fecha del bloque | Merkle root |
|---|---|---|---|
| PDF de lectura | [969987](https://www.blockchain.com/explorer/blocks/btc/969987) | 2026-10-05 | `1538e295b237d25d8b90fdc6a560560308ad43565298c5476ae40f778d742bc2` |

## Cómo verificarlo

Forma rápida: comprueba todos los archivos de una vez e indica, para cada uno, el bloque de Bitcoin y la Merkle Root que hay que buscar en un explorador como blockchain.com.

```sh
cd por-que-dios-es-libertario
../verificar.sh
```

Paso a paso:

```sh
cd por-que-dios-es-libertario

# 1. El archivo es exactamente el original
sha256sum -c Por_que_Dios_es_libertario_Melvin_Franco.pdf.sha256

# 2. Lo firmó la clave de Melvin Franco (comprueba que la huella coincide con la de arriba)
gpg --import ../clave_publica_melvin.asc
gpg --verify Por_que_Dios_es_libertario_Melvin_Franco.pdf.asc Por_que_Dios_es_libertario_Melvin_Franco.pdf

# 3. Existía como muy tarde en la fecha del bloque de Bitcoin indicado
ots verify Por_que_Dios_es_libertario_Melvin_Franco.pdf.ots
```

## Compromiso del autor

En la última página del libro aparece este compromiso:

```
52609b6ec746cc3f379da62986618d1d881824bf81eee6e2a8015badfe4da4c7
```

Es el SHA-256 de un secreto de 32 bytes que sólo conoce el autor. Si algún día lo revela, cualquiera podrá comprobar con `sha256sum` que coincide, y eso demostrará que quien publicó esta edición conocía el secreto desde el primer día.
