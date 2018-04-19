; Programa para sumar los 10 primeros numeros
; El resultado se almacena en la direccion Suma

AppFilename             equ "S3_suma10_mejorado"                 ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                LD A,(CifraLimite)                           ; Carga en A la cifra limite
                        LD B,A
SumaOtro                LD A,(Suma)
                        ADD B
                        LD (Suma),A
                        DJNZ SumaOtro                  ;  Resta 1 a B y mientras B no sea 0 ejecuta el bucle
Stop                    HALT
                        JR Stop                     ;

CifraLimite             defb    10
Suma                    defb    0


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


