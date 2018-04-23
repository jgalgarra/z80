; Programa para imprimir en pantalla.

AppFilename             equ "S4_char_position"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry               ld   a, 2                ; Abrir el canal 2
                       call CHANOPEN            ; La rutina 5663 de la ROM indica al procesador que hay que
                                                ; escribir en la pantalla
                       ld   de,caracterpos        ; string con coordenadas del caracter
                       ld   bc,eostrpos-caracterpos  ; length of string to print
                       call PRINT           ; print our string
                       ret

CHANOPEN               equ  5633
PRINT                  equ  8252

caracterpos            defb 22,10,10,'*'
eostrpos               equ $
NewLine                defb 13




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



