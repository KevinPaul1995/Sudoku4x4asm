
; Descripci?n: Pr?ctica 2b SUDOKU 4x4

;diferencia directivas y mnem?nicos

;directiva equ (Equivalence) es definir valores de etiquetas en c: #define a 5;
.model small

NUM_VECTORES EQU 4 ; AQUI INDICAMOS EL NUMERO DE VECTORES QUE VAMOS A ANALIZAR 
NUM_COMPONENTES EQU 4 ; INDICAMOS EL NUMERO DE ELEMENTOS EN CADA VECTOR 
NUM_TOTAL_ELEMENTOS EQU NUM_VECTORES * NUM_COMPONENTES ; NUMERO TOTAL DE ELEMENTOS SUMANDO TODOS LOS VECTORES 
NUM_MAXIMO_DE_COMPONENTE EQU 4 ; LIMITE SUPERIOR QUE PUEDEN TOMAR LOS ELEMENTOS 
NUM_MINIMO_DE_COMPONENTE EQU 1 ; LIMITE INFERIOR QUE PUEDEN TOMAR LOS ELEMENTOS    

; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
                
vector1            db 0,0,0,0
vector2            db 0,0,0,0
vector3            db 0,0,0,0
vector4            db 0,0,0,0

; vectores primos, donde se almacenan los datos ingresados por teclado
vector1p           db 10 dup (0)
vector2p           db 10 dup (0)
vector3p           db 10 dup (0)
vector4p           db 10 dup (0)

imprimirFilasSI DB "FILAS VALIDAS", 13, 10, '$'  
imprimirFilasNO DB "FILAS NO VALIDAS", 13, 10, '$'  
imprimirColumnasSI DB "COLUMNAS VALIDAS", 13, 10, '$'  
imprimirColumnasNO DB "COLUMNAS NO VALIDAS", 13, 10, '$'  
imprimirRegionesSI DB "REGIONES VALIDAS $"  
imprimirRegionesNO DB "REGIONES NO VALIDAS $" 
pedirVector        db 13,10,"INTRODUZCA UN VECTOR (EJ.: 1 2 3 4)  ",'$' 
imprimirVectorNO   db 13,10,"VECTOR INCORRECTO ",'$' 



DATOS ENDS    

;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
 
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0 
PILA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO EXTRA 
EXTRA SEGMENT 
EXTRA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
 ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA 
 ;COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
  INICIO PROC 
   ; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR 
 
 MOV AX, DATOS 
 MOV DS, AX 
 MOV AX, PILA 
 MOV SS, AX 
 MOV AX, EXTRA 
 MOV ES, AX 
 MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO 
 mov ah, 09h;salida de cadena

 call        ingresa_matriz
 call        imprime_matriz     
 call        comprueba_filas
 call        comprueba_columnas
 call        comprueba_regiones
 mov         AX, 4C00h           ; Fin de programa
 int         21h  
INICIO endp
;-----------------------------------------------------------------------------------------------
ingresa_matriz proc near   
 
 ;1 
 mov        dx, offset pedirVector ; DX : offset al inicio del texto a imprimir
 mov        ah,9                ; imprime chars hasta encontrar un salto de linea
 int        21h                 ; llama a la interrupcion del sistema    
 MOV        AH,0AH              ; Comando para pedir datos por teclado
 MOV        DX, offset vector1p ; apunta al vector 1 primo
 MOV        vector1p[0],8       ; limita el tamaño de datos que puede ingresar el usuario 
 INT        21H 
 mov        dl,vector1p[1]      ; toma el tama del vector ingresadox        
 cmp        dx,7                ; compara el tama ingresado con 7 para ver si es correct d1_d2_d3_d4. 4 datos y 4 espacios= 7 datos
 jb         vectornovalido5     ; si es menos el vector no es válido  
  
 mov        si,1                ; Inicializa indices y contadores
 mov        cx,3 
 cmp        cx,0                ; pone bandera de z en cero
 cuentaespaciosv51:  
 add        si,2                ; se mueve en posciones de 2 en dos
 mov        dl,vector1p[si]     ; mueve los valores para ser evaluados a dl
 cmp        dx,32               ; compara el valor que debería ser un espacio con 32 que corresponde al Asci de espacio
 jz         esespacio51         ; si esque si es espacio continua
 jmp        vectornovalido5     ; si no ha ingresado un espacio entre dos numeros el vector no vale
 esespacio51: 
 loop       cuentaespaciosv51
 
 ;2
 mov        dx, offset pedirVector ; DX : offset al inicio del texto a imprimir
 mov        ah,9                ; imprime chars hasta encontrar un salto de linea
 int        21h                 ; llama a la interrupcion del sistema    
 MOV        AH,0AH              ; para pedir datos por teclado
 MOV        DX, offset vector2p ; apunta al vector dos primo
 MOV        vector2p[0],8       ; limita el tamaño de datos que puede ingresar el usuario
 INT        21H                 ; llama a la interrupción del sistema
 mov        dl,vector2p[di]     ; toma el tama del vector ingresadox||         
 cmp        dx,7                ; compara el tama ingresado con 7 para ver si es correct d1_d2_d3_d4. 4 datos y 4 espacios= 7 datos
 jb         vectornovalido5     ; si es menos el vector no es válido 
 
 mov        si,1                ; inicializa indices y contadores
 mov        cx,3 
 cmp        cx,0                ; pone bandera de z a 0
 cuentaespaciosv52:  
 add        si,2                ; salta en las posiciones de 2 en 2
 mov        dl,vector2p[si]     ; mueve a dl el valor a evaluar
 cmp        dx,32               ; compara con el char de espacio que corresponde a 32
 jz         esespacio52         ; si es espacio continua con el programa
 jmp        vectornovalido5     ; si no ha ingresado un espacio entre dos numeros el vector no vale
 esespacio52: 
 loop       cuentaespaciosv52
 jmp        pidev53

 ; la etiqueta vector no valido se encuentra aquí para no ocasionar saltos demasiado largos 
 ;---------------------------------------------------------------------
 vectornovalido5:  
 mov        dx, offset imprimirVectorNO ; apunta al texto "Vector no valido"
 mov        ah,9                ; Para imprimir una cadena
 int        21h                 ; Llama a la interrupción del sistema
 mov        AX, 4C00h           ; Fin de programa
 int        21h                 ; Llama a la interrupción del sistema
 fin5:                          ; fin del proc     
 ret                            ; vuelve a donde se llamó la subrutina
 ;---------------------------------------------------------------------
 


 ;3
 pidev53:
 mov        dx, offset pedirVector ; DX : offset al inicio del texto a imprimir
 mov        ah,9                ; imprime chars hasta encontrar un salto de linea
 int        21h                 ; llama a la interrupcion del sistema    
 MOV        AH,0AH              ; para pedir entrada por teclad  
 MOV        DX, offset vector3p ; apunta al vector 3 primo
 MOV        vector3p[0],8       ; limita el tamaño de datos que puede ingresar el usuario 
 INT        21h                 ; llama a interrupción del sistema
 mov        dl,vector3p[1]      ; toma el tama del vector ingresadox||         
 cmp        dx,7                ; compara el tama ingresado con 7 para ver si es correct d1_d2_d3_d4. 4 datos y 4 espacios= 7 datos
 jb         vectornovalido5     ; si es menos el vector no es válido 
 
 mov        si,1                ; inicializa indices y contadores
 mov        cx,3 
 cmp        cx,0                ; Pone bandera de z a 0
 cuentaespaciosv53:  
 add        si,2                ; evalua las posiciones de 2 en dos
 mov        dl,vector3p[si]     ; mueve a dl el valor a evaluar
 cmp        dx,32               ; compara con el char de espacio que corresponde a 32
 jz         esespacio53         ; si es espacio continua con el programa
 jmp        vectornovalido5     ; si no ha ingresado un espacio entre dos numeros el vector no vale
 esespacio53: 
 loop       cuentaespaciosv53
 
 ;4
 mov        dx, offset pedirVector ; DX : offset al inicio del texto a imprimir
 mov        ah,9                ; imprime chars hasta encontrar un salto de linea
 int        21h                 ; llama a la interrupcion del sistema    
 MOV        AH,0AH   
 MOV        DX, offset vector4p;
 MOV        vector4p[0],8       ; limita el tamaño de datos que puede ingresar el usuario 
 INT        21H 
 mov        dl,vector4p[1]      ; toma el tama del vector ingresadox||         
 cmp        dx,7                ; compara el tama ingresado con 7 para ver si es correct d1_d2_d3_d4. 4 datos y 4 espacios= 7 datos
 jb         vectornovalido5     ; si es menos el vector no es válido           
 
 mov        si,1                ; inicializa indices y contadores
 mov        cx,3 
 cmp        cx,0                ; pone bandera de z a 0
 cuentaespaciosv54:  
 add        si,2                ; se mueve en las posiciones de dos en dos
 mov        dl,vector4p[si]     ; mueve a dl el valor que será evaluado
 cmp        dx,32               ; compara con el char de espacio que corresponde a 32
 jz         esespacio54         ; si esque sí es espacio continua con el programa
 jmp        vectornovalido5     ; si no es espacio ha ingresado dos valores juntos y eso invalida el vector
 esespacio54:                   ; si es espacio continua con el programa
 loop       cuentaespaciosv54 
 
 ;imprime salto de linea y CR  
 mov        cx,2                ; inicia un contador para hacer dos ciclos e imprimir dos saltos de línea
 impsaltolin5:
 mov        ah,2                ; para imprimir solamente un valor
 mov        dl,10               ; muevo salto de linea a dl
 int        21h                 ; interrupcion del sistema operativo
 mov        dl,13               ; imprime un CR 
 int        21h                 ; interrupcion del sistema operativo
 loop       impsaltolin5                                              
 
 ;lleno vectores principales con el contenido de vectores primos
 mov        si,0                ; inicializo el indice en 0 para apuntar al vector 0
 mov        di,2                ; di apunta a los datos ingresados por teclado
 mov        cx,4                ; contador de 4 ciclos para mover 4 datos
 llenavector5:
 mov        bl,vector1p [di]    ; Muevo a bl un dato ingresado por teclado
 sub        bl,48               ; Le resto 48 para transformarlo en número
 mov        [si],bl             ; muevo el valor numérico a dónde me indica SI
 inc        si                  ; Apunta a la siguiente posición para el siguiente ciclo
 add        di,2                ; Apunta al siguiente valor ingresado por teclado
 loop       llenavector5 
 
 mov        di,2                ; di apunta a los datos ingresados por teclado
 mov        cx,4                ; Contador de 4 ciclos para mover 4 datos
 llenavector52:
 mov        bl,vector2p [di]    ; Muevo a bl un dato ingresado por teclado
 sub        bl,48               ; Le resto 48 para transformarlo en número
 mov        [si],bl             ; muevo el valor numérico a dónde me indica SI  
 inc        si                  ; Apunta a la siguiente posición para el siguiente ciclo
 add        di,2                ; Apunta al siguiente valor ingresado por teclado
 loop       llenavector52 
 
 mov        di,2                ; di apunta a los datos ingresados por teclado
 mov        cx,4                ; Contador de 4 ciclos para mover 4 datos
 llenavector53:
 mov        bl,vector3p [di]    ; Muevo el valor numérico a dónde me indica SI  
 sub        bl,48               ; Le resto 48 para transformarlo en número
 mov        [si],bl             ; Muevo el valor numérico a dónde me indica SI    
 inc        si                  ; Apunta a la siguiente posición para el siguiente ciclo
 add        di,2                ; Apunta al siguiente valor ingresado por teclado
 loop       llenavector53
 
 mov        di,2                ; di apunta a los datos ingresados por teclado
 mov        cx,4                ; Contador de 4 ciclos para mover 4 datos
 llenavector54:
 mov        bl,vector4p [di]    ; Muevo el valor numérico a dónde me indica SI 
 sub        bl,48               ; Le resto 48 para transformarlo en número
 mov        [si],bl             ; Muevo el valor numérico a dónde me indica SI  
 inc        si                  ; Apunta a la siguiente posición para el siguiente ciclo
 add        di,2                ; Apunta al siguiente valor ingresado por teclado
 loop       llenavector54  
 jmp        fin5
     

 ingresa_matriz endp
 imprime_matriz proc near
 mov         di, 0               ; inicializamos el indice di en 0
 mov         bx, NUM_COMPONENTES ; para comparar cuando se ha terminado de imprimir la fila
 memuevoenfila:
 mov        ah, 2               ; Numero de funcion = 2 (imprimir char)
 mov        dl, [di]            ; dl= lo que se va a imprimir  
 inc        di                  ; para en el siguiente ciclo tomar la siguiente posicion

 ;imprime un elemento
 add        dl,48               ; se suma 48 para transformar char a num
 int        21h                 ; interrupcion para imprimir 

 ;imprime un espacio            
 mov        dl,32               ; muevo el char espacio a dl
 int        21h                 ; imprime espacio
        
 ;comparar para ver si se acabo de imprimir una linea
 cmp        di,bx               ; si el índice se encuentra al final de la fila              
 jz         cambiafila          ; si la bandera z se activa salta a cambia fila
 jmp        memuevoenfila       ; imprime la siguiente posicion de la fila
 
 cambiafila: 
 cmp        bx,NUM_TOTAL_ELEMENTOS ; para ver si he impreso todos los elementos
 jz         fin                 ; se activa cuando bx es numero total de elementos  
 add        bx,NUM_COMPONENTES  ; actualiza el valor para cambiar de fila

 ;imprime salto de linea y CR 
 mov        ah,2                ; para imprimir solamente un valor
 mov        dl,10               ; muevo salto de linea a dl
 int        21h                 ; interrupcion del sistema operativo
 mov        dl,13               ; imprime un CR 
 int        21h                 ; interrupcion del sistema operativo
 jmp        memuevoenfila       ; vuelvo a imprimir una fila    
               
 fin:       
 ret
imprime_matriz endp
;------------------------------------------------------------------------------------------------
comprueba_filas proc near

 evaluafila2: 
 mov        cx, NUM_COMPONENTES ; loop ciclo se define con cx 
 cmp        cx,0                ; pone la bandera Z en cero 
 mov        ax,0                ; para contar repeticiones
 mov        di,0                ; indice en 0 
 mov        bx,0                ; valor de offset 

 ciclo21:
 mov        si,0                ; Iniciar el indice 2 en el primer elemento de la primera columna
 mov        al,vector1[di]      ; al = a la primera posición del primer vector; indice 1
 cmp        al,1                ; para ver si es menor a 1
 jb         filanovalida2       ; Salta si al es menor a 1 
 cmp        al,NUM_COMPONENTES  ; para ver si es mayor al número de elementos
 ja         filanovalida2       ; salta si es mayor al número de componentes
 mov        dh,cl               ; para mantener el valor de cx de ciclo21
 mov        cx,NUM_COMPONENTES  ; loop ciclo se define con cx

 ciclo22:   
 cmp        al,[bx][si]         ; compara el indice 1 con el indice 2  
 jz         serepite2           ; si los dos valores son iguales
 inc        si                  ; aumenta el indice 2 
 loop       ciclo22             ; acaba de comparar indice 1 con todos indice 2
 finciclo22:
 mov        ah,0                ; si no hay dos repeticiones reinicia el contador de repeticiones
 inc        di                  ; cambia el indice de di que asigana el valor de al
 mov        cl,dh               ; devuelvo el valor del contador
 loop       ciclo21             ; ciclo de evaluar toda una fila 
 add        bx, NUM_COMPONENTES ; para continuar evaluando desde la siguiente fila
 cmp        bx,NUM_TOTAL_ELEMENTOS ; para ver si ya ha terminado de evaluar toda la matriz
 jz         fin2                ; Termina la subrutina
 mov        cx, NUM_COMPONENTES ; Reinicio el valor de un contador 
 jmp        ciclo21             ; Inicia un nuevo ciclo de barrido
 
 serepite2:                     ; contador de repeticiones
 inc        ah                  ; incrementa la variable de repeticiones                                  
 cmp        ah,0                ; pone la bandera Z en cero (se desactiva)
 cmp        ah,2                ; evalua si se han repetido dos numeros
 jz         filanovalida2       ; muestra el mensaje de fila no valida
 cmp        si,NUM_COMPONENTES-1; pregunta si se encuentra en la ultima posición de la fila                
 jz         finciclo22          ; pasa a la siguiente fila
 inc        si                  ; aumenta el indice 2  
 cmp        cx,1                ; si ya se encuentra en la ultima posición de la fila
 jz         finciclo22          ; pasa a la siguiente fila
 dec        cx 
 cmp        ah,0                ; pone la bandera Z en cero
 jmp        ciclo22             ; Vuelvo a la evaluacion de filas

 filanovalida2:  
 mov        ah,2                ; ah igual a 2 para imprimir un char
 mov        dl,10               ; para imprimir salto de línea
 int        21h                 ; llama a la interrupcióon del sistema
 mov        dl,13               ; carga CR (para iniciar a escribir al principio de línea)
 int        21h                 ; llama  a la interrupcióon del sistema
 mov        dx, offset imprimirFilasNO ; DX : offset al inicio del texto a imprimir
 mov        ah,9                ; imprime chars hasta encontrar un salto de linea
 int        21h                 ; llama a la interrupción del sistema
 ret                            ; vuelvo a donde se ha llamado a la subrutina
 
 fin2:
 mov        ah,2                ; ah igual a 2 para imprimir un char
 mov        dl,10               ; para imprimir salto de línea
 int        21h                 ; llama a la interrupcióon del sistema
 mov        dl,13               ; carga CR (para iniciar a escribir al principio de línea)
 int        21h                 ; llama  a la interrupcióon del sistema
 mov        dx, offset imprimirFilasSI ; DX : offset al inicio del texto a imprimir
 mov        ah,9                ; imprime chars hasta encontrar un salto de linea
 int        21h                 ; llama a la interrupción del sistema
 ret                            ; vuelvo a donde se ha llamado a la subrutina
comprueba_filas endp
;-----------------------------     COMPRUEBA COLUMNAS  ------------------------------------------
;------------------------------------------------------------------------------------------------
comprueba_columnas proc near

 evaluacolumna3: 
 mov        cx, NUM_COMPONENTES ; loop ciclo se define con cx 
 cmp        cx,0                ; pone la bandera Z en cero 
 mov        ax,0                ; para contar repeticiones
 mov        di,0                ; indice en 0 
 mov        bx,0                ; valor de offset  
 ciclo31:
 mov        si,0                ; Iniciar el indice 2 en el primer elemento de la primera columna
 mov        al,vector1[di]      ; al = a la primera posición del primer vector; indice 1
 cmp        al,1                ; para ver si es menor a 1
 jb         columnanovalida3    ; Salta si al es menor a 1 
 cmp        al,NUM_COMPONENTES  ; para ver si es mayor al número de elementos
 ja         columnanovalida3    ; salta si es mayor al número de componentes
 mov        dh,cl               ; para mantener el valor de cx de ciclo21
 mov        cx,NUM_COMPONENTES  ; loop ciclo se define con cx

 ciclo32:  
 cmp        al,[bx][si]         ; compara el indice 1 con el indice 2  
 jz         serepite3           ; si los dos valores son iguales
 add        si, NUM_COMPONENTES ; aumenta el indice 2 
 loop       ciclo32             ; acaba de comparar indice 1 con todos indice 2
 finciclo32:
 mov        ah,0                ; si no hay dos repeticiones reinicia el contador de repeticiones
 inc        di                  ; cambia el elemento evaluado, el indice 1
 mov        cl,dh               ; devuelvo el valor del contador
 inc        bx              ; para continuar evaluando desde la siguiente columna
 loop       ciclo31             ; ciclo de evaluar toda una fila 
 cmp        di,NUM_TOTAL_ELEMENTOS  ; para ver si ya ha terminado de evaluar toda la matriz
 jz         fin3
 mov        cx, NUM_COMPONENTES 
 jmp        ciclo31
 
 serepite3:                     
 inc        ah                  ; incrementa la variable de repeticiones                                  
 cmp        ah,0                ; pone la bandera Z en cero
 cmp        ah,2                ; evalua si se han repetido dos numeros
 jz         columnanovalida3    ; muestra el mensaje de fila no valida
 cmp        si,NUM_TOTAL_ELEMENTOS-NUM_COMPONENTES ; si me encuentro en la ultima fila                
 jae        finciclo32          ; salta si es mayor o igual         
 add        si,NUM_COMPONENTES  ; aumenta el indice 2  
 cmp        cx,1                ; si ya es la ultima repeticion
 jz         finciclo32          ; pasa a la siguiente fila               
 cmp        ah,0                ; pone la bandera Z en cero
 jmp        ciclo32             ; Vuelvo a la evaluacion de columnas
 
 columnanovalida3:
 mov        dx, offset imprimirColumnasNO
 mov        ah,9
 int        21h  
 ret
 
 fin3:
 mov        dx, offset imprimirColumnasSI
 mov        ah, 9
 int        21h  
 ret

comprueba_columnas endp
                      
comprueba_regiones proc near
 mov        di,0                ; indice de diag principales
 mov        si,1                ; indice de diag secundarias 
 
 ;diagonales principales
 diagprincipales4:
 mov        bx,0                ; indice de columnas
 mov        cx,2                ; valor del contador de ciclos
 
 ciclo41:
 cmp        cl,0                ; pongo bandera z=0  
 mov        al,vector1[bx][di]  ; muevo a al el primer valor de la matriz  
 add        bx,NUM_COMPONENTES  ; muevo el indicec a la fila de abajo
 cmp        al,vector1[bx+1][di]; compara al con el valor de la siguiente fila más 1
 jz         regionnovalida4     ; si los valores se repiten                                    
 add        bx,NUM_COMPONENTES  ; posiciona bx en la siguiente fila
 loop       ciclo41   
 add        di,2                ; se mueve el siguiente cuadrante (region)
 cmp        di,0                ; desactiva z
 cmp        di,4                ; si ya seevaluaron todas las diag princ
 jz         diagsecundarias4    ; Pasa a evaluar diagonales secundarias
 jmp        diagprincipales4    ; Evalua las siguientes regiones
  
 ;diagonales secuandarias
 diagsecundarias4:
 mov        bx,0                ; indice de columnas
 mov        cx,2                ; Valor del contador de ciclos
 
 ciclo42:
 cmp        cl,0                ; pongo bandera z=0  
 mov        al,vector1[bx][si]  ; muevo a al el primer valor de la matriz  
 add        bx,NUM_COMPONENTES  ; muevo el indicec a la fila de abajo
 cmp        al,vector1[bx][si-1]; compara con el elemento de la diagonal secundaria correspondiente
 jz         regionnovalida4     ; si los valores se han repetido                                  
 add        bx,NUM_COMPONENTES  ; Mueve bx para apuntar a la siguiente fila
 loop       ciclo42             
 add        si,2                ; Se mueve a la siguiente region 
 cmp        si,0                ; desactiva z
 cmp        si,5                ; si ya seevaluaron todas las diag princ
 jz         fin4                ; Fin de la subrutina
 jmp        diagsecundarias4    ; Evalua las siguientes regiones 


 regionnovalida4:  
 mov        dx, offset imprimirRegionesNO ; muestra el mensaje de regiones no validas
 mov        ah,9                ; Imprime chars hasta encontrar un salto de linea
 int        21h                 ; llama a la interrupción del sistema
 ret                            ; Retorna a donde se ha llamado a la subrutina
 
 fin4:
 mov        dx, offset imprimirRegionesSI ; Muestra el mensaje de region válida
 mov        ah,9                ; Imprime chars hasta encontrar un salto de linea
 int        21h                 ; Llama a la interrupción del sistema
 ret                            ; Retorna a donde se ha llamado a la subrutina
comprueba_regiones endp
CODE ENDS          
END INICIO
end


         
