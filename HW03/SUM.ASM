
; ========================================
; 作业3：求和
; 功能：计算1+2+...+100
; 输出：5050
; 环境：MASM 5.0 + DOSBox
; ========================================

.MODEL SMALL
.STACK 100H

.DATA
    SUM_RESULT DW 0

.CODE
MAIN PROC

    ; 初始化数据段
    MOV AX, @DATA
    MOV DS, AX

    ; AX保存累计求和结果
    MOV AX, 0

    ; BX保存当前需要加的数字
    MOV BX, 1

    ; 循环100次
    MOV CX, 100

SUM_LOOP:

    ADD AX, BX
    INC BX

    LOOP SUM_LOOP

    ; 将5050存放到数据段
    MOV SUM_RESULT, AX

    ; 准备十进制输出
    MOV AX, SUM_RESULT
    MOV BX, 10
    MOV CX, 0

CONVERT_LOOP:

    ; DX:AX除以10
    MOV DX, 0
    DIV BX

    ; 余数压栈保存
    PUSH DX
    INC CX

    ; 商不为0则继续转换
    CMP AX, 0
    JNE CONVERT_LOOP

PRINT_LOOP:

    ; 按相反顺序取出数字
    POP DX

    ; 转换为ASCII字符
    ADD DL, '0'

    ; DOS字符输出
    MOV AH, 02H
    INT 21H

    LOOP PRINT_LOOP

    ; 正常结束程序
    MOV AX, 4C00H
    INT 21H

MAIN ENDP

END MAIN
