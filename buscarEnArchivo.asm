.data 
	buffer: .space 1024
	bufferWord: .space 20
	nombre: .asciiz "TablaIni.txt"
	final: .asciiz "\n"
	coin: .asciiz "\nCoincidencia\n"
	


.text 
#HOW TO READ INTO A FILE
	
	li $v0,13           	# open_file syscall code = 13
    	la $a0,nombre     	# get the file name
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
	li $v0, 4		# read_string syscall code = 4
	la $a0,buffer
	syscall
	
	#Close the file
    	li $v0, 16         		# close_file syscall code
    	move $a0,$s0      		# file descriptor to close
    	syscall
    	
    	li $v0, 8
    	la $a0, bufferWord
    	li $a1, 20
    	syscall
    	move $s0 , $a0
    	li $t3, 0
    
    
    	la $s0 , bufferWord
    	lb $t1 , final
    	add $t4, $0,$0
   	move $t0, $s0
    
     #contar palabras
       loop:	
    	lb $t2, 0($t0)
    	beq $t1,$t2 ,salir
    	addi $t0,$t0,1
    	addi $t4,$t4,1 ## tamaño de la palabra
    	j loop
    	
    	salir:

    	li $v0, 1		# read_string syscall code = 4
	move $a0 , $t4
	syscall
	
	
	
	
	move $t0, $s0         ## dirrecion de palabra
	la $s1 , buffer
	move $t1, $s1
	li $s2 , 0    ## cantidad de coincidencias
	
	while:
	lb $t2, 0($t1) ##archivo
	lb $t3, 0($t0) ##palabra
	beq $t2, $t3, count
	move $t0, $s0
	addi  $t1 ,$t1 ,1
	li $s2 , 0
	j while
	
	count: 
	addi $s2 ,$s2 ,1
	addi $t1,$t1,1
	addi $t0,$t0,1
	beq $s2 , $t4 ,sal
	j while 
	
	sal:
	li $v0, 4		# read_string syscall code = 4
	la $a0,coin
	syscall
	
	li $v0, 1		# read_string syscall code = 4
	move $a0 , $s2
	syscall
	
	
	
    	

	
	


