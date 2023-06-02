; 十六进制数转换为ASCII码
STACKSG	SEGMENT PARA STACK 'STACK'              ; 定义栈段
	DB  256  DUP(?)                         ; 重复256次的字节空间，每个字节空间大小未知
STACKSG	ENDS                                    ; 栈段定义结束
DATASG  SEGMENT                                 ; 定义数据段
        DATA1 DW 1234H                          ; 字空间DATA1
        DATA2 DW ?                              ; 字空间DATA2
DATASG  ENDS                                    ; 数据段结束
CODESG  SEGMENT                                 ; 定义代码段
        ASSUME SS:STACKSG                       ; 链接栈段
        ASSUME CS:CODESG                        ; 链接代码段
        ASSUME DS:DATASG                        ; 链接数据段
        START:  MOV AX, DATASG                  ; 数据段地址存入AX
                MOV DS, AX                      ; 数据段地址存入DS
                XOR BX, BX                      ; 累加单元清零
                MOV SI, 0AH                     ; 设置乘数
                MOV CL, 4                       ; 固定ASCII码为4位
                MOV CH, 3                       ; 设置循环次数
                MOV AX, DATA1                   ; 结果取十进制数
        LP:     ROL AX, CL                      ; 取数字
                MOV DI, AX                      ; 保存当前AX值
                AND AX, 0FH                     ; 屏蔽高位
                ADD AX, BX                      ; 累加
                MUL SI                          ; 相乘
                MOV BX, AX                      ; 将AX存入BX    
                MOV AX, DI                      ; 将DI存入AX
                DEC CH                          ; 循环次数减一
                JNZ LP                          ; 跳转
                ROL AX, CL                      ; 取个位数字
                AND AX, 0FH                     ; 屏蔽高位
                ADD AX, BX                      ; 累加，并将结果存入AX
                MOV DATA2, AX                   ; 将AX的值移动到DATA2
                MOV AH, 4CH                     ; 带返回码结束       
                INT 21H                         ; 执行终端子程序
CODESG	ENDS                                    ; 代码段定义结束
END     START                                   ; 程序结束
