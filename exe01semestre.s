.data
	#Mensagens a serem exibidas
	msg1: .asciiz "Digite um numero entre 1 a 50000: "
	msg2: .asciiz "Valor invalido! Digite novamente um valor entre o intervalo: "
	msg3: .asciiz "O primeiro valor primo anterior ao numero digitado e: "
	msg4: .asciiz "Nao existe numero primo anterior no intervalo!"
	
.text
	main:
	#Receber o numero	
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0

valida_intervalo:
	# Se numero < 1
	li $t0, 1
	blt $t1, $t0, num_invalido
	
	# Senao se numero > 50000
	li $t0, 50000
	bgt $t1, $t0, num_invalido
	
	# Passou pelo intervalo, decrementa 1 para começar a buscar o anterior
	addi $t1, $t1, -1
	j busca_primo_anterior

num_invalido:
	# Solicita outro valor
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0               
	j valida_intervalo

busca_primo_anterior:
	# Se chegou a um numero menor que 2, valor nao e primo!
	li $t0, 2
	blt $t1, $t0, nao_primo

	# Inicializa o divisor em 2
	li $t2, 2

#Verifica se o valor atual em $t1 e primo
laco_teste:
	#Se o divisor ($t2) alcançou $t1, e Primo!
	beq $t2, $t1, primo_encontrado

	#Resto da divisão
	rem $t3, $t1, $t2

	#Se o resto for ZERO, nao e primo, logo passa para o proximo numero anterior
	li $t0, 0
	beq $t3, $t0, proximo_test

	#Incrementa o divisor ($t2 = $t2 + 1) e continua o laço
	addi $t2, $t2, 1
	j laco_teste

proximo_test:
	# Tenta o proximo numero abaixo ($t1 = $t1 - 1)
	addi $t1, $t1, -1
	j busca_primo_anterior

nao_primo:
	li $v0, 4
	la $a0, msg4
	syscall
	j fim

primo_encontrado:
	#exibe o primo encontrado
	li $v0, 4
	la $a0, msg3
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall

fim:	
	#encerra o programa
	li $v0, 10
	syscall
	