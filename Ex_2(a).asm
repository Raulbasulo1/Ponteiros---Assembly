# Mapa de registos 
# num:  $t0 
# i:   $t1 
# str:  $t2 
# str+i:  $t3 
# str[i]: $t4 

 	.eqv SIZE,20 
 	.eqv read_string,8	# Serviço MARS para ler uma string 
 	.eqv print_int10,1 	# Serviço MARS para imprimir um inteiro.
 	.data 
str: .space 21
	.text
	.globl main
main:
	la $a0, str		# Passa o endereço do buffer ao serviço 8
	li $a1, SIZE		# Capacidade passada: 20, incluindo terminador
	li $v0, read_string	# Seleciona o serviço 8
	syscall			# Lê e guarda a string em str
	li $t0, 0		# num = 0
	la $t1, str		# p = &str[0]
ciclo:
	lb  $t2, 0($t1)			# Lê o byte no endereço p: valor de *p
	beq $t2, $zero, fim_ciclo	# Se *p for '\0', termina o ciclo
	blt $t2, '0', fim_if		# Rejeita caracteres abaixo de '0'
	bgt $t2, '9', fim_if		# Rejeita caracteres acima de '9'
	addi $t0, $t0, 1		# num++ quando é um algarismo
fim_if:
	addiu $t1, $t1, 1		# p++: avança 1 byte porque p é char*
	j ciclo				# Volta a ler e testar
fim_ciclo:
	move $a0, $t0			# Resultado a imprimir
	li   $v0, print_int10		# Serviço 1
	syscall				# Imprime num
	li $v0, 10			# Serviço de saída
	syscall				# Termina
