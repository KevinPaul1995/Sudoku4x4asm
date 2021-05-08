
;directiva equ (Equivalence) es definir valores de etiquetas en c: #define a 5;
.model small

NUM_VECTORES EQU 4 ; AQUI INDICAMOS EL NUMERO DE VECTORES QUE VAMOS A ANALIZAR 
NUM_COMPONENTES EQU 4 ; INDICAMOS EL NUMERO DE ELEMENTOS EN CADA VECTOR 
NUM_TOTAL_ELEMENTOS EQU NUM_VECTORES * NUM_COMPONENTES ; NUMERO TOTAL DE ELEMENTOS SUMANDO TODOS LOS VECTORES 
NUM_MAXIMO_DE_COMPONENTE EQU 4 ; LIMITE SUPERIOR QUE PUEDEN TOMAR LOS ELEMENTOS 
NUM_MINIMO_DE_COMPONENTE EQU 1 ; LIMITE INFERIOR QUE PUEDEN TOMAR LOS ELEMENTOS    

; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
                

;vector1 db 1,2,3,4
;vector2 db 5,6,7,8
;vector3 db 9,0,1,2
;vector4 db 3,4,5,6      
                
vector1 db 1,2,3,4
vector2 db 2,1,4,3
vector3 db 3,4,1,2
vector4 db 4,3,2,1    
;    

 ; vector1 db 1,2,3,4
 ; vector2 db 3,4,1,2
 ; vector3 db 2,1,4,3
 ; vector4 db 4,3,2,1

conversionASCI DB "       ", 13, 10, '$' ; CADENA DONDE SE VAN A GUARDAR LAS  CONVERSIONES DE LOS NUMEROS 
 
imprimirFilasSI DB "FILAS VALIDAS", 13, 10, '$' 
 
imprimirFilasNO DB "FILAS NO VALIDAS", 13, 10, '$' 
 
imprimirColumnasSI DB "COLUMNAS VALIDAS", 13, 10, '$' 
 
imprimirColumnasNO DB "COLUMNAS NO VALIDAS", 13, 10, '$' 
 
imprimirRegionesSI DB "REGIONES VALIDAS $" 
 
imprimirRegionesNO DB "REGIONES NO VALIDAS $" 
 
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
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
INICIO PROC 
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR 
 
MOV AX, DATOS 
MOV DS, AX 
MOV AX, PILA 
MOV SS, AX 
MOV AX, EXTRA 
MOV ES, AX 
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO 

 call        imprime_matriz
 call        comprueba_filas
 call        comprueba_columnas
 call        comprueba_regiones
 mov         AX, 4C00h           ; Fin de programa
 int         21h  

INICIO endp
;-----------------------------------------------------------------------------------------------
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
 mov        ah,9
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

         
