
; ==========================================
; 作业3：求和结果的三种保存方式
; 1. 寄存器
; 2. 数据段
; 3. 栈
; ==========================================

.MODEL SMALL
.STACK 100H

.DATA
    SUM_RESULT DW 0

    MSG1 DB 'Register: $'
    MSG2 DB 0DH,0AH,'Data Segment: $'
    MSG3 DB 0DH,0AH,'Stack: $'
    NEWLINE DB 0DH,0AH,'$'

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; 累加 1~100
    XOR AX,AX
    MOV BX,1
    MOV CX,100

SUM_LOOP:
    ADD AX,BX
    INC BX
    LOOP SUM_LOOP

    ; 此时AX=5050
    ; 分别保存到数据段和栈
    MOV SUM_RESULT,AX
    PUSH AX

    ; 第一种：从寄存器取结果
    MOV BX,AX
    LEA DX,MSG1
    MOV AH,09H
    INT 21H
    MOV AX,BX
    CALL PRINT_DECIMAL

    ; 第二种：从数据段取结果
    LEA DX,MSG2
    MOV AH,09H
    INT 21H
    MOV AX,SUM_RESULT
    CALL PRINT_DECIMAL

    ; 第三种：从栈中取结果
    LEA DX,MSG3
    MOV AH,09H
    INT 21H
    POP AX
    CALL PRINT_DECIMAL

    ; 最后换行
    LEA DX,NEWLINE
    MOV AH,09H
    INT 21H

    MOV AX,4C00H
    INT 21H
MAIN ENDP

; ==========================================
; PRINT_DECIMAL
; 输入：AX = 0~65535
; 功能：输出AX的十进制表示
; ==========================================
PRINT_DECIMAL PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX,10
    XOR CX,CX

DIV_LOOP:
    XOR DX,DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX,0
    JNE DIV_LOOP

PRINT_LOOP:
    POP DX
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    LOOP PRINT_LOOP

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_DECIMAL ENDP

END MAIN
