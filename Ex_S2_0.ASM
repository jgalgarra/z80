; Problem S2_1.
;Escribir un programa en ensamblador del Z80 que:
;Almacene los números 44H y 2AH en las direcciones de memoria 8250H y 8251H.
;Almacene la suma de ambos números en la dirección 8260H.


AppFilename             equ "Ex_S2_0"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                LD hl,#8250                     ; Carga la primera dirección en HL
                        LD (HL),#44                     ; Carga #44 en la dirección apuntada por HL
                        LD hl,#8251                     ; Idem para la segunda dirección
                        LD (HL),#2A
                        LD A,(#8250)                    ; Primer operando en A
                        LD BC,(#8251)                   ; Segundo operando en BC
                        ADD C                           ; Suma
                        LD (#8260),A
                        HALT
                        JP AppEntry


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


