; Programa para imprimir en pantalla.

AppFilename             equ "S4_char_position"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry               ld   a, 2                ; Abrir el canal 2
                       call CHANOPEN            ; La rutina 5663 de la ROM indica al procesador que hay que
                                                ; escribir en la pantalla
                        ld   de,olakease ; address of string
                        ld   bc,33  ; length of string to print
                        ;call PRINT           ; print our string
                        ld   de,olakease2 ; address of string
                        ld   bc,33  ; length of string to print
                        ;call PRINT           ; print our string
                        ld   de, pelota
                        ld   bc, 4
                        call PRINT
                        call Delay
Bucle                   LD A,(pelota+1)
                        LD (blanco+1),A
                        LD A,(pelota+2)
                        LD (blanco+2),A
                        ld   de, blanco
                        ld   bc, 4
                        call PRINT

                        LD A,(pelota+1)
                        INC A

                        CP 22
                        JP NZ PelotaAbajo
                        LD A,1
PelotaAbajo             LD (pelota+1),A
                        LD A,(pelota+2)
                        INC A
                        LD (pelota+2),A
                        ld   de, pelota
                        ld   bc, 4
                        call PRINT
                        call Delay
                        JP Bucle

Para                    HALT
                        JP Para

Delay                   PUSH BC
                        LD B,10
Espera                  HALT
                        DJNZ Espera
                        POP BC
                        RET



CHANOPEN               equ  5633
PRINT                  equ  8252


NewLine                defb 13

olakease             defb 22,10,1,"**ola ke ase?*********************";

olakease2             defb 22,5,1,"  ola ke ase tu? No hago na       ";

pelota               defb 22,1,1,"o"
blanco               defb 22,1,1," "

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



