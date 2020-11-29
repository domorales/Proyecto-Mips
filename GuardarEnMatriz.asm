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
	jal añadirValores
	
	fin:
	la $t2 , matriz
	li $t0 , 0
	li $t3 ,0 #contador
	loopM:
	add $t3 ,$t2, $t0
	li $v0 , 1
	lb $a0 ,0($t3)
	addi $t1,$t1,4
	syscall
	addi  $t0, $t0,4
	beq  $t0 ,512, salir
	j loopM
	
	salir:
    	li      $v0, 10
    	syscall

	
	# funcion leer tabla
		
		
	añadirValores:
		jal readFile
		li $s1 , -2 # desplazamiento
		li $t5 , 0 # desplazamineto nombres
		li $s4, 0 # posicion de los nombres
		li $s6 , 0  # posicion en la fila
		li $s0 , 0 # contador de numero de filas
		li $t8,0
		
		
		## Lazo para saltar la cabecera del archivo
		saltarCabecera:
		lb $t6 , buffer($s1)
		beq $t6,10 , exit1 # 10 codigo ascii de salto de linea
		addi $s1 , $s1 ,1
		j saltarCabecera
		
		
		#lazo para obtener el nombre del equipo
		exit1:
		addi $s1 , $s1 ,1
		li $t5 , 0 # desplazamineto nombres
		loop2:
		lb $t6 , buffer($s1)
		beq $t6 , 44 , numeros # 44 codigo ascii de ","
		la $s5 , nombretmp
		add $t7, $t5 , $s5
		sb $t6, 0($t7)
		addi $t5, $t5,1
		addi $s1 , $s1 ,1
		j loop2
		
		
		numeros:
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
		
		lb $a0, 0($t7)
		li $v0 , 1
		syscall
		li      $a0, 44
	  	li      $v0, 11  
 	  	syscall

		
		
    			
    		
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
		
		
		lb $a0, 0($t7)
		li $v0 , 1
		syscall
		
		li      $a0, 44
	  	li      $v0, 11  
 	  	syscall
		la $a0, nombretmp
		li $v0 , 4
		syscall
		li      $a0, 10
	  	li      $v0, 11  
 	  	syscall

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
