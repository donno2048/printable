# Printable

Compile printable com executables with just nasm macros.

## Usage

Given "x.asm" which we want to turn into a printable executable "x.com" we will run:

```sh
nasm printable.asm -dinput="$(nasm x.asm -o /dev/stdout | xxd -p - | tr -d '\n')" -o x.com
```

## TODO

- remove `ret` at the end of the executable
- embed jumps in the buffer so the input size won't have any requirement

## Note

This is a POC so the method is not ideal.

If we wanted to make it better we could make the buffer not just arbitrarily store `0x40` as filler but to scan through values to find the best one.

Also, we could use a `movax` macro instead of `moval` and in the `execute` macro store every printable **byte** but do the `sub`s over words.
