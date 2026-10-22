
; ============================================
; 作业3：用户输入数字并求和
; 功能：输入N（1~100）
;       计算1+2+...+N
;       以十进制输出结果
; 环境：MASM 5.0 + DOSBox
; ============================================

.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'Please input N (1-100): $'
    MSG2 DB 0DH,0AH,'Sum = $'
    ERRMSG DB 0DH,0AH,'Invalid input!$'
    NEWLINE DB 0DH,0AH,'$'

    ; DOS 0AH 缓冲输入
    BUFFER DB 4,0,5 DUP(0)

    N DW 0
    SUM_RESULT DW 0

.CODE
MAIN PROC
    ; 初始化数据段
    MOV AX,@DATA
    MOV DS,AX

    ; 显示输入提示
    LEA DX,MSG1
    MOV AH,09H
    INT 21H

    ; 读取用户输入
    LEA DX,BUFFER
    MOV AH,0AH
    INT 21H

    ; 检查输入长度1~3
    MOV CL,BUFFER+1
    CMP CL,1
    JB INPUT_ERROR
    CMP CL,3
    JA INPUT_ERROR
    MOV CH,0

    ; 将ASCII数字转换为整数
    LEA SI,BUFFER+2
    MOV N,0

INPUT_LOOP:
    MOV AL,[SI]
    CMP AL,'0'
    JB INPUT_ERROR
    CMP AL,'9'
    JA INPUT_ERROR

    SUB AL,'0'
    MOV BL,AL
    MOV BH,0

    ; N = N * 10 + 当前数字
    MOV AX,N
    MOV DX,10
    MUL DX
    ADD AX,BX
    MOV N,AX

    ; 必须小于等于100
    CMP AX,100
    JA INPUT_ERROR

    INC SI
    LOOP INPUT_LOOP

    ; N必须大于等于1
    CMP N,1
    JB INPUT_ERROR

    ; 计算1+2+...+N
    XOR AX,AX
    MOV BX,1
    MOV CX,N

SUM_LOOP:
    ADD AX,BX
    INC BX
    LOOP SUM_LOOP

    MOV SUM_RESULT,AX

    ; 显示结果提示
    LEA DX,MSG2
    MOV AH,09H
    INT 21H

    ; 将结果转换为十进制字符串
    MOV AX,SUM_RESULT
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

    ; 输出换行
    LEA DX,NEWLINE
    MOV AH,09H
    INT 21H

    JMP PROGRAM_END

INPUT_ERROR:
    LEA DX,ERRMSG
    MOV AH,09H
    INT 21H

PROGRAM_END:
    MOV AX,4C00H
    INT 21H

MAIN ENDP
END MAIN
