# Somar um array de inteiros utilizando ponteiros -> O array é: int array[4] = {7692, 23, 5, 234}; Cada inteiro ocupa 4 bytes neste contexto MIPS de 32 bits.
# Mapa de registos:
# $t0 = p
# $t1 = pultimo
# $t2 = *p: inteiro acabado de ler
# $t3 = soma
# $t4 = temporário para calcular o deslocamento do último elemento
 
	 .eqv print_int10,1	# Serviço de impressão
	 .eqv SIZE,4		# Número de elementos
	 
	 .data			# Zona de dados
	 .align 2		# Alinha o próximo dado a múltiplo de 2^2=4 bytes
array: .word 7692,23,5,234	# Reserva e inicializa quatro words: 16 bytes.
	.text
	.globl main
main:
	li   $t3, 0		# soma = 0
	li   $t4, SIZE		# $t4 = 4
	addi $t4, $t4, -1	# $t4 = SIZE - 1 = 3, índice do último elemento.
	sll  $t4, $t4, 2		# $t4 = 3*4 = 12 bytes (shift left logic, acrescenta 2 zeros à direita)
	
	la   $t0, array 		# p =endereço do primeiro elemento.
	addu $t1, $t0, $t4	# pultimo = endereço inicial + 12.
	
while:
	bgtu  $t0, $t1, endw	 #branch if greater than unsigned, se p > pultimo, termina o ciclo.
	lw    $t2, 0($t0)	 # Lê o inteiro acabado de ler "*p": transfere 4 bytes para $t2. (Load word) -> lb lê 1 byte enquanto lw lê uma word de 4 bytes.
	add   $t3, $t3, $t2      # Soma = Soma + *p
	addiu $t0, $t0, 4	 # p++: avança 4 bytes, para o próximo inteiro.
	j while			 # Volta a testar se ainda há elementos.

endw:
	move $a0, $t3		 # Coloca a soma no argumento da impressão.
	li   $v0, print_int10	 # Seleciona a impressão de um inteiro.
	syscall			 # Imprime a soma.
	jr $ra