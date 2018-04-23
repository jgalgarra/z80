; Uso del registro IX y de una rutina de retardo para simular algo animado con colores

AppFilename             equ "S4_IX_Delay_Color"

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                LD IX, InicioColores
                        LD B, (Dibujitos)        ; contador para de repeticion de dibujitos
Bucle:                  LD (IX), Transp
                        LD (IX+1), Black         ; Cuadrito negro
                        LD (IX+2), Transp
                        LD (IX+3), White         ; Cuadrito blanco
                        CALL Retardo
                        LD (IX+1), Transp        ; Borramos los cuadritos de color
                        LD (IX+3), Transp        ;
                        PUSH IX                  ; Empieza la suma de 16 bits
                        POP HL                   ; Cargamos en HL lo que había en OIX
                        LD  D, 0
                        LD  E, $1F               ; Suma de offset para ir a la siguiente line
                        ADC HL, DE               ; Podemos sumar 16 bits en HL pero no en IX
                        PUSH HL                  ; Por eso usamos la pila
                        POP IX                   ; IX actualizado
                        DJNZ Bucle
                        RET

Retardo:                                          ; Esta subrutina realiza un retardo de 1 segundo
                        PUSH DE                   ; guarda el contenido de DE, BC y AF
                        PUSH AF
                        PUSH BC
                        LD  B,4                   ; Podemos usar los registros dentro de la rutina porque
                                                  ; hemos salvado el contexto. Luego lo recuperaremos
Espera:                 LD  DE,#4000              ; Carga DE para realizar el retardo aprox 100 µs
BucDel:                 DEC DE
                        LD  A,D                   ; Coloca D en A
                        OR  E                     ; Pone a 1 el flag Z si D=E=0
                        JP  NZ,BucDel             ; Repite mientras DE >0
                        DJNZ Espera               ; Si el retardo es suficiente termina
                        POP BC                    ; Recupera el contexto
                        POP DE
                        POP AF
                        RET


InicioColores           EQU $5800
Dibujitos               EQU 20
White                   EQU $FF
Black                   EQU $00
Transp                  EQU $38

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


