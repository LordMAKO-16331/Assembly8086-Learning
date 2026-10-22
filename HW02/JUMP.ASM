
; ============================================
; 作业题目2：打印 ASCII 小写字母
; 方法二：条件跳转指令
; 使用 CMP 和 JNE 控制循环
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

    ; 输出标题
    LEA DX, TITLE_MSG
    MOV AH, 09H
    INT 21H

    ; BL 保存当前字母
    MOV BL, 'a'

    ; BP 保存已经打印的行数
    MOV BP, 0

    ; SI 保存当前行已打印的字符数
    MOV SI, 0

PRINT_CHAR:
    ; 输出字母
    MOV DL, BL
    MOV AH, 02H
    INT 21H

    ; 输出空格
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    ; 更新字母和当前行计数
    INC BL
    INC SI

    ; 不足 13 个就继续打印
    CMP SI, 13
    JNE PRINT_CHAR

    ; 已达到 13 个，换行
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H

    MOV DL, 0AH
    MOV AH, 02H
    INT 21H

    ; 当前行计数清零
    MOV SI, 0

    ; 行数加一
    INC BP

    ; 未满两行则继续
    CMP BP, 2
    JNE PRINT_CHAR

    ; 退出程序
    MOV AX, 4C00H
    INT 21H

MAIN ENDP
END MAIN
