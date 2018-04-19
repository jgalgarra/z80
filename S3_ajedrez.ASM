; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "Ajedrez"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                ld HL, $5800                    ; Primer bit de la memoria de colores
                        ld A, 12                        ; número de líneas
bucle                   ld B, 16                        ; contador para los 16 pares de píxeles de una línea
row1                    ld (HL), 0                      ; 0 hace que el píxel sea negro
                        inc HL
                        ld (HL), $FF                    ; siguiente pixel blanco
                        inc HL
                        djnz row1                       ; contador de píxeles en linea
                        ld B, 16                        ; contador para los 16 pares de píxeles de una línea
row2                    ld (HL), $FF                      ; 0 hace que el píxel sea negro
                        inc HL
                        ld (HL), 0                      ; siguiente pixel blanco
                        inc HL
                        djnz row2                       ; contador de píxeles en linea
                        dec A
                        jr nz, bucle
                        ret


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


