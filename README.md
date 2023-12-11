# Printable

Compile printable com executables with just nasm macros.

## Usage

Given "x.asm" which we want to turn into a printable executable "x.com" we will run:

```sh
nasm printable.asm -dinput="$(nasm x.asm -o /dev/stdout | xxd -p - | tr -d '\n')" -o x.com
```

## Example

Let's say we want to make a printable executable that acts the same as my [snake game](https://github.com/donno2048/snake)

We can run the following code:

```sh
root@/root$ wget -q https://github.com/donno2048/snake/raw/master/snake.asm
root@/root$ nasm printable.asm -dinput="$(nasm snake.asm -o /dev/stdout | xxd -p - | tr -d '\n')" -o snake.com
root@/root$ cat snake.com ; echo
u> 8# M02 +?-"e@!C~';</xud`k@*T4UD8!G/AG9_wWvr8\wQ0=yM-):zS[ 'yT`,1P^,/PZ, PY,`P[F,p(D0F,$,~(D0F0\0F0L0F0\0F0\0F0L0F0\0F0L0F0L0F0T0FF0T0FF0L0FFF0L0F0L0F0\0F0L0F0T0F0\0FF0L0F0L0FFF0L0F0\0F0L0F0\0F0L0FF0T0F0\0F0L0F0\0F0L0F0L0FF0L0FF0L0F0L0F0L0FF0L0FF0L0FF0\0FF0L0F0L0F0T0FFF0L00L5, ,q,~-0 -0`-0~,mP[, ,u(G0aV0
```

We can see an executable _snake.com_ was created and is printable, and you can verify yourself that if you take that string and save it in an executable and run it in DOSBox (or other DOS emulator) it will run a snake game.
