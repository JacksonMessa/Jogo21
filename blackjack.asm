#Trabalho de Laborat�rio de Arquitetura de Computadores - IFSP - Jogo BlackJack / 21
#15-06-2022

#Regras:
#Baralho de 52 cartas.
#cartas: os s�mbolos A,K,Q,J e os n�meros de 2 a 10, cada um dos s�mbolos e numeros contam com 4 cartas no baralho;
#A m�quina come�a com 1 carta e o jogador com 2;
#Ap�s o inicio � o turo do jogador, em que ele pode escolher entre puxar ou parar, o jogador pode puxar at� ter 5 cartas;
#Cada vez que o jogador puxa ele pode escolher novamente se quer puxar ou parar;
#Quando o jogador tiver 5 cartas ou escolher parar � o turno da m�quina;
#No turno da m�quina ela ter� as mesmas op��es que o jogador e tentar� puxar at� ganhar do jogador e �s vezes aceitar� o empate;
#Depois do turno da m�quina o jogo acaba e o resultado ser� mostrado;
#Cada carta tem o seu valor, A=1, Q, R e J = 10 e os n�meros valem igual ao n�mero da carta ex: 8=8;
#O valor das cartas do jogador s�o somados ao total do jogador e o mesmo vale para m�quina e o total da m�quina;
#Se o total do jogador ou da m�quina ultrapassar 21 o jogo acaba imediatamente com a derrota de quem ultrapassou;
#Se nenhum dos dois ultrapassar 21 ganha quem tiver o valor total mais pr�ximo a 21;
#Se o total da m�quina for igual ao do jogador ao fim do jogo, acaba empatado.

#Registradores:
#$t0 = carta 1 do jogador
#$t1 = carta 2 do jogador/carta 5 da m�quina/comparativo para cartas na mem�ria
#$t2 = carta 3 do jogador/carta 4 da m�quina
#$t3 = carta 4 do jogador/carta 3 da m�quina
#$t4 = carta 5 do jogador/carta 2 da m�quina
#$t5 = carta 1 da m�quina
#$t6 = n�mero de cartas do jogador
#$t7 = n�mero de cartas da m�quina
#$t8 = total da m�quina
#$t9 = total do jogador

#tabela de valores:
#Carta	A	2	3	4	5	6	7	8	9	10	Q	J	K
#ID	1	2	3	4	5	6	7	8	9	10	11	12	13	
#ID+13	14	15	16	17	18	19	20	21	22	23	24	25	26	
#ID+26	27	28	29	30	31	32	33	34	35	36	37	38	39	
#ID+39	40	41	42	43	44	45	46	47	48	49	50	51	52
#Valor	1	2	3	4	5	6	7	8	9	10	10	10	10

	
	.data
c2:		.word 0	#espa�o reservado para carta 2 do jogador
c3:		.word 0	#espa�o reservado para carta 3 do jogador
c4:		.word 0	#espa�o reservado para carta 4 do jogador
c5:		.word 0	#espa�o reservado para carta 5 do jogador
string_total_j:	.asciiz "\n\nTotal do jogador: "	
string_total_m:	.asciiz "\n\nTotal da maquina: "	
pular_linha:	.asciiz "\n"
espaco:		.asciiz " "
opcao:		.asciiz"\n\nDigite uma opcao:\n1-Puxar\t2-Parar\n"
repetir:	.asciiz"\n\nDigite uma opcao:\n1-Jogar novamente 2-Sair\n"
invalida:	.asciiz"\n\nOPCAO INVALIDA"
borda_mesa:	.asciiz"\n----------------------"
borda_carta:	.asciiz"|"
win:		.asciiz"\nParabens!!! Voce venceu!"
draw:		.asciiz"\nEmpatou!"
lose:		.asciiz"\nQue Pena voce perdeu! Quem sabe na pr�xima!"

	.text
	
	.globl main
	
main:
	#zerando todos os registradores
	move $t0,$zero	
	move $t1,$zero
	move $t2,$zero
	move $t3,$zero
	move $t4,$zero
	move $t5,$zero
	move $t6,$zero
	move $t7,$zero
	move $t8,$zero
	move $t9,$zero
	
	#zerando os espa�os da mem�ria que ir�o armazenar cartas
	sw $zero,c2
	sw $zero,c3
	sw $zero,c4
	sw $zero,c5
	
		
	jal sorteio	#sorteio primeira carta maquina
	move $t5, $a0	#armazenando a carta sorteada no $t5
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorm	#soma da carta ao total maquina
	li $t7,1	#numero de cartas da maquina=1

		
	jal sorteio	#sorteio primeira carta jogador
	move $t0, $a0	#armazenando a carta sorteada no $t0
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorj	#soma da carta ao total do jogador
	
	jal sorteio	#sorteio segunda carta jogador
	move $t1, $a0	#armazenando a carta sorteada no $t1
	sw $t1,c2	#armazenando a carta 2 do jogador na memoria
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorj	#soma da carta ao total do jogador
	li $t6,2	#numero de cartas do jogador =2
	
	j mostrar
	
puxar:
	jal sorteio		#sorteia a carta
	add,$t6,$t6,1		#aumenta em 1 o contador de cartas do jogador
	
	#verifica o n�mero de cartas do jogador para colocar a carta sorteada no lugar que ela deve ser armazenada
	beq $t6,3,puxar_carta_3_j		
	beq $t6,4,puxar_carta_4_j
	beq $t6,5,puxar_carta_5_j
	
puxar_carta_3_j:
	move $t2,$a0	#armazenando a carta sorteada no $t2
	sw $t2,c3	#armazenando a carta 3 do jogador na memoria
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorj	#soma da carta ao total do jogador
	j mostrar
	
puxar_carta_4_j:
	move $t3,$a0	#armazenando a carta sorteada no $t3
	sw $t3,c4	#armazenando a carta 4 do jogador na memoria
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorj	#soma da carta ao total do jogador
	j mostrar
puxar_carta_5_j:
	move $t4,$a0	#armazenando a carta sorteada no $t4
	sw $t4,c5	#armazenando a carta 5 do jogador na memoria
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorj	#soma da carta ao total do jogador
	j mostrar
	
somadorj:
	bgt $a0,10,soma10j  #Os simbolos K,Q,J valem 10 o que n�o equivale a seu ID ent�o se eles forem sorteados o total ser� incremenetado em 10
	add $t9, $t9, $a0 #adiciona o valor da carta sorteada ao total do jogador($t9).
	jr $ra

	
parar:
	jal sorteio	#sorteando a proxima carta da m�quina
	
	move $t4,$a0	#armazenando a carta sorteada na carta 2 da m�quina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorm	#somando a carta ao total da m�quina
	
	jal verificar	#verifica se a m�quina deve continuar puxando
	
	move $t3,$a0	#armazenando a carta sorteada na carta 3 da m�quina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorm	#somando a carta ao total da m�quina

	jal verificar	#verifica se a m�quina deve continuar puxando

	move $t2,$a0	#armazenando a carta sorteada na carta 4 da m�quina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorm	#somando a carta ao total da m�quina
	
	jal verificar	#verifica se a m�quina deve continuar puxando
	
	move $t1,$a0	#armazenando a carta sorteada na carta 5 da m�quina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja somado corretamente
	jal somadorm	#somando a carta ao total da m�quina
	add $t7,$t7,1	#aumenta em 1 o contador de cartas da m�quina
	
	j mostrar	#Se a m�quina j� puxou 5 cartas ent�o ela dever� parar de puxar
	
verificar:
	add $t7,$t7,1	#aumenta em 1 o contador de cartas da m�quina
	bgt,$t8,$t9,mostrar	#caso a m�quina ultrapasse o jogador em pontos a maquina vai parar de puxar
	blt,$t8,18,sorteio	#se a pontua��o da m�quina for menor que a do jogador(linha acima) e < 18 ela continuar� puxando
	beq,$t8,$t9,mostrar	#se as condi��es acima nao forem cumpridas a e as pountua��es forem iguais a m�quina aceitar� o empate e ir� parar de puxar
	j sorteio	# se nenhuma condi��o for cumprida a m�quina continuar� a puxar
		
somadorm:		
	bgt $a0,10,soma10m  #Os simbolos K,Q,J valem 10 o que n�o equivale a seu numero de identifica��o ent�o se eles forem sorteados o total ser� incremenetado em 10
	add $t8, $t8, $a0 #adiciona o valor da carta sorteada ao total da maquina($t8).
	jr $ra	
	
sorteio:
	#sorteador
	li $v0,42	#Insere 42 no $v0 para indicar que vai sortear inteiro com limites     
	li $a1,52	#limite max do sorteio(obs.: vai de 0-51)
	syscall
	
	add $a0,$a0,1	#adiciona 1 ao numero sorteado para que v� de 1 a 52 e facilite compara��es
	
	beq,$a0,$t0,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no $t0, assim evitando a repeti��o
	beq,$a0,$t1,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no $t1, assim evitando a repeti��o
	beq,$a0,$t2,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no $t2, assim evitando a repeti��o
	beq,$a0,$t3,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no $t3, assim evitando a repeti��o
	beq,$a0,$t4,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no $t4, assim evitando a repeti��o
	beq,$a0,$t5,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no $t5, assim evitando a repeti��o
	
	bgt,$t7,1,verificar_turno_maquina	#verifica se � turno da m�quina, para verificar as cartas do jogador na mem�ria
	
	jr $ra
	
verificar_turno_maquina:
	
	lw $t1,c3		#armazena a carta 2 do jogador no $t1 para compara��o
	beq,$a0,$t1,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no c2, assim evitando a repeti��o
	lw $t1,c4		#armazena a carta 3 do jogador no $t1 para compara��o
	beq,$a0,$t1,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no c3, assim evitando a repeti��o
	lw $t1,c5		#armazena a carta 4 do jogador no $t1 para compara��o
	beq,$a0,$t1,sorteio	#verifica se o n�mero sorteado j� foi est� armazenado no c4, assim evitando a repeti��o
	
	lw $t1,c2	#devolve a carta 2 do jogador para o $t1
	
	jr $ra
	
soma10j:
	add $t9, $t9, 10 #adiciona o valor da carta sorteada ao total do jogador se for K,Q,J.
	jr $ra
	
soma10m:
	add $t8, $t8, 10 #adiciona o valor da carta sorteada ao total da maquina se for K,Q,J.
	jr $ra
			
mostrar:
	
	li $v0,4		#printando a soma da pontua��o da maquina
	la $a0,string_total_m
	syscall
	li $v0,1
	move $a0,$t8
	syscall
	
	li $v0,4		#printando a borda de cima da mesa
	la $a0,borda_mesa
	syscall
	
	li $v0,4		#pula linha
	la $a0,pular_linha
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t5		 #mostra a carta 1 da maquina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	blt,$t7,2,mostrar_jogador	#se a m�quina tiver menos que 2 cartas o programa ir� pular para mostrar as cartas do jogador
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t4		 #mostra a carta 2 da maquina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	lw $t4,c5		#devolve o registrador para a carta 5 do jogador
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	blt,$t7,3,mostrar_jogador	#se a m�quina tiver menos que 3 cartas o programa ir� pular para mostrar as cartas do jogador
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t3		 #mostra a carta 3 da maquina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	lw $t3,c4		#devolve o registrador para a carta 4 do jogador
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	blt,$t7,4,mostrar_jogador	#se a m�quina tiver menos que 4 cartas o programa ir� pular para mostrar as cartas do jogador
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t2		 #mostra a carta 4 da maquina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	lw $t2,c3		#devolve o registrador para a carta 3 do jogador
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	blt,$t7,5,mostrar_jogador	#se a m�quina tiver menos que 5 cartas o programa ir� pular para mostrar as cartas do jogador
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t1		 #mostra a carta 5 da maquina
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	lw $t1,c2		#devolve o registrador para a carta 2 do jogador
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
mostrar_jogador:
	
	li $v0,4		#pula linha
	la $a0,pular_linha
	syscall
	
	li $v0,4		#pula linha
	la $a0,pular_linha
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t0		 #mostra a carta 1 do jogador
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t1		 #mostra a carta 2 do jogador
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	blt,$t6,3,pontuacao	#se o jogador tiver menos que 3 cartas o programa ir� pular para mostrar o total
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t2		 #mostra a carta 3 do jogador
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	blt,$t6,4,pontuacao	#se o jogador tiver menos que 4 cartas o programa ir� pular para mostrar o total
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t3		 #mostra a carta 4 do jogador
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	blt,$t6,5,pontuacao	#se o jogador tiver menos que 5 cartas o programa ir� pular para mostrar o total
	
	li $v0,4		#espa�o
	la $a0,espaco
	syscall
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall
	
	move $a0,$t4		 #mostra a carta 5 do jogador
	jal num_identificacao	#transforma o valor sorteado no seu ID(tabela no come�o do c�digo) para que seja mostrado corretamente
	jal mostrar_carta
	
	li $v0,4		#printando a borda da carta
	la $a0,borda_carta
	syscall	
	
pontuacao:

	li $v0,4		#printando a borda de baixo da mesa
	la $a0,borda_mesa
	syscall
	
	li $v0,4		#printando a soma da pontua��o do jogador
	la $a0,string_total_j
	syscall
	li $v0,1
	move $a0,$t9
	syscall
	
	bne $t7,1,verifica_resultado	#verifica o resultado se jogador e m�quina j� jogaram
	beq $t9,21,parar		#escolhe a opcao parar caso o jogador tenha o valor total 21
	bgt $t9,21,perdeu	#mostra a mensagem de perdeu caso o jogador tenha passado de 21
	beq $t6,5,parar		#escolhe a opcao parar caso o jogador j� tenha 5 cartas	
	j escolha			#deixa o jogador escolher se nehuma das condi��es acima forem cumpridas
	
verifica_resultado:	
	bgt $t8,21,venceu	#mostra a mensagem de venceu caso a m�quina tenha passado de 21
	bgt $t9,$t8,venceu	#mostra a mensagem de venceu caso a pontua��o do jogador seja maior que a da m�quina
	beq $t9,$t8,empatou	#mostra a mensagem de empatou caso a pontua��o do jogador seja igual a da m�quina
	blt $t9,$t8,perdeu 	#mostra a mensagem de perdeu caso a pontua��o do jogador seja menor que a da m�quina	
	
escolha:
	li $v0,4		#pedindo para o jogador escolher entre parar ou puxar outra carta
	la $a0,opcao
	syscall
	li $v0,12		#lendo op��o
	syscall
	
	beq $v0,'1',puxar	#op��o puxar
	beq $v0,'2',parar	#op��o parar
	li $v0,4		#dizendo que o jogador digitou uma op��o inv�lida
	la $a0,invalida
	syscall
	j escolha		#pedindo para digitar novamente

mostrar_carta:
	
	
	beq $a0,1,As		#ir� printar A se o ID da carta for 1
	beq $a0,11,Dama		#ir� printar Q se o ID da carta for 11
	beq $a0,12,Valete	#ir� printar J se o ID da carta for 12
	beq $a0,13,Rei		#ir� printar K se o ID da carta for 13
		
	#printando carta se for numero
	li $v0, 1
	syscall
	
	jr $ra
	
num_identificacao:

	ble $a0,13,volta			#um loop que equanto o n�mero for maior que 13 subtrair� 13 dele assim o transormando em seu ID original
	sub $a0,$a0,13
	bgt $a0,13,num_identificacao
volta:	jr $ra

As:
	li $a0, 'A'	#printando As	
	li $v0, 11
	syscall
	jr $ra
Dama:
	li $a0,'Q'	#printando Dama	
	li $v0, 11
	syscall
	jr $ra
Valete:
	li $a0,'J'	#printando Valete	
	li $v0, 11
	syscall
	jr $ra
Rei:
	li $a0,'K'	#printando Rei
	li $v0, 11
	syscall
	jr $ra	

#Mensagens de resultado:
venceu:
	li $v0,4		#informa que o jogador venceu
	la $a0,win
	syscall
	j pergunta
empatou:
	li $v0,4		#informa que houve empate
	la $a0,draw
	syscall
	j pergunta	
perdeu:	
	li $v0,4		#informa que o jogador perdeu
	la $a0,lose
	syscall
	j pergunta

pergunta:
	li $v0,4		#pedindo para o jogador escolher entre jogar novamente ou sair
	la $a0,repetir
	syscall
	li $v0,12		#lendo op��o
	syscall
	
	beq $v0,'1',main	#op��o jogar novamente
	beq $v0,'2',exit	#op��o sair
	li $v0,4		#dizendo que o jogador digitou uma op��o inv�lida
	la $a0,invalida
	syscall
	j pergunta		#pedindo para digitar novamente
	

exit:
	li $v0,10	#exit
	syscall