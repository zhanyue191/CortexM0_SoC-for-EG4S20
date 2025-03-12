                PRESERVE8
                THUMB
					
Stack_Size      EQU     0x00000400
                AREA    STACK, NOINIT, READWRITE, ALIGN=4
Stack_Mem       SPACE   Stack_Size
__initial_sp

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     0                         ; NMI Handler
                DCD     0                         ; Hard Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; SVCall Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler
                DCD     KEY_Handler               ; IRQ0 Handler

                AREA    |.text|, CODE, READONLY

; Reset Handler

Reset_Handler   PROC
                GLOBAL  Reset_Handler
                ENTRY
                ;IMPORT  main
                ;LDR     R0, =main
				;MOV     R8, R0
                ;MOV     R9, R8
                ;BX      R0
				LDR     R0, =0xe000e100          ; IRQ en
                MOVS    R1, #0x01
                STR     R1, [R0]
				
				LDR     R0, =0xE000E010          ; STK_CSR en
                MOVS    R1, #0x07
                STR     R1, [R0]
				
				LDR     R0, =0xE000E014          ; STK_LOAD en
                MOVS    R1, #0xff
                STR     R1, [R0]
				
				LDR     R0, =0xE000E018          ; STK_VAL en
                MOVS    R1, #0x00
                STR     R1, [R0]
				
				BL      gpio_test
				;BL      seg_test
				BL      buzz_test
				BL      main_loop
				ENDP		
					
main_loop		PROC
				LDR     R0, =main_loop
				MOV     R8, R0
                MOV     R9, R8
                BX      R0
				ENDP

SysTick_Handler PROC
				PUSH	{R0,R1,R2,LR}
                LDR     R5, =0x40000004          ; led_data
                LDR     R4, [R5]
				POP		{R0,R1,R2,PC}
                ENDP

KEY_Handler     PROC
                ;EXPORT KEY_Handler            [WEAK]
				PUSH	{R0,R1,R2,LR}
                LDR     R5, =0x40010010          ; key_data
                LDR     R4, [R5]
				POP		{R0,R1,R2,PC}
                ENDP

gpio_test       PROC				
                LDR     R0, =0x40000000          ; led en
                MOVS    R1, #0x01
                STR     R1, [R0]
                LDR     R0, =0x40000004          ; led data write
                MOVS    R1, #0x07
                STR     R1, [R0]
				LDR     R2, [R0]			     ; led data read	
                LDR     R0, =0x40000010          ; sw data read
                LDR     R2, [R0]
				BX      LR
                ENDP

seg_test        PROC
				MOVS    R2, #0x00
                LDR     R0, =0x40020000          ; bit write
                MOVS    R1, #0x01
                STR     R1, [R0]				 
				LDR     R2, [R0]				 ; bit read
                LDR     R0, =0x40020004          ; sel write
                MOVS    R1, #0x03
                STR     R1, [R0]
				LDR     R2, [R0]				 ; sel read
				BX      LR
                ENDP

buzz_test       PROC
                LDR     R0, =0x40020000          ; tune en
                MOVS    R1, #0x01
                STR     R1, [R0]				 

                LDR     R0, =0x40020004          ; tune data 11-37
                MOVS    R1, #0x11
                STR     R1, [R0]
				
				LDR     R0, =0x40020008          ; beat en
                MOVS    R1, #0x01
                STR     R1, [R0]
				
				LDR     R0, =0x4002000c          ; beat data
                MOVS    R1, #0x03
                STR     R1, [R0]
				
				LDR     R0, =0x40020010          ; finish data
                MOVS    R2, #0x00
                STR     R2, [R0]
				
				BX      LR
                ENDP

                END
