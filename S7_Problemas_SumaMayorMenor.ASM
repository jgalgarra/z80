; Sea una lista de números de 1 byte almacenada en memoria principal a partir de la dirección BASE.
; La primera entrada de la lista contiene el número de bytes de la misma.
; Escribir un programa en ensamblador del Z80 que encuentre el valor mayor y el menor almacenados en una lista numerica.
; Dichos valores se guardarán en las direcciones MAYOR y MENOR dejando el resultado de su suma
; en la dirección de memoria SUMA.


AppFilename             equ "S7_Problemas_SumaMayorMenor"

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppFirst

BASE                    defb 8,9,3,4,6,12,9,7,21
MAYOR                   defb 0
MENOR                   defb 0
SUMA                    defb 0

AppEntry                LD IX,BASE+1                    ; Puntero al primer numero de la lista, el 0 es el tamanyo
                        LD A,(BASE)
                        LD B,A                          ; Cargamos en B la longitud que indica el primer byte de BASE[0]
                                                        ; menos 1
                        LD A,(IX)                       ;
                        LD (MAYOR),A                    ;
                        ;LD A,(IX)                       ;
                        LD (MENOR),A                    ; Inicializamos MAYOR y MENOR con la primera cifra

Bucle:                  INC IX                          ; Empieza apuntando a la segunda cifra y así hasta N
                                                        ; por eso inicializamos el contador a BASE[0]-1
                        LD DE,(IX)
                        LD A,(MAYOR)
                        CP E                            ; Comparamos el numero con MAYOR
                        JP C ActMayor                   ; JP C equivale a if (A < D)
                        LD A,(MENOR)
                        CP E
                        JP NC ActMenor                  ; Si no es mayor comprobamos si es menor. Equivale a if (A>=D)
SigueProg               DJNZ Bucle
                        LD A,(MAYOR)                    ; Al salir del bucle sumamos MAYOR y MENOR
                        LD HL,(MENOR)                   ; Carga 16 bits en HL. Nos quedamos con el byte bajo
                        ADD L
                        LD (SUMA),A
Para                    HALT
                        JR Para

                        DJNZ Bucle
ActMayor                LD A,E                          ; Guardamos el numero en mayor
                        LD (MAYOR),A
                        JR SigueProg
ActMenor                LD A,E                      ; Guardamos el numero en mayor
                        LD (MENOR),A
                        JR SigueProg


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


