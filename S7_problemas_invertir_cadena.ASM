; Escribir un programa en ensamblador del Z80 que:
; Almacene una cadena de caracteres ASCII de tamaño par.
; Copie la cadena en otro lugar de la memoria, pero invertida.
;Se hará uso de la pila para llevar a cabo la operación.


AppFilename             equ "S7_problemas_invertir_cadena"

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry

Texto                   defm "OLA KE ASE?"              ; Cadena de texto (la solucion sirve para numero par o impar)
EndTexto                equ $                           ; Con esto, el ensamblador sabe cual es la direccion de Texto
TextoInv                defs EndTexto-Texto             ; Reserva memoria para el texto invertido. Dimension: longitud de Texto

AppEntry                LD B,EndTexto-Texto             ; Contador para repetir el bucle el numero de caracteres de texto
                        LD IX,EndTexto-1                ; Direccion del ultimo byte de Texto a IX
                        LD DE,(IX)                      ; Guardamos el caracter en DE, aunque solo nos importa el byte de E
                        PUSH DE                         ; DE a la pila
                        LD IY,TextoInv                  ; Direccion del primer byte de TextoInv a IY
Bucle                   POP DE                          ; Recuperamos el caracter de Texto
                        LD (IY),E                       ; Lo llevamos al byte de TextoInv apuntado por IY
                        DEC IX                          ; Apuntamos un byte atras en Texto
                        INC IY                          ; Apuntamos un bute adelante en Texto Invd
                        LD DE,(IX)                      ; Llevamos el caracter de Texto a la pila
                        PUSH DE
                        DJNZ Bucle                      ; Repetimos el bucle mientras no lleguemos al principio de Texto
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


