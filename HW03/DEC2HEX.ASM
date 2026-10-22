
; ==========================================
; 作业3：10进制转16进制
; 输入：0~255的十进制整数
; 输出：2位十六进制数（00~FF）
; ==========================================

.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'Please input a Dec number (0-255): $'
    MSG2 DB 0DH,0AH,'The Hex number:',0DH,0AH,'$'
    ERRMSG DB 0DH,0AH,'Invalid Dec number!$'

    ; 最多输入3位十进制数字
    BUFFER DB 4,0,5 DUP(0)

    NUM DW 0

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; 输出提示信息
    LEA DX,MSG1
    MOV AH,09H
    INT 21H

    ; 读取键盘输入
    LEA DX,BUFFER
    MOV AH,0AH
    INT 21H

    ; 判断输入长度
    MOV CL,BUFFER+1
    CMP CL,1
    JAE CHECK_MAX
    JMP INPUT_ERROR

CHECK_MAX:
    CMP CL,3
    JBE LENGTH_OK
    JMP INPUT_ERROR

LENGTH_OK:
    MOV CH,0
    LEA SI,BUFFER+2
    MOV NUM,0

CONVERT_LOOP:
    MOV AL,[SI]

    ; 验证字符必须是0~9
    CMP AL,'0'
    JAE CHECK_DIGIT_MAX
    JMP INPUT_ERROR

CHECK_DIGIT_MAX:
    CMP AL,'9'
    JBE VALID_DIGIT
    JMP INPUT_ERROR

VALID_DIGIT:
    ; 字符变成数值0~9
    SUB AL,'0'
    MOV BL,AL
    MOV BH,0

    ; 原数乘10，再加当前数字
    MOV AX,NUM
    MOV DX,10
    MUL DX
    ADD AX,BX

    ; 超过255则输入非法
    CMP AX,255
    JBE VALUE_OK
    JMP INPUT_ERROR

VALUE_OK:
    MOV NUM,AX

    INC SI
    LOOP CONVERT_LOOP

    ; 输出结果标题
    LEA DX,MSG2
    MOV AH,09H
    INT 21H

    ; 取高4位
    MOV AX,NUM
    MOV CL,4
    SHR AL,CL

    MOV DL,AL
    CALL PRINT_HEX_DIGIT

    ; 取低4位
    MOV AX,NUM
    AND AL,0FH

    MOV DL,AL
    CALL PRINT_HEX_DIGIT

    JMP PROGRAM_END

INPUT_ERROR:
    LEA DX,ERRMSG
    MOV AH,09H
    INT 21H

PROGRAM_END:
    MOV AX,4C00H
    INT 21H

MAIN ENDP

; ==========================================
; 子程序：将0~15转换为16进制字符输出
; 输入：DL = 0~15
; ==========================================
PRINT_HEX_DIGIT PROC
    CMP DL,9
    JA HEX_LETTER

    ; 0~9转换成字符
    ADD DL,'0'
    JMP OUTPUT_CHAR

HEX_LETTER:
    ; 10~15转换成A~F
    ADD DL,55

OUTPUT_CHAR:
    MOV AH,02H
    INT 21H
    RET

PRINT_HEX_DIGIT ENDP

END MAIN
