; Método viejuno y muy vulnerables de cifrado. Sumar un número, que es la clave, a cada carácter.
; Para descifrar basta con restar

AppFilename             equ "S8_Cifrado_Romano"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry

CLAVE                   defb 3
MensajeOriginal         defm "Ave Caesar morituri te salutant"
FinMensajeOriginal      equ $
Espacios                defm "   "                                       ; Para que no aparezcan pegados en memoria
MensajeCifrado          defs FinMensajeOriginal-MensajeOriginal
Espacios1               defm "   "                                       ; Para que no aparezcan pegados en memoria
MensajeDescifrado       defs FinMensajeOriginal-MensajeOriginal
LongitudMensaje         defb FinMensajeOriginal-MensajeOriginal

AppEntry                LD IX,MensajeOriginal           ; Cargamos el puntero al mensaje original
                        LD IY,MensajeCifrado            ; Idem al cifrado
                        LD A,(LongitudMensaje)          ; Longitud del mensaje para el contador con B
                        LD B,A
Cifra                   LD A,(IX)                       ; Letra del mensaje origina a la que apunta IX
                        LD D,A
                        LD A,(CLAVE)
                        ADD D                           ; Suma de la clave al código ASCII
                        LD (IY),A                       ; Carácter cifrado a la dirección que apunta IY
                        INC IY                          ; Incrementamos los dos punteros
                        INC IX
                        DJNZ Cifra
                        LD IX,MensajeCifrado            ; Procedimiento inverso para descifrar
                        LD IY,MensajeDescifrado
                        LD A,(LongitudMensaje)
                        LD B,A
Descifra                LD A,(CLAVE)
                        LD D,A
                        LD A,(IX)
                        SUB D
                        LD (IY),A
                        INC IY
                        INC IX
                        DJNZ Descifra
Para                    HALT
                        jp Para                     ;


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


