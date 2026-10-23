
; 作业4：乘法指令和过程调用
; 功能：输出倒序九九乘法表
; 环境：8086 / MASM 5.00 / DOSBox

.MODEL SMALL
.STACK 100H

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV SI, 9              ; SI：当前行的乘数，从9递减到1

ROW_LOOP:
    MOV DI, 1              ; DI：当前列的乘数，从1开始

COL_LOOP:
    ; 输出第一个乘数
    MOV AX, SI
    CALL PRINT_NUM

    ; 输出乘号 *
    MOV DL, '*'
    CALL PUT_CHAR

    ; 输出第二个乘数
    MOV AX, DI
    CALL PRINT_NUM

    ; 输出等号 =
    MOV DL, '='
    CALL PUT_CHAR

    ; 计算乘积 SI * DI
    MOV AX, SI
    MUL DI                 ; DX:AX = AX * DI

    ; 输出乘积
    CALL PRINT_NUM

    ; 输出三个空格，分隔同一行的算式
    MOV DL, ' '
    CALL PUT_CHAR
    CALL PUT_CHAR
    CALL PUT_CHAR

    INC DI                 ; 列乘数加1
    CMP DI, SI
    JBE COL_LOOP           ; DI <= SI 时继续当前行

    ; 输出回车和换行
    MOV DL, 0DH
    CALL PUT_CHAR
    MOV DL, 0AH
    CALL PUT_CHAR

    DEC SI                 ; 行乘数减1
    CMP SI, 0
    JNE ROW_LOOP           ; SI不为0时继续下一行

    MOV AX, 4C00H
    INT 21H
MAIN ENDP


; --------------------------------------------------
; 过程：PRINT_NUM
; 功能：将AX中的无符号十进制整数输出到屏幕
; 保护：AX、BX、CX、DX
; --------------------------------------------------
PRINT_NUM PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 10
    XOR CX, CX

    ; 反复除以10，将各位数字压入堆栈
DIV_LOOP:
    XOR DX, DX
    DIV BX                 ; AX=商，DX=余数
    PUSH DX                ; 保存当前最低位
    INC CX
    CMP AX, 0
    JNE DIV_LOOP

    ; 从堆栈取出数字，按高位到低位输出
PRINT_LOOP:
    POP DX
    ADD DL, '0'            ; 数字转换为ASCII字符
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM ENDP


; --------------------------------------------------
; 过程：PUT_CHAR
; 功能：输出DL中的一个字符
; 保护：AX
; --------------------------------------------------
PUT_CHAR PROC NEAR
    PUSH AX
    MOV AH, 02H
    INT 21H
    POP AX
    RET
PUT_CHAR ENDP

END MAIN
