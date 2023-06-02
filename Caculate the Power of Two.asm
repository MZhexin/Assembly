ASSUME CS:CODE
CODE SEGMENT
    MOV AX, 2
    MOV CX, 11; 设循环次数为12
S:  ADD AX, AX; 通过标号S标记存放待循环语句的地址
    LOOP S; 循环
    MOV AX, 4C00H
    INT 21H
CODE ENDS
END
