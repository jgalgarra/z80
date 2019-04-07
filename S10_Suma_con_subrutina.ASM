; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

s1                      defb 0
s2                      defb 0
resultado               defb 0
posx                    defb 0
saltox                  defb 1

AppEntry                LD A,12
                        LD (posx),A
                        LD (s1),A
                        LD A,(saltox)
                        LD (s2),A
                        CALL Suma
                        LD A,(resultado)
                        LD (posx),A
                        LD (s1),A
                        LD A,(saltox)
                        LD (s2),A
                        CALL Suma
                        LD (posx),A

Para                    halt                            ; Replace these lines with your code
                        jp Para                     ;


Suma                    LD A,(s1)
                        LD DE,(s2)
                        ADD E
                        LD (resultado),A
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


