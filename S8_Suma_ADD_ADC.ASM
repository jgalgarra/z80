; Programa que demuestra la diferencia entre las instrucciones ADD (Suma sin acarreo) y ADC (Suma con acarreo).
; Queremos sumar 1000 ($03E8) + 2000 ($07D0) usando el acumulador              3000 = $0BB8

AppFilename             equ "S8_Suma_ADD_ADC"                   ; What we're called (for file generation)

AppFirst                equ $7000                       ; Cargamos en $7000 para comprobar que no es obligatorio
                                                         ; hacerlo en $8000

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry                     ;

AppEntry                LD A,$E8                    ; Cargamos el byte bajo de $03E8 en A
                        ADD $D0                     ; Sumamos el byte bajo de $07D0. Esta operacion produce
                                                    ; desbordamiento del acumulador y activa el flag de CARRY
                        LD L,A                      ; Llevamos el resultado a L
                        LD A,$03                    ; Cargamos el byte alto de $03E8 en A
                        ADC $07                     ; Sumamos los dos bytes altos más el CARRY
                        LD H,A                      ; El resultado queda en HL     $0BB8

                        LD A,$E8                    ; Repetimos la operacion sin CARRY y guardando el resultado en BC
                        ADD $D0                     ; Sumamos el byte bajo de $07D0. Esta operacion produce
                                                    ; desbordamiento del acumulador y activa el flag de CARRY
                        LD C,A                      ; Llevamos el resultado a L
                        LD A,$03                    ; Cargamos el byte alto de $03E8 en A
                        ADD $07                     ; Sumam sin CARRY
                        LD B,A                      ; El resultado queda en BC. Es erroneo $0AB0 = 2744
Para                    HALT
                        JR Para                     ;


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


