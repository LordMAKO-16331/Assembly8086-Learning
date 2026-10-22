
; ==========================================
; 作业3：16进制转10进制
; 输入：1~2位十六进制数（00~FF）
; 输出：对应的十进制数（0~255）
; 支持大小写 A~F
; ==========================================

.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'Please input a Hex number: $'
    MSG2 DB 0DH,0AH,'The Dec number:',0DH,0AH,'$'
    ERRMSG DB 0DH,0AH,'Invalid Hex number!$'

    ; DOS 0AH 缓冲输入
    ; 最多接收2个十六进制字符
    BUFFER DB 3,0,4 DUP(0)

    NUM DW 0

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; 输出输入提示
    LEA DX,MSG1
    MOV AH,09H
    INT 21H

    ; 从键盘读取字符串
    LEA DX,BUFFER
    MOV AH,0AH
    INT 21H

    ; 检查输入长度是否为1~2
    MOV CL,BUFFER+1
    CMP CL,1
    JB INPUT_ERROR
    CMP CL,2
    JA INPUT_ERROR

    MOV CH,0
    LEA SI,BUFFER+2
    MOV NUM,0

CONVERT_LOOP:
    ; 取一个输入字符
    MOV AL,[SI]

    ; 判断是否为数字0~9
    CMP AL,'0'
    JB INPUT_ERROR
    CMP AL,'9'
    JBE IS_DIGIT

    ; 判断是否为大写A~F
    CMP AL,'A'
    JB CHECK_LOWER
    CMP AL,'F'
    JBE IS_UPPER

CHECK_LOWER:
    ; 判断是否为小写a~f
    CMP AL,'a'
    JB INPUT_ERROR
    CMP AL,'f'
    JA INPUT_ERROR

    SUB AL,'a'
    ADD AL,10
    JMP ADD_DIGIT

IS_UPPER:
    SUB AL,'A'
    ADD AL,10
    JMP ADD_DIGIT

IS_DIGIT:
    SUB AL,'0'

ADD_DIGIT:
    ; BL暂存当前数字（0~15）
    MOV BL,AL
    MOV BH,0

    ; 当前值乘16
    MOV AX,NUM
    SHL AX,1
    SHL AX,1
    SHL AX,1
    SHL AX,1

    ; 加上当前十六进制位
    ADD AX,BX
    MOV NUM,AX

    INC SI
    LOOP CONVERT_LOOP

    ; 输出转换结果提示
    LEA DX,MSG2
    MOV AH,09H
    INT 21H

    ; 将十进制数逐位转成字符输出
    MOV AX,NUM
    MOV BX,10
    MOV CX,0

DIV_LOOP:
    MOV DX,0
    DIV BX

    ; 余数压栈
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
