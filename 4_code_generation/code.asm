.MODEL SMALL

.STACK 100H

.data
x dw 0
y dw 0
z dw 0
a dw 0
b dw 0
c dw 0
t0 dw 0
t1 dw 0
t2 dw 0
t3 dw 0
t4 dw 0
t5 dw 0
t6 dw 0
t7 dw 0
t8 dw 0
t9 dw 0
t10 dw 0
t11 dw 0
t12 dw 0
t13 dw 0
t14 dw 0
t15 dw 0
t16 dw 0


.CODE

PROC main
MOV AX, 0
MOV  b[BX], AX
MOV AX, 0
MOV  x[BX], AX
L2ADD BX,2
MOV t2,x[BX]
MOV AX, 3
MOV  a[BX], AX
MOV AX, a[BX]
MOV t5, AX
MOV AX, println[BX]
MOV t6, AX
MOV AX, b[BX]
MOV t7, AX
MOV AX, println[BX]
MOV t8, AX
MOV AX, c[BX]
MOV t9, AX
MOV AX, println[BX]
MOV t10, AX
