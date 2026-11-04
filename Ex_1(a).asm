#: percorrer a string até '\0' e contar apenas os caracteres entre '0' e '9'. Para "AC1-Labs", o resultado é 1: só '1' é um algarismo (array de caracteres percorrem 1 byte, array de inteiros ocupam 4 bytes)
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
	la $t2, str		# Guarda a base do array ($t2 = str ou &str[1])
	li $t0, 0		# num = 0
	li $t1, 0		# i = 0
while:	
	addu $t3, $t2, $t1      	# &str[i]=base+i; cada char ocupa 1 byte
	lb   $t4, 0($t3)		# Lê o byte str[i] da memória
	beq  $t4, $zero, endw 		# Se for '\0', sai sem processar esse byte
if:
	blt  $t4, '0', endif  		# Se for menor que '0', não conta
	bgt $t4, '9', endif		# Se for maior que '9', nao conta
	addi $t0, $t0, 1		# num++
endif:
	addi $t1, $t1, 1		# i++ para todos os caracteres nao nulos
	j while				# Volta a testar o caractér seguinte
endif:
	move $a0, $t0			# Coloca o resultado no argumento da impressão (passa de $t0 para $a0).
	li   $v0, print_int10		# Lê $a0 e seleciona a impressão de inteiro decimal
	syscall				# Imprime print_int10(num)
	
	li $v0, 10			# Seleciona a saída
	syscall				# Terminar.