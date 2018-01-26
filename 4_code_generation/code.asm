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

;function definition
PROC main

MOV AX, 0
MOV  b[BX], AX
MOV AX, 0
MOV  x[BX], AX

;Forloop

L4:
;i<5
MOV AX, x[BX]
MOV t0, AX
MOV AX, t0
CMP AX, 4
JL L0
MOV t1, 0
JMP L1
L0:
MOV t1, 1
L1:
CMP t1 ,0
JE L5
;statement
MOV AX, 3
MOV  a[BX], AX

;While Loop

L2:
;While loop - Test expression
DEC a
CMP t3 ,0
JE L3
;statement
INC b
JMP L2

L3:
;i++
INC x
JMP L4

L5:

;Print Code

;Print Code

;Print Code
