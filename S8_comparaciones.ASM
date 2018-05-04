; Escribir un programa en ensamblador del Z80 que:
; Almacene un valor de una cifra en el registro C.
; Almacene un valor de una cifra en el registro D.
; Compare ambos valores y deje en una dirección de memoria previamente reservada
; una cifra que indique el resultado de la comparación (1: C > D; 0: C = D; -1: D > C).
; Reescribir el programa para que efectúe 5 comparaciones consecutivas con 5 cifras diferentes,
; almacenando los resultados en 5 posiciones consecutivas de memoria

AppFilename             equ "S8_comparaciones"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry

ListaA                  defb 2,3,4,5,1
ListaB                  defb 3,2,4,1,4
Resultados              defb 0,0,0,0,0

AppEntry                LD IX, ListaA
                        LD IY, ListaB
                        LD HL, Resultados
                        LD B,5
Bucle                   LD C, (IX)
                        LD D, (IY)
                        LD A,C
                        CP D
                        JP Z, Iguales
                        JP C, DmayorC
                        JP CMayorD                ; Por aquí solo pasará si C > D
Iguales                 LD A, 0
                        JP GuardaYSuma
DmayorC                 LD A, -1
                        JP GuardaYSuma
CMayorD                 LD A, 1
GuardaYSuma             LD (HL),A
                        INC IX
                        INC IY
                        INC HL
                        DJNZ Bucle
Para                    halt                        ;
                        jr Para                     ;


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


