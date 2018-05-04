; Ordena una lista de 8 números de mayor a menor empleando el algoritmo Bubble Sort

AppFilename             equ "S8_BubbleSort"                   ; What we're called (for file generation)

AppFirst                equ $7000                       ; Cargamos en $7000 para comprobar que no es obligatorio
                                                         ; hacerlo en $8000

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry                     ;

ListaNumeros            defb 3,2,8,6,5,9,0,1
LongitudLista           equ 8
Maximo                  defb 0
PosMaximo               defb 0

AppEntry                LD D,0                          ; El registro 0 nos servirá para apuntar al comienzo
                                                        ; de la lista de numeros que se compara en el bucle
                                                        ; empieza en 0 y se va incrementado
                        LD IX,ListaNumeros              ; Cargamos en IX la direccion de la lista

BucleExterno            LD A,LongitudLista
                        SUB D
                        LD B,A
                        PUSH IX                         ; Usamos IY para el Bucle Interno
                        POP IY                          ; Guardamos en IY la direccion del elemento inicial que se
                        LD A,D                          ; compara
                        LD (PosMaximo),A
                        LD A,(IX)
                        LD (Maximo),A
                        LD E,D                          ; E se usa como registro para recorrer el array

BucleInterno            LD A,(Maximo)                   ; Inicializamos Maximo al elemento 0 del Array
                        LD H,(IY)
                        CP H
                        JP NC, PasaAlSiguiente
                        LD A,H
                        LD (Maximo),A
                        LD A,E
                        LD (PosMaximo),A
PasaAlSiguiente         INC IY
                        INC E
                        DJNZ BucleInterno

                        PUSH DE
                        LD D,(IX)                       ; Intercambiar el maximo y el elemento inicial de ese bucle
                        LD A,(Maximo)
                        LD HL,ListaNumeros
                        LD BC,(PosMaximo)
                        LD B,0
                        ADD HL,BC
                        LD (HL),D
                        LD (IX),A
                        INC IX
                        POP DE
                        INC D
                        LD A,LongitudLista
                        CP D
                        JP NZ BucleExterno

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


