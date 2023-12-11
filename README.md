# Printable

Compile printable com executables with just nasm macros.

## Usage

Given "x.asm" which we want to turn into a printable executable "x.com" we will run:

```sh
nasm printable.asm -dinput="$(nasm x.asm -o /dev/stdout | xxd -p - | tr -d '\n')" -o x.com
```
