.data 
	infomenu: .asciiz "MENU: \n 1.Tabla Ordenada.\n 2.Ingreso de partidos.\n 3.Mostrar los 3 mejores.\n 4.Salir\n"
	msgopcion: .asciiz "Ingrese opción: "
	archivo: .asciiz "tabla.txt"
	buffer: .space 1024
	bufferOp: .space 4
	bufferWord: .asciiz "Aqui van los 3 mejores"
	encabezado: .asciiz "-----------------------------------------------\n"
	pie: .asciiz "-----------------------------------------------\n\n\n"
	mensajeSalida: .asciiz "------Este es un mensaje de salida-------"
	array: .space 4
	nombretmp: .space 16
	arrayNombres: .space 256
	matriz: .space 512
	indices: .word 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	matrizPuntajes: .space 64

.globl main
.text

main:
    jal  añadirValores
fin:
jal matrizPun
jal argsort
jal tablaOrdenada

li $v0, 10
syscall


	argsort:
		 la  $t0, matrizPuntajes   # Copy the base address of your array into $t1
		 add $t0, $t0, 64  # 4 bytes per int * 10 ints = 40 bytes     
		 la  $s0, indices   # Copy the base address of your array into $t1
		 add $s0, $s0, 64    # 4 bytes per int * 10 ints = 40 bytes                           
		outterLoop:             # Used to determine when we are done iterating over the Array
		    add $t1, $0, $0     # $t1 holds a flag to determine when the list is sorted
		    la  $a0, matrizPuntajes     # Set $a0 to the base address of the Array
		    la  $a1, indices      # Set $a0 to the base address of the Array
		innerLoop:                  # The inner loop will iterate over the Array checking if a swap is needed
		    lb  $t2, 0($a0)         # sets $t0 to the current element in array
		    lb  $t3, 4($a0)         # sets $t1 to the next element in array
		    lw  $s2, 0($a1)         # sets $t0 to the current element in array
		    lw  $s3, 4($a1)         # sets $t1 to the next element in array
		    slt $t5, $t2, $t3       # $t5 = 1 if $t0 < $t1
		    beq $t5, $0, continue   # if $t5 = 1, then swap them
		    add $t1, $0, 1          # if we need to swap, we need to check the list again
		    sb  $t2, 4($a0)         # store the greater numbers contents in the higher position in array (swap)
		    sb  $t3, 0($a0)         # store the lesser numbers contents in the lower position in array (swap)
		    sw  $s2, 4($a1)         # store the greater numbers contents in the higher position in array (swap)
		    sw  $s3, 0($a1)         # store the lesser numbers contents in the lower position in array (swap)
		continue:
		    addi $a0, $a0, 4          # advance the array to start at the next location from last time
		     addi $a1, $a1, 4           # advance the array to start at the next location from last time
		    bne  $a0, $t0, innerLoop    # If $a0 != the end of Array, jump back to innerLoop
		    bne  $t1, $0, outterLoop    # $t1 = 1, another pass is needed, jump back to outterLoop

		jr $ra


	tablaOrdenada:
		la $s0 , indices
		li $t2 , 0 ## contador de valores indices
		li $t4 , 0 ## contador de valores de fila
		li $s4 , 32 
		li $t8 , 16
		loopTabla:
		add $t0 , $t2, $s0
		lb $t6 , 0($t0)
		mul $t3 , $s4, $t6
		la $s1 , matriz
		add $s3 , $s1, $t3
		
		la $s7 , arrayNombres
		mul $t3 , $t8, $t6
		add $t5 , $s7 , $t3
		li $v0, 4
		la $a0 , 0($t5)
		syscall 
		li      $a0, 44
		li      $v0, 11  
		syscall
		
		loopImprimir:
		add $t5 , $s3 , $t4

		li $v0, 1
		lb $a0 , 0($t5)
		syscall  
		li      $a0, 44
		li      $v0, 11  
		syscall
		addi $t4 ,$t4,4
		beq $t4 , 32 , salirImprimir
		j loopImprimir
		
		salirImprimir:
		li $t4 , 0 ## contador de valores de fila
		li      $a0, 10
		li      $v0, 11  
		syscall
		addi $t2 ,$t2,4
		beq $t2 ,40, salirOrdenar
		j loopTabla
		
		salirOrdenar:
		jr $ra
		
		
	matrizPun:
		la $s0 , matriz
		la $s1 , matrizPuntajes
		li $t2 , 0 # contador de bytes hasta 64
		li $t3 , 0 # contador de bytes hsata 512
		loopPunt:
		add $t4, $t3 , $s0 ## posicion matriz
		add $t5 , $t2 , $s1 ## posicion matriz puntajes
		lb $t6 , 0($t4)
		
		
		
		sb $t6 , 0($t5)
		addi $t2 ,$t2,4
		addi $t3 ,$t3,32
		beq $t3 ,512 , exit4
		j loopPunt
		exit4:
		jr $ra
		

	
	añadirValores:
		jal readFile
		li $s1 , -2 # desplazamiento
		li $t5 , 0 # desplazamineto nombres
		li $s6 , 0  # posicion en la fila
		li $s0 , 0 # contador de numero de filas
		li $t8,0
		li $t9 , 0 # contador de bytes nombres
		
		
		## Lazo para saltar la cabecera del archivo
		saltarCabecera:
		lb $t6 , buffer($s1)
		beq $t6,10 , exit1 # 10 codigo ascii de salto de linea
		addi $s1 , $s1 ,1
		j saltarCabecera
		
		
		#lazo para obtener el nombre del equipo
		exit1:
		la $s5 , arrayNombres
		add $s5, $t9 , $s5
		addi $s1 , $s1 ,1
		li $t5 , 0 # desplazamineto nombres
		loop2:
		lb $t6 , buffer($s1)
		beq $t6 , 44 , numeros # 44 codigo ascii de ","
		add $t7, $t5 , $s5
		sb $t6, 0($t7)
		addi $t5, $t5,1
		addi $s1 , $s1 ,1
		j loop2
		
		
		numeros:
		addi $t9 ,$t9 ,16
		# lazo para recorrer los numeros
		li $t5 , 0 # desplazamineto de numeros		
		loop3:
		addi $s1 , $s1 ,1
		lb $t6 , buffer($s1)
		beq $t6 , 44 , guardar
		beq $t6 , 10 , exitAux
		beq $t6 , 13 , loop3
		la $s5, array	
		sb $t6, ($s5)
		j loop3
		
		# se guarda el numero en la poscion correspondiente en la matriz		
		guardar:
		
		# se transforma los caracteres numericos a enteros
		move $a0 , $s5
		jal atoi 
		
		la $s7, matriz
		add $t7 , $s7, $t8
		sb $v0 , 0($t7)

    		addi $t8, $t8, 4
    		j loop3
    		
    		# exit auxiliar para guardar el ultimo numero antes del salto de linea
    		exitAux:
		# se transforma los caracteres numericos a enteros
		move $a0 , $s5
		jal atoi 

		# se guarda el valor en la matriz
		add $t7 , $s7, $t8
    		sb $v0 , 0($t7)
    		addi $t8, $t8, 4
		addi $s0 , $s0 ,1 #contador de numero de filas
		
		
		
		
		
		beq $s0 , 16, exitFinal
		j exit1
 	
		exitFinal:
		j fin 
	
	
	#funcion leer archivo
	readFile:
		#referencia https://raw.githubusercontent.com/elenaty4/CSTutorials/master/MIPS%20Assembly/HowToReadandWriteFile.asm
		li $v0,13           	# open_file syscall code = 13
    		la $a0,archivo     	# get the file name
    		li $a1,0           	# file flag = read (0)
    		syscall
    		move $s0,$v0        	# save the file descriptor. $s0 = file
	
		#read the file
		li $v0, 14		# read_file syscall code = 14
		move $a0,$s0		# file descriptor
		la $a1,buffer 		# The buffer that holds the string of the WHOLE file
		la $a2,1024		# hardcoded buffer length
		syscall
		
		#Close the file
    		li $v0, 16         		# close_file syscall code
    		move $a0,$s0      		# file descriptor to close
    		syscall	

		jr $ra	
		
		
		
 	atoi:
		 sub $sp,$sp,4
		 sw  $ra,0($sp)
		 move $t0,$a0
		 li  $v0,0
		 
		 next:
		 lb $t1,($t0)
		 blt $t1,48, endloop
		 bgt $t1,57, endloop
		 mul $v0,$v0,10
		 add $v0,$v0,$t1
		 sub $v0,$v0,48
		 add $t0,$t0,1
		 b next
		 endloop:
		 lw $ra,0($sp)
		 add $sp,$sp,4
		 jr $ra
