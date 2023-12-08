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

%macro get_byte 3
%assign lastjump %3 % 0x80
%if !printable(lastjump-2)
%define prelastindex (%3 / 0x80 - 1) * 0x80 + 1
%assign lastjump lastjump+0x80-0x40
%endif
%if !(%2 % 0x80) || %3-%2=lastjump
%assign val 0x75
%elif %3-%2=lastjump-1
%assign val lastjump-2
%elif !((%2-1) % 0x80)
%ifdef prelastindex
%if %2=prelastindex
%assign val 0x3E
%else
%assign val 0x7E
%endif
%else
%assign val 0x7E
%endif
%elif printable(%1)
%assign val %1
%else
%assign val 0x40
%endif
%endmacro

%macro execute 1-*
%if %0<=0x10000/0xB-2
%assign position 0
%rep %0
get_byte %1, position, %0
db val
%assign position position+1
%rotate 1
%endrep
%assign incs 0
%assign position 0
pusha
moval 0xCF
push ax
pop bx
%rep %0
get_byte %1, position, %0
%assign diff val-%1
%assign incs incs+1
%if diff
times incs inc bx
moval diff
sub [bx+0x30], al
%assign incs 0
%endif
%assign position position+1
%rotate 1
%endrep
popa
push si
ret
%else
%undef size
%error biggest binary size is 5955, current: %0
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
%if size/2<0x22
%rep 0x22-size/2
%strcat bytes bytes, ",0x20"
%endrep
%endif
%deftok args bytes
execute args
%endmacro

%defstr packed input
unpack packed
