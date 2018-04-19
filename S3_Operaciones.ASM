; Ejemplos de operaciones matematicas y bits.

AppFilename             equ "S3_operaciones"

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                LD A, 4                         ; Carga el número 4 en A
                        LD B, 7                         ; Carga el número 7 en B
                        NEG                             ; Convierte el contenido de A en negativo, complemento a 2
                        ADD B                           ; En A se guarda el resultado A - B
                        LD B, 2                         ; Cargamos el numero 2 en B
                        RLC B                           ; Desplazamiento a la izquierda de un bit, equivale a
                                                        ; multiplicar por 2
                        LD D, 6
                        RRC D                           ; Desplazamiento a la izquierda. Equivale a dividir por 2
                        XOR A                           ; XOR sobre cualquier registro, lo pone a 0
Finish                  HALT
                        JR Finish


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


