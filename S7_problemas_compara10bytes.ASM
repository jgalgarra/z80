; Escribir un programa en ensamblador del Z80 que compare dos colecciones de bytes de 10 bytes cada una
; (coleccion1 y coleccion2). Si las dos colecciones son iguales (contienen los mismos bytes y en el
; mismo orden) el programa dejará un 1 en la dirección resultado. De no ser iguales, dejará un 0.

AppFilename             equ "S7_problemas_compara10bytes"

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry

coleccion1              defb $0F,$04,$05,$1E,$45,$AC,$2A,$15,$00,$12   ; Si cambiamos cualquier byte resultado sera 0
coleccion2              defb $0F,$04,$05,$1E,$45,$AC,$2A,$15,$00,$10
resultado               defb 1                                         ; Suponemos de partida que son iguales

AppEntry:                                        ; Para resolverlo recorreremos las dos listas con los
                                                 ; registros de indireccion y B como contador en sentido decreciente
                        LD IX,coleccion1         ; direccion de coleccion1 a IX
                        LD IY,coleccion2         ; direccion de coleccion2 a IY
                        LD B,10                  ; contador
Bucle:                  LD A,(IX)                ; Byte apuntado por IX (coleccion1) a IX
                        LD C,A                   ; Lo llevamos a C
                        LD A,(IY)                ; Ahora cargamos el byte apuntado por IY  (coleccion2)
                        CP C                     ; Comparamos con el de coleccion 1 almacenado en C
                        JP NZ, Distintos         ; Con que dos bytes difieran el resultado debe ser 0
                        INC IX                   ; Si son iguales apuntamos a los siguientes bytes
                        INC IY
                        DJNZ Bucle               ; Mientras no hayamos llegado a 10 bytes volvemos al bucle
                        LD A,1                   ; Hemos terminado el bucle y todos eran iguales
                        LD (resultado),A
                        RET                      ; Final del programa, sale por aqui si son iguales
Distintos               LD A,0
                        LD (resultado),A
                        RET                      ; Fin del programa, sale por aqui si son distintos


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


