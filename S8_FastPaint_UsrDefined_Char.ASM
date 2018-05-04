; Programa para imprimir en memoria de pantalla un caracter definido por el usuario.
; La posicion se indica mediante Fila (0 a 21) y Columna (0 a 31)

AppFilename             equ "S8_FastPaint_UsrDefined_Char"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry

TercioSuperior          equ  $4000                      ; direccion base de las filas 0 a 7
TercioMedio             equ  $4800                      ; direccion base de las filas 8 a 15
TercioInferior          equ  $5100                      ; direccion base de las fila 16 a 21
NumFila                 defb 21                          ; Fila en la que se imprime el caracter
NumColumna              defb 15                          ; Columna en la que se imprime el caracter
DirTercio               defw $0000                      ; direccion base en la memoria del tercio de pantalla
OffsetFila              defb $0                         ;
DirBaseCaracter         defw $0000                      ; direccion base en la memoria de pantalla del caracter
Cuadradito              defb $7F,$41,$41,$41,$41,$41,$7F,$00
Parrilla                defb $41,$7F,$41,$7F,$41,$7F,$41,$7F
WhiteSnow               defb $00,$00,$00,$00,$00,$00,$00,$00
DirCaracterUsr          defw 0                          ; direccion de memoria donde empieza la definicion del caracter



AppEntry                call CalcDirTercio                            ; Replace these lines with your code
                        call CalcOffSetFila             ;
                        call CalcByteDir                ;
                        ld HL,Cuadradito                ; Guardar en HL la direccion de comienzo del caracter definido
                        ld (DirCaracterUsr),HL             ; Se la pasamos a la rutina por DirCaracter
                        call PaintChar
CalcDirTercio:                                           ; Calcula la direccion en memoria de pantalla del tercio
                                                         ; al que pertenece la fila
                        ld A,(NumFila)                   ;
                        cp 16                            ;
                        jp nc, TInf                      ; 15 < NumFila <= 22
                        cp 8
                        jp nc, TMedio                    ; 7 < NumFila <=15
TSup                    LD HL,TercioSuperior             ;
                        LD (DirTercio),HL
                        RET
TMedio                  LD HL,TercioMedio                ;
                        LD (DirTercio),HL
                        RET
TInf                    LD HL,TercioInferior             ;
                        LD (DirTercio),HL
                        RET

CalcOffSetFila:                                          ; NumFila*$20 con NumFila entre 0 y 7
                        XOR A
                        LD (OffsetFila),A
                        LD A,(NumFila)                   ;
                        AND A,$07                        ; Nos quedamos con los tres últimos bits del número de fila
                        LD L,A                           ;
                        LD H,0                           ;
                                                         ; Multiplicar por $20 equivale a desplazar HL 5 bits a la izquierda
                        LD B,5                           ;
Bucle                   RLC L
                        DJNZ Bucle
                        LD (OffsetFila),HL
                        RET

CalcByteDir:                                             ; Calcula la direccion en memoria de pantalla del byte base
                        LD HL,(DirTercio)
                        LD DE,(OffsetFila)
                        LD D,0                           ; Solo hay que quedarse con el byte de menor peso, que es D
                        ADD HL,DE
                        LD DE,(NumColumna)
                        ADD HL,DE
                        LD (DirBaseCaracter),HL
                        RET

PaintChar:                                               ; Pinta el caracter
                        LD HL,(DirBaseCaracter)          ;
                        LD IX,(DirCaracterUsr)
                        LD A,(IX)                       ;
                        LD (HL),A                       ; Esto finalmente pinta en memoria
                        LD B,6
Otrasfilas              LD DE,$100
                        ADD HL,DE
                        INC IX
                        LD A,(IX)
                        LD (HL),A
                        DJNZ Otrasfilas
                        RET

Delay:                  LD B,20
Espera                  HALT
                        DJNZ Espera
                        RET


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



BucleBobo               LD A,1
                        LD (NumFila),A
                        LD A,15
                        LD (NumColumna),A
                        call CalcDirTercio                            ; Replace these lines with your code
                        call CalcOffSetFila             ;
                        call CalcByteDir                ;
                        ld HL,Parrilla                ; Guardar en HL la direccion de comienzo del caracter definido
                        ld (DirCaracterUsr),HL             ; Se la pasamos a la rutina por DirCaracter
                        call PaintChar
                        call Delay
                        LD A,1
                        LD (NumFila),A
                        LD A,15
                        LD (NumColumna),A
                        call CalcDirTercio                            ; Replace these lines with your code
                        call CalcOffSetFila             ;
                        call CalcByteDir                ;
                        ld HL,WhiteSnow                 ; Guardar en HL la direccion de comienzo del caracter definido
                        ld (DirCaracterUsr),HL             ; Se la pasamos a la rutina por DirCaracter
                        call PaintChar
                        call Delay
                        jp BucleBobo
                        ret

