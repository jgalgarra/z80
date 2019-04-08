; Dada una colección de valores numéricos, de tamaño byte, almacenados a partir
; de la dirección de memoria DATOS, programar una subrutina que rote dichos valores,
; guardando cada uno de ellos en la dirección siguiente a donde esté guardado ahora
; (el valor almacenado en la dirección más alta pasará a estar almacenado en la
;  dirección más baja). Ejemplo:
;       Datos iniciales:        8,7,2,12,2,5,8,1,0,9
;       Datos tras la ejecución de la subrutina:           9,8,7,2,12,2,5,8,1,0

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

DATOS                   defb  8,7,2,12,2,5,8,1,0,9
DATOS_AUX               defs  10
AppEntry                LD IX,DATOS+9
                        LD B,9
                        LD HL,(IX)                      ; Guardamos el ultimo numero en L
Bucle                   LD A,(IX-1)
                        LD (IX),A
                        DEC IX
                        DJNZ Bucle
                        LD (IX),L
Para                    halt                            ; Replace these lines with your code
                        jp Para                    ;


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


