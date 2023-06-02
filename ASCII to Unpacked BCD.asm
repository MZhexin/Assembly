; ASCII码转换为非压缩型BCD码
DATASG  SEGMENT                         ; 定义数据段
        DATA1 DB 64, ?, 64 DUP('?')
        DATA2 DB 64 DUP('$')
DATASG  ENDS
CODESG  SEGMENT                         ; 定义代码段
        ASSUME CS:CODESG                ; 链接
        ASSUME DS:DATASG
        START:  MOV AX, DATASG
                MOV DS, AX
                LEA SI, DATA1           ; 键盘输入到缓存区
                MOV AH, 0AH
                INT 21H                 ; 打印字符串
                ADD SI, 2               ; 地址偏移
                LEA DI, DATA2  
        TOP:    MOV AL, [SI]   
                CMP AL, 0DH             ; 判断是否为回车
                JZ OUTPUT      
                CMP AL, 30H             ; 比较
                JC FF       
                CMP AL, 39H             ; 比较
                JNC FF       
                SUB AL, 30H    
                MOV BL, AL
                MOV [DI], BL
                INC SI                  ; 指针自增
                INC DI        
                JMP TOP
        FF:     MOV BL, 0FFH   
                MOV [DI], BL
                INC SI
                INC DI
                JMP TOP
        OUTPUT: MOV AH, 4CH   
                INT 21H        
CODESG ENDS
END START
