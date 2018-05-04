; Escribir un programa tome el número de 8 bits inicialmente almacenado en la posición de memoria NUM
; y devuelva el valor del número en notación BCD, almacenando cada dígito en las posiciones de memoria
; CENTENAS, DECENAS y UNIDADES.
; Nota: si el número es de dos cifras decimales, almacenará un 0 en CENTENAS, y si es de una sola cifra
; decimal almacenará un 0 también en DECENAS.

; IMPORTANTE: Para 8 bits esto solo funciona para numeros <=127

AppFilename             equ "S8_Centenas_Decenas_Unidades"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        JP AppEntry
NUM                     defb 119
CENTENAS                defb 0
DECENAS                 defb 0
UNIDADES                defb 0

AppEntry                LD A, (NUM)
                        LD BC, 0;       DEJAREMOS EL COCIENTE EN B
CENT:                   SUB A, 100
                        JP M, FINCENT      ;      SI NEGATIVO SALTA A FIN
                        INC B
                        JR CENT
FINCENT:                PUSH AF
                        LD A, B
                        LD (CENTENAS), A ;       ALMACENAMOS LAS CENTENAS
                        LD A, 0
                        LD B, A;                RESETEAMOS B
                        POP AF
                        ADD A, 100      ;     DEJAMOS A CON EL RESTO DE LA DIVISION
DECR:                   SUB A, 10
                        JP M, FINDEC        ;      SI NEGATIVO SALTA A FINDEC
                        INC B
                        JR DECR
FINDEC:                 PUSH AF
                        LD A, B
                        LD (DECENAS), A;        ALMACENAMOS LAS DECENAS
                        POP AF
                        ADD A, 10;      DEJAMOS A CON EL RESTO DE LA DIVISION
                        LD (UNIDADES), A;       ALMACENAMOS LAS UNIDADES
Para                    HALT
                        JR Para

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


