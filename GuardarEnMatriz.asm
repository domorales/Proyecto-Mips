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
	array: .space 2
	nombre: .space 20
	nombretmp: .space 20
	arrayNombres: .word nombre, nombre, nombre , nombre , nombre ,nombre , nombre , nombre, nombre , nombre
	
	fila1: .word  1 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila2: .word  13 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila3: .word  3 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila4: .word  4 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila5: .word  5 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila6: .word  6 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila7: .word  7 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila8: .word  8 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila9: .word  9 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila10: .word 10 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila11: .word  1 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila12: .word  13 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila13: .word  3 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila14: .word  4 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila15: .word  5 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila16: .word  6 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	
	matriz: .word fila1, fila2, fila3, fila4,fila5,fila6, fila7, fila8, fila9,fila10,fila11, fila12, fila13, fila14,fila15,fila16


.text


	
	# funcion leer tabla
	ordenarTabla:
		jal readFile
		li $s3 , -2 # desplazamiento
		li $t5 , 0 # desplazamineto nombres
		li $s6 , 0  # posicion de la fila
		li $t8 ,0  # posicion del valor en la fila
		li $s0 , 0 # contador de numero de filas
		
		saltarCabecera:
		lb $t6 , buffer($s3)
		beq $t6,10 , exit1 # 10 codigo ascii de salto de linea
		addi $s3 , $s3 ,1
		j saltarCabecera
		
		exit1:
		addi $s3 , $s3 ,1
		li $t5 , 0 # desplazamineto nombres
		loop2:
		lb $t6 , buffer($s3)
		beq $t6 , 44 , loop3 # 44 codigo ascii de ","
		la $s5 , nombretmp
		add $t7, $t5 , $s5
		sb $t6, 0($t7)
		addi $t5, $t5,1
		addi $s3 , $s3 ,1
		j loop2

		lw $s7 ,arrayNombres($0) ## direccion de la fila1
		li $v0 ,4
	 	move $a0 , $s7
		syscall
		
		
		li $t5 , 0 # desplazamineto numeros
		
		loop3:
		addi $s3 , $s3 ,1
		lb $t6 , buffer($s3)
		beq $t6 , 44 , guardar
		beq $t6 , 10 , exitAux
		beq $t6 , 13 , loop3
		la $s5, array
		sb $t6, ($s5)
		
		
		
		j loop3
		
		guardar:
		
		move $a0 , $s5
		jal atoi 
		
		move $s2 , $v0
		move $a0, $v0
		li $v0, 1
		syscall 
		
		
		la  $s7, matriz ## direccion de la matriz
    		lw  $s7 , matriz($s6) ## direccion de la fila1
    		sw  $s2 , 0($s7) ## la direccion del valor de la fila
    		addi $s7 , $s7 ,4
    		
    		j loop3
    		
    		exitAux:
		
		move $a0 , $s5
		jal atoi 
		
		move $s2 , $v0
		move $a0, $v0
		li $v0, 1
		syscall 
		
		la  $s7, matriz ## direccion de la matriz
    		lw  $s7 , matriz($s6) ## direccion de la fila1
    		sw    $s2 , 0($s7) ## la direccion del valor de la fila
    		addi $s7 , $s7 ,4
		addi $s6 ,$s6,4
		addi $s0 , $s0 ,1
		li $t5 , 0 # desplazamineto nombres
		beq $s0 , 16, exitFinal
		j exit1
 	
		exitFinal:
		li $v0 , 10
		syscall
	
	
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
