; 学会如何调试程序——>U命令查看指令，T命令单步调试，G命令跳转（即打断点）
STACKSG	SEGMENT PARA STACK 'STACK'                                       ; 定义栈段
	DB  256  DUP(?)                                                  ; 重复256次的字节空间，每个字节空间大小未知
STACKSG	ENDS                                                             ; 栈段定义结束
DATASG	SEGMENT  PARA  'DATA'                                            ; 定义数据段
        BLOCK  DW  0, -5, 8, 256, -128, 96, 100, 3, 45, 6, 512           ; 设置初值固定的字空间
               DW  23, 56, 420, 75, 0, -1024, -67, 39, -2000             ; 设置初值固定的字空间
        COUNT  EQU 20                                                    ; 设置常数20
        MAX    DW   ?                                                    ; 定义不知大小的字空间MAX
        ORG    100H                                                      ; 设置当前语句的起始偏移地址
DATASG	ENDS                                                             ; 数据段定义结束                                                      
CODESG	SEGMENT                                                          ; 定义代码段
        ASSUME	SS:STACKSG                                               ; 链接栈段——>链接必须写到代码段里面去
        ASSUME  CS:CODESG                                                ; 链接代码段
        ASSUME	DS:DATASG                                                ; 链接数据段
        BEGIN:  MOV  AX, DATASG                                          ; BEGIN语段，将数据段的段地址存入通用寄存器AX
                MOV  DS, AX                                              ; 将AX的值赋给段寄存器DS，这两行代码将数据段段地址存入了DS                  
                LEA  SI, BLOCK                                           ; 取BLOCK空间的偏移地址并存入源变址寄存器SI
                MOV  CX, COUNT                                           ; 将定义好的常数20存入通用寄存器CX，即设置循环次数为20
                DEC  CX                                                  ; 通用寄存器CX存的值自减一，即循环次数变为19
                MOV  AX, [SI]                                            ; 将源变址寄存器SI中存储的偏移地址赋给通用寄存器AX，即AX存放了BLOCK的偏移地址
        CHKMAX: ADD  SI, 2                                               ; CHKMAX语段，源变址寄存器SI中的值加2
                CMP  [SI], AX                                            ; 比较SI存的偏移地址和AX的值，由于SI加2，此处ZF应该为0，CF应该为0
                JLE  NEXT                                                ; JLE转移到NEXT段，但由于上文的CMP，此处应该不跳转
                MOV  AX, [SI]                                            ; 将源变址寄存器SI中存储的偏移地址赋给通用寄存器AX
                DEC  CX                                                  ; 通用寄存器CX存的值自减一，即循环次数再减一
        NEXT:   LOOP CHKMAX                                              ; NEXT语段，循环语段CHKMAX
                MOV  MAX, AX                                             ; 将AX存入MAX
                MOV  AH, 4CH                                             ; 带返回码结束
                INT  21H                                                 ; 执行终端子程序
CODESG	ENDS                                                             ; 代码段定义结束
END  BEGIN                                                               ; 程序结束
