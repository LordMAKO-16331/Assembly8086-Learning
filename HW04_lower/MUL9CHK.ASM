; 作业4（下半部分）：九九乘法表纠错
; 功能：检查数据段中的9*9乘法表，输出错误元素的行号和列号
; 环境：8086 / MASM 5.00 / DOSBox

.MODEL SMALL
.STACK 100H

.DATA
; 9*9乘法表数据，故意保留题目给出的5处错误
TABLE_DATA DB 7,2,3,4,5,6,7,8,9
           DB 2,4,7,8,10,12,14,16,18
           DB 3,6,9,12,15,18,21,24,27
           DB 4,8,12,16,7,24,28,32,36
           DB 5,10,15,20,25,30,35,40,45
           DB 6,12,18,24,30,7,42,48,54
           DB 7,14,21,28,35,42,49,56,63
           DB 8,16,24,32,40,48,56,7,72
           DB 9,18,27,36,45,54,63,72,81

ROW_NO   DB 1               ; 当前行号
COL_NO   DB 1               ; 当前列号

HEADER   DB 'x y',0DH,0AH,'$'
ERR_MSG  DB ' error',0DH,0AH,'$'
DONE_MSG DB 0DH,0AH,'accomplish!',0DH,0AH,'$'

.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX              ; 初始化数据段寄存器

    MOV DX, OFFSET HEADER
    MOV AH, 09H
    INT 21H                 ; 输出表头 x y

    MOV SI, 0               ; SI作为数据表下标，初始指向第0个元素
    MOV BYTE PTR ROW_NO, 1

ROW_LOOP:
    MOV BYTE PTR COL_NO, 1

COL_LOOP:
    ; 计算当前位置的正确乘积：ROW_NO * COL_NO
    MOV AL, ROW_NO
    MUL BYTE PTR COL_NO     ; AX = AL * COL_NO，乘积最大为81
    MOV BL, AL              ; BL保存正确乘积

    ; 通过TABLE_DATA[SI]读取数据段中的实际数据
    MOV AL, TABLE_DATA[SI]
    CMP AL, BL
    JE DATA_CORRECT         ; 相等则该位置正确

    CALL PRINT_ERROR        ; 不相等则调用过程，输出行号和列号

DATA_CORRECT:
    INC SI                  ; 指向表中的下一个字节
    INC BYTE PTR COL_NO
    CMP BYTE PTR COL_NO, 10
    JB COL_LOOP             ; 列号小于10，继续检查当前行

    INC BYTE PTR ROW_NO
    CMP BYTE PTR ROW_NO, 10
    JB ROW_LOOP             ; 行号小于10，继续检查下一行

    MOV DX, OFFSET DONE_MSG
    MOV AH, 09H
    INT 21H                 ; 输出完成提示

    MOV AX, 4C00H
    INT 21H                 ; 返回DOS
MAIN ENDP

; --------------------------------------------------
; 过程名：PRINT_ERROR
; 功能：输出当前错误数据的行号、列号和 error
; 保护：保存并恢复本过程使用的AX、DX
; --------------------------------------------------
PRINT_ERROR PROC NEAR
    PUSH AX                 ; 保存调用者的AX
    PUSH DX                 ; 保存调用者的DX

    MOV DL, ROW_NO
    ADD DL, '0'             ; 将1~9转换为对应ASCII字符
    MOV AH, 02H
    INT 21H                 ; 输出行号

    MOV DL, ' '
    MOV AH, 02H
    INT 21H                 ; 输出空格

    MOV DL, COL_NO
    ADD DL, '0'
    MOV AH, 02H
    INT 21H                 ; 输出列号

    MOV DX, OFFSET ERR_MSG
    MOV AH, 09H
    INT 21H                 ; 输出 error 并换行

    POP DX                  ; 恢复调用者的DX
    POP AX                  ; 恢复调用者的AX
    RET                     ; 弹出返回地址，回到CALL之后
PRINT_ERROR ENDP

END MAIN
