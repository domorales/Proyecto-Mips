.data 
	infomenu: .asciiz "MENU: \n 1.Tabla OrdenadaTabla.\n 2.Ingreso de partidos.\n 3.Mostrar los 3 mejores.\n 4.Salir\n"
	opcion: .asciiz "Ingrese opción: "
	archivo: .asciiz "TablaIni.txt"
	buffer: .space 1024
	bufferOp: .space 4
	encabezado: .asciiz "-----------------------------------------------\n"
	pie: .asciiz "-----------------------------------------------\n\n\n"
	mensajeSalida: .asciiz "------Este es un mensaje de salida-------"
	
	

.globl main
.text 
	main:
		loop:
			#Mostrar menu
			li $v0 , 4
			la $a0 , infomenu
			syscall
			
			#pedir y 
			li $v0 , 4
			la $a0 , opcion
			syscall
			
			#obtener opcion
			li $v0 , 5
			syscall
			move $t0, $v0
			
			# preguntar por opcion 1
			beq $t0 , 1 , mostrarTabla
			j menu
			mostrarTabla:

				jal tabla
			menu:
			#preguntar por opciones. Si es 4 se culmina el programa
			bne $t0 , 4 , loop
			
			#Mensaje final
			li $v0 , 4
			la $a0 , mensajeSalida
			syscall
	# se cylmina ejecucion	
	li $v0 , 10
	syscall
	
	
	
	## funcion leer tabla
	tabla:
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
 
	j menu	
