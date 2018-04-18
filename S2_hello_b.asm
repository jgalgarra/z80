; Primer ejemplo. Suma de dos números con direccionamiento extendido

AppFilename             equ "S2_hello_b.asm"

AppFirst                equ #8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                LD A,(Sumando1)                 ; Carga del Sumando1 en el acumulador
                        LD BC,(Sumando2)                ; Carga del Sumando2 en BC. No podemos hacer
                                                        ; una carga de memoria directamente en B, es nececario
                                                        ; cargar BC
                        ADD B                           ; sumar contenido de A y B
                        LD (Suma),A                     ; Llevar el resultado a Suma
                        HALT
                        jp AppEntry                     ; Bucle infinito para poder verlo en el ejemplo


; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

Sumando1                db  7
Sumando2                dw  $0800
Suma                    db  0

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


