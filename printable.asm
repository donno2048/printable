%define printable(x) (x>=0x20 && x<=0x7E)
%define subprintable(x) (printable(x) || !x)

%assign value 0
%macro moval 1
%assign break 0
%assign sub1 0
%rep 0x100
%if subprintable(sub1)
%assign sub2 0
%rep 0x100
%assign sub3 (value-sub1-sub2-%1)&0xFF
%if subprintable(sub2) && subprintable(sub3)
%assign break 1
%exitrep
%endif
%assign sub2 sub2+1
%endrep
%if break
%exitrep
%endif
%endif
%assign sub1 sub1+1
%endrep
%assign value %1
subal sub1, sub2, sub3
%endmacro

%macro subal 1-*
%rep %0
%if %1
sub al, %1
%endif
%rotate 1
%endrep
%endmacro

%macro execute 1-*
%if printable(%0-2)
jnz short $$+%0
%rotate 2
%rep %0-2
%if printable(%1)
db %1
%else
db 0x40
%endif
%rotate 1
%endrep
%assign position 0
pusha
moval 0xCF
push ax
pop bx
%rep %0
%if !position
%assign val 0x75
%elif position=1
%assign val %0-2
%elif printable(%1)
%assign val %1
%else
%assign val 0x40
%endif
%assign diff val-%1
inc bx
%if diff
moval diff
sub [bx+0x30], al
%endif
%assign position position+1
%rotate 1
%endrep
popa
push si
ret
%else
%error "the amount of bytes itself has to be printable, current:", %0
%endif
%endmacro

%macro unpack 1
%substr byte %1 1,2
%strcat bytes "0x", byte
%strlen size %1
%assign index 1
%rep size/2-1
%substr byte %1 index*2+1,2
%strcat bytes bytes, ",0x", byte
%assign index index+1
%endrep
%deftok args bytes
execute args
%endmacro

%defstr packed input
unpack packed
