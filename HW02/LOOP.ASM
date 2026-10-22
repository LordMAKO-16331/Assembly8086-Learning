
; ============================================
; 作业题目2：打印 ASCII 小写字母
; 方法一：LOOP 指令 + 双重循环
; 每行 13 个字母，共 2 行
; ============================================

.MODEL SMALL
.STACK 100H

.DATA
    TITLE_MSG DB 'ascii', 0DH, 0AH, '$'

.CODE
MAIN PROC
    ; 初始化数据段
    MOV AX, @DATA
    MOV DS, AX

    ; 输出标题 ascii
    LEA DX, TITLE_MSG
    MOV AH, 09H
    INT 21H

    ; BL 保存当前要打印的字母
    MOV BL, 'a'

    ; 外层循环执行 2 次
    MOV CX, 2

OUTER_LOOP:
    ; 保存外层循环的 CX
    PUSH CX

    ; 内层循环每行执行 13 次
    MOV CX, 13

INNER_LOOP:
    ; 输出当前小写字母
    MOV DL, BL
    MOV AH, 02H
    INT 21H

    ; 输出一个空格
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    ; 移动到下一个字母
    INC BL

    ; 内层循环
    LOOP INNER_LOOP

    ; 换行：回车 + 换行
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H

    MOV DL, 0AH
    MOV AH, 02H
    INT 21H

    ; 恢复外层循环的 CX
    POP CX

    ; 外层循环
    LOOP OUTER_LOOP

    ; 正常退出 DOS 程序
    MOV AX, 4C00H
    INT 21H

MAIN ENDP
END MAIN
