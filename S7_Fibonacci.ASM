; Implementar la serie de Fibonacci mientras la cifra obtenida sea menor que 200.
; guardar los resultados en la variable FiboNums, que inicializamos como una zona de 15 bytes
; El numero de Fibonacci(n) es igual a la suma de Fibonacci(n-2) + Fibonacci(n-1)
; Por definición Fibnacci(0)=1 y Fibonacci(1)=1
; Usaremos el registro IX como base de la indireccion

AppFilename             equ "S7_Fibonacci"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application
                        jp AppEntry

FiboNumbers             defb 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0

AppEntry                LD IX,FiboNumbers+2             ; Inicializamos el puntero al primer numero no relleno
Bucle                   LD A,(IX-2)                     ; Cargamos Fibonacci(n-2)
                        LD D,A                          ; Lo almacenamos temporalmente en D
                        LD A,(IX-1)                     ; Cargamos Fibonacci(n-1)
                        ADD D                           ; Ahora ya tenemos la suma de los dos numeros en A
                        CP 200                          ; Comparamos con 200
                        JP NC, Para                     ; Si A >= 200 el programa termina
                        LD (IX),A                       ; Guardamos Fibonacci(n) en FiboNumbers
                        INC IX                          ; Apuntamos al siguiente numero no relleno
                        JP Bucle                     ; Repetimos el bucle
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


