.data 
	infomenu: .asciiz "MENU: \n 1.Tabla Ordenada.\n 2.Ingreso de partidos.\n 3.Mostrar los 3 mejores.\n 4.Salir\n"
	msgopcion: .asciiz "Ingrese opción: "
	archivo: .asciiz "TablaIni.txt"
	buffer: .space 1024
	bufferOp: .space 4
	bufferWord: .asciiz "Aqui van los 3 mejores"
	encabezado: .asciiz "-----------------------------------------------\n"
	pie: .asciiz "-----------------------------------------------\n\n\n"
	mensajeSalida: .asciiz "------Este es un mensaje de salida-------"
	array: .space 2
	nombre: .space 20
	nombretmp: .space 20
	arrayNombres: .word nombre, nombre, nombre , nombre , nombre ,nombre , nombre , nombre
	
	fila1: .word  1 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila2: .word  2 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila3: .word  3 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila4: .word  4 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila5: .word  5 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila6: .word  6 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila7: .word  7 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila8: .word  8 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila9: .word  9 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	fila10: .word 10 ,0 ,0 ,0 ,0 ,0 ,0 ,0
	
	matriz: .word fila1, fila2, fila3, fila4,fila5,fila6, fila7, fila8, fila9,fila10

	

.globl main
.text 
	main:
		li $s1, 49 # 49 codigo ascii de 1
		li $s7, 50 # 49 codigo ascii de 2
		li $s3, 51 # 49 codigo ascii de 3
		li $s4, 52 # 49 codigo ascii de 4
		
		

		loop:
			#Mostrar menu
			li $v0 , 4
			la $a0 , infomenu
			syscall
			
			#pedir y 
			li $v0 , 4
			la $a0 , msgopcion
			syscall
			
			li $v0,8 #take in input
         		la $a0, bufferOp #load byte space into address
         		li $a1, 4 # allot the byte space for string
         		move $t0,$a0 #save string to t0
         		syscall
			
			lb $t0 , bufferOp($0)
			# preguntar por opcion 1
			beq $t0 , $s1 , mostrarTabla
			#beq $t0 , $s7 , mostrarTabla
			beq $t0 , $s3 , mostrarTresMej
			j menu
			mostrarTabla:
				jal tabla
				
				
			mostrarTresMej:
				
				jal tresMejores
				
				
			menu:
			#preguntar por opciones. Si es 4 se culmina el programa
			bne $t0 , $s4 , loop
			
			#Mensaje final
			li $v0 , 4
			la $a0 , mensajeSalida
			syscall
	# se cylmina ejecucion	
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
	
	# funcion leer tabla
	ordenarTabla:
		jal readFile
		li $t1 , -2 # desplazamiento
		li $t5 , 0 # desplazamineto nombres
		li $t3 , 0  # posicion de la fila
		li $t8 ,0  # posicion del valor en la fila
		li $t0 , 0 # contador de numero de filas
		
		saltarCabecera:
		lb $t6 , buffer($t1)
		beq $t6,10 , exit1 # 10 codigo ascii de salto de linea
		addi $t6 , $t6,1
		addi $t1 , $t1 ,1
		j saltarCabecera
		
		exit1:
		
		addi $t6 , $t6,1
		addi $t1 , $t1 ,1
		
		loop2:
		beq $t6 , 44 , loop3 # 44 codigo ascii de ","
		la $s5 , nombretmp
		add $t7, $t5 , $s5
		sb $t6, 0($t7)
		addi $t5, $t5,1
		addi $t6 , $t6,1
		addi $t1 , $t1 ,1
		j loop2

		
		
		li $t5 , 0 # desplazamineto numeros
		
		loop3:
		addi $t6 , $t6,1
		addi $t1 , $t1 ,1
		beq $t6 , 44 , guardar
		beq $t6 , 10 , exitAux
		la $s5, array
		add $t7, $t5 , $s5
		sb $t6, 0($t7)
		addi $t5, $t5,1
		j loop3
		
		guardar:
	
		jal atoi 
		la  $t1, matriz ## direccion de la matriz
    		lw  $t8 , matriz($t3) ## direccion de la fila1
    		
    		
    		sw    $s2 , 0($t8) ## la direccion del valor de la fila
    		addi $t8 , $t8 ,4
    		
    		j loop3
    		
    		exitAux:
    		la $s5, array
		add $t7, $t5 , $s5
		sb $t6, 0($t7)
		addi $t5, $t5,1
		addi $t3 ,$t3,4
		addi $t0 , $t0 ,1
		li $t5 , 0 # desplazamineto nombres
		beq $t0 , 9 , exitFinal
		j exit1
 	
		exitFinal:
		jr $ra
	tabla:
	
		jal readFile
		# print whats in the file
		#Mostrar encabezado
		li $v0 , 4
		la $a0 , encabezado
		syscall
		
		li $v0, 4		# read_string syscall code = 4
		la $a0,buffer
		syscall
	
		#Mostrar pie
		li $v0 , 4
		la $a0 , pie
		syscall
		
		#Close the file
    		li $v0, 16         		# close_file syscall code
    		move $a0,$s0      		# file descriptor to close
    		syscall
    		
		j menu
		
		
	
		
	tresMejores:
		jal readFile
    	
		li $t0 , 0 # contador
		li $t1 , -2 # desplazamiento
		li $t5 , 0 #coincidencias 

		loop1:
		lb $t4 , buffer($t1)
		beq $t4, 10, count # 10 codigo ascii de salto de linea
		addi $t1,$t1,1
		addi $t0,$t0,1
		j loop1
		
		count:
		addi $t1,$t1,1
		addi $t5 , $t5 , 1
		beq $t5 , 4, exit # 4 variable de control de los saltos de linea 
		j loop1
		
		exit:
		li $v0,13           	# open_file syscall code = 13
    		la $a0,archivo    	# get the file name
    		li $a1,0           	# file flag = read (0)
    		syscall
    		move $s0,$v0        	# save the file descriptor. $s0 = file
	
		#read the file
		li $v0, 14		# read_file syscall code = 14
		move $a0,$s0		# file descriptor
		la $a1,bufferWord 	# The buffer that holds the string of the WHOLE file
		move $a2,$t0	# hardcoded buffer length
		syscall
	
		# print whats in the file
		li $v0, 4		# read_string syscall code = 4
		la $a0,bufferWord
		syscall
	
		#Close the file
    		li $v0, 16         		# close_file syscall code
    		move $a0,$s0      		# file descriptor to close
    		syscall
    		
    		j menu
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
li $v0, 1
add $a0, $s2, $zero
syscall 
li $v0, 10      #ends program
syscall
