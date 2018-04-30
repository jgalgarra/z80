;Escribir un programa en ensamblador del Z80 que:
;Reserve memoria suficiente y almacene en ella los números 44H, 2AH, A3H y 71H.
;Reserve memoria suficiente y almacene en ella los números 10H, E2H, 6BH y 18H.
;Reserve memoria suficiente y almacene en ella la suma los números anteriores por pares (44H + 10H, 2AH + E2H, …).

AppFilename             equ "S7_problemas_PR_1_slides"  ; Problema 1 de las transparencias

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppFirst
Nums1                   defb $44,$2A,$A3,$71
Nums2                   defb $10,$E2,$6B,$18
SumaNums                defb 0,0,0,0                    ; Guardaremos el resultado en un byte aunque haya desbordamiento

AppEntry:               LD IX,Nums1                     ; direccion de Nums1 al registro de indice IX
                        LD IY,Nums2                     ; direccion de Nums2 al registro de indice IY
                        LD HL,SumaNums                  ; direccion de Suma Nums a HL
                        LD B,4                          ; Usaremos B como contador para controlar el bucle
Bucle:                  LD A,(IX)                       ; Contenido del byte de la direccion en IX a A. Asi cargamos Nums1[]
                        LD C,A                          ; Lo almacenamos temporalmente en C
                        LD A,(IY)                       ; Cotenido del byte en IY al acumulador
                        ADD C                           ; Suma
                        LD (HL),A                       ; Resultado a SumaNums[]
                        INC IY
                        INC IX
                        INC HL                          ; Avanzamos el puntero de los 3 arrays
                        DJNZ Bucle
                        halt                            ; C
                        jp AppEntry                     ;


; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1     ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                            ; Tell the emulator where to start
Zeus_SP                 equ $FF40                               ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry    ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader


