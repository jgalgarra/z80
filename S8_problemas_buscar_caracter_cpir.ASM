; Escribir un programa en ensamblador del Z80 que:
; Almacene una secuencia de 5 números consecutivamente.
; Busque un número concreto dentro de dicha secuencia.
; Deje en la variable encontrado una cifra indicando
; si lo ha encontrado o si no (1: encontrado; 0: no encontrado).
; Ejemplo de Uso de la instruccion CPIR


AppFilename             equ "S8_problemas_buscar_caracter_cpir"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry


cadena                   defm "cadenadecaracteres"
encontrado               defb  0

AppEntry                ld HL,cadena
                        ld A,'x'
                        ld BC,18
                        CPIR
                        jp z,ok
                        ld HL,encontrado
                        ld (HL),0
                        jp Para
ok                      ld HL,encontrado
                        ld (HL),1
Para                    halt
                        jr Para



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


