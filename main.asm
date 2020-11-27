.data 
	infomenu: .asciiz "MENU: \n 1.Tabla OrdenadaTabla.\n 2.Ingreso de partidos.\n 3.Mostrar los 3 mejores.\n 4.Salir\n"
	msgopcion: .asciiz "Ingrese opción: "
	archivo: .asciiz "TablaIni.txt"
	buffer: .space 1024
	bufferOp: .space 4
	bufferWord: .asciiz "Aqui van los 3 mejores"
	encabezado: .asciiz "-----------------------------------------------\n"
	pie: .asciiz "-----------------------------------------------\n\n\n"
	mensajeSalida: .asciiz "------Este es un mensaje de salida-------"
	
	

.globl main
.text 
	main:
		li $s1, 49 # 49 codigo ascii de 1
		li $s2, 50 # 49 codigo ascii de 2
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
			#beq $t0 , $s2 , mostrarTabla
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
		la $a1,buffer 	# The buffer that holds the string of the WHOLE file
		la $a2,1024		# hardcoded buffer length
		syscall
			
	
		
		jr $ra	
	
	# funcion leer tabla
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
	
		add $t6, $zero, 10 # codigo ascii de salto de linea
    		li $s2 , 4 #variable de control 
		li $t0 , 0 # contador
		li $t1 ,-2 # desplazamiento
		li $t5 , 0 #coincidencias 
		
		jal readFile
		
		loop1:
		lb $t4 , buffer($t1)
		beq $t4, $t6, count
		addi $t1,$t1,1
		addi $t0,$t0,1
		j loop1
		count:
		addi $t1,$t1,1
		addi $t5 , $t5 , 1
		beq $t5 , $s2 , exit
		j loop1
		
		exit:
		#read the file
		li $v0, 14		# read_file syscall code = 14
		move $a0,$s0		# file descriptor
		la $a1,bufferWord	# The buffer that holds the string of the WHOLE file
		move $a2, $t0	# hardcoded buffer length
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