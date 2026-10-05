# Autoría de los libros de Melvin Franco

Pruebas criptográficas públicas de autoría. No dependen de ningún Estado, registro ni empresa: cualquiera puede verificarlas con software libre.

Los libros son **libres**: puedes copiarlos, imprimirlos, venderlos, traducirlos o modificarlos sin pedir permiso. Este repositorio sólo deja constancia de quién los escribió y desde cuándo existen.

## Identidad del autor

- **Autor:** Melvin Franco &lt;melvinfrancopedraza@gmail.com&gt;
- **Clave pública OpenPGP (Ed25519):** [`clave_publica_melvin.asc`](clave_publica_melvin.asc)
- **Huella:** `440E 03B5 ABD0 9345 1319  9D1A B247 0D65 B902 C107`

## Libros

| Libro | Versión | SHA-256 del PDF |
|---|---|---|
| [Por qué Dios es libertario](por-que-dios-es-libertario/) | 1.0 (2026-10-05) | `cd4b7c52adb46c8388ce699255777906f195d59c12ee98a90ba42931556bc65b` |

Cada carpeta contiene:

- el PDF;
- `.sha256`: el hash del archivo;
- `.asc`: la firma digital del autor;
- `.ots`: el sello temporal de OpenTimestamps, anclado en la cadena de bloques de Bitcoin.

## Cómo verificarlo

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
