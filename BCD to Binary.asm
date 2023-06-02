; BCD码转换为二进制码
DATASG  SEGMENT             
        DATA1 DW 1234H            
        DATA2 DW ?  
DATASG  ENDS    

CODESG  SEGMENT             
        ASSUME CS:CODESG, DS:DATASG    

        START:  MOV AX, DATASG            
                MOV DS, AX              
                XOR BX, BX                  
                MOV SI, 0AH        
                MOV CL, 4          
                MOV CH, 3          
                MOV AX, DATA1      
        LP:     ROL AX, CL         
                MOV DI, AX       
                AND AX, 0FH          
                ADD AX, BX              
                MUL SI            
                MOV BX, X            
                MOV AX, DI            
                DEC CH          
                JNZ LP            
                ROL AX, CL                     
                AND AX, 0FH                   
                ADD AX, BX        
                MOV DATA2, AX            
                MOV AH,4CH            
                INT 21H              
CODESG  ENDS            
END START
