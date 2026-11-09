# Juego original de Carlos Fontes y Rafael Quintero
# https://github.com/fonstack/Frogger
# MIT License
# 
# Copyright (c) 2018 Carlos Augusto Fontes Teixeira

.data
tiempo: .word 0
mapa: .word 0x10000000
vidasNum: .word 3
puntuacion: .word 0
goalsLlegados: .word 0
perdiste: .asciiz "¡Perdiste! D: Tu puntuacion final es: "
ganaste: .asciiz "¡Ganaste! :D Tu puntuacion final es: "
tiempoJugado: .asciiz "El tiempo jugado fue de (seg):  "
pregunta: .asciiz "Desea volver a jugar?"

tiempoMosca: .word 5000
tiempoTronco: .word 1000
tiempoVehiculo: .word 200

random1: .word 0
random2: .word 0
random3: .word 0
random4: .word 0
random5: .word 0
random6: .word 0

borde: .word 0x000000
borde2: .word 0x000001
borde3: .word 0x000002
calle1: .word 0x424949
calle2: .word 0x515A5A
rio1: .word 0x21618C
safe: .word 0x239B56
safeNo: .word 0x0B5345
rana: .word 0xA93226
carro: .word 0xB9A029
camion: .word 0x1F5DB6
mosca: .word 0xFF0040
tronco: .word 0x2F0701
llegada: .word 0x2471A3
llegadaOk: .word 0xF4D03F
vidas: .word 0xB40404
vidaNo: .word 0xFFFFFF
negro: .word 0x000000
letra: .word 0x244062
carga: .word 0x494529

# aqui ponemos las opciones de dificultad
menuDificultad: .asciiz "Seleccione la dificultad:\n1 = Facil\n2 = Normal\n3 = Dificil"
.align 2

.align 2
# aqui guardamos el record para la siguiente partida
recordMaximo: .word 0
# contamos las moscas para que la tercera sea especial
moscasGeneradas: .word 0
# este es el color celeste de la mosca especial
colorMoscaEspecial: .word 0x00FFFF
mensajeRecord: .asciiz "Record maximo de esta sesion: "

.text

.macro randomAfuera($dir)
li $v0, 30
syscall
li $v0, 42
li $a1, 50
syscall
mul $t8, $a0, 100
sw $t8, $dir
.end_macro

.macro randomAdentro($dir)
li $v0, 30
syscall
li $v0, 42
li $a1, 46
syscall
add $a0, $a0, 4
mul $t8, $a0, 100
sw $t8, $dir
.end_macro

.macro pintar($posicion, $color)
lw $t4, mapa($zero)
lw $t6, $color
addi $t4, $t4, $posicion
sw $t6, ($t4)
.end_macro

.macro pintarFondo()
leep:
lw $t2, negro
sw $t2, ($t1)
addi $t1, $t1, 4
addi $t5, $t5, 1
ble $t5, 1020, leep
.end_macro

inicioJuego:

# primero escogemos la dificultad
jal seleccionarDificultad
jal pintarBienvenida

addi $t9, $zero, 0
sw $t9, tiempo
sw $t9, puntuacion
sw $t9, goalsLlegados
# al empezar otra partida volvemos a contar las moscas desde cero
sw $t9, moscasGeneradas
addi $t9, $zero, 3
sw $t9, vidasNum

	lw $t1, mapa($zero)
	lw $t0, safeNo
	addi $t5, $zero, 0

	pintarSafeArriba:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 64, pintarSafeArriba

	lw $t1, mapa($zero)
	addi $t1, $t1, 260
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 264
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 272
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 276
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 284
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 288
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 296
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 300
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 308
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 312
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 268
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 280
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 292
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 304
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 512
	lw $t0, safe
	addi $t5, $zero, 0

	pintarSafeMedio:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarSafeMedio

	lw $t1, mapa($zero)
	addi $t1, $t1, 768
	lw $t0, safe
	addi $t5, $zero, 0

	pintarSafeAbajo:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 64, pintarSafeAbajo

	lw $t1, mapa($zero)
	lw $t2, mapa($zero)
	addi $t1, $t1, 0
	addi $t2, $t2, 960
	lw $t0, borde
	addi $t5, $zero, 0

	pintarBordes:
	sw $t0, ($t2)
	addi $t2, $t2, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarBordes

	addi $t5, $zero, 0

	pintarBordes3:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 48, pintarBordes3

	lw $t1, mapa($zero)
	addi $t1, $t1, 72
	lw $t0, vidas
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 80
	lw $t0, vidas
	sw $t0, ($t1)

	lw $t1, mapa($zero)
	addi $t1, $t1, 88
	lw $t0, vidas
	sw $t0, ($t1)

	recargarMapa:

	lw $t1, mapa($zero)
	addi $t1, $t1, 320
	lw $t0, rio1
	addi $t5, $zero, 0

	pintarRio:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 48, pintarRio

	lw $t1, mapa($zero)
	lw $t2, mapa($zero)
	addi $t1, $t1, 576
	addi $t2, $t2, 704
	lw $t0, calle1
	addi $t5, $zero, 0

	pintarCalle1:
	sw $t0, ($t1)
	sw $t0, ($t2)
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarCalle1

	lw $t1, mapa($zero)
	addi $t1, $t1, 640
	lw $t0, calle2
	addi $t5, $zero, 0

	pintarCalle2:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarCalle2

	lw $t1, mapa($zero)
	lw $t2, mapa($zero)
	addi $t1, $t1, 0
	addi $t2, $t2, 60
	lw $t0, borde2
	lw $t3, borde3
	addi $t5, $zero, 0

	pintarBordes2:
	sw $t0, ($t1)
	sw $t3, ($t2)
	addi $t1, $t1, 64
	addi $t2, $t2, 64
	addi $t5, $t5, 1
	blt $t5, 16, pintarBordes2

	lw $t1, mapa($zero)
	addi $t1, $t1, 860
	lw $t0, rana
	addi $t5, $zero, 0
	sw $t0, ($t1)

	li $s7, 860
	lw $t1, mapa($zero)
	lw $s6, safe

	randomAfuera(random1)
	randomAfuera(random2)
	randomAfuera(random3)
	randomAfuera(random4)
	randomAfuera(random5)
	randomAfuera(random6)

	loop:

	lw $t1, mapa($zero)

	li $v0, 30
	syscall
	addi $t8, $a0, 100
	loopTimer:
	li $v0, 30
	syscall
	blt $a0, $t8, loopTimer
	lw $t8, tiempo
	addi $t8, $t8, 100
	sw $t8, tiempo

	jal generarMosquita
	jal crearCarro1
	jal crearCamion2
	jal crearCarro3
	jal crearTronco4
	jal crearTronco5
	jal crearTronco6
	jal moverCarro1
	jal moverCamion2
	jal moverCarro3
	jal moverTronco4
	jal moverTronco5
	jal moverTronco6

	obtenerTecla:
	la $s0, 0xffff0000
	lw $s0, 0($s0)
	beq $s0, 1, teclado
	j loop

	teclado:
	add $t1, $t1, $s7
	sw $s6, ($t1)
	lw $t1, mapa($zero)
	move $t5, $s7

	la $s1, 0xffff0004
	lw $s1, 0($s1)

	beq $s1, 119, arriba
	beq $s1, 87, arriba
	beq $s1, 115, abajo
	beq $s1, 83, abajo
	beq $s1, 97, izquierda
	beq $s1, 65, izquierda
	beq $s1, 100, derecha
	beq $s1, 68, derecha
	# con p o P ponemos el juego en pausa
	beq $s1, 112, pausarJuego
	beq $s1, 80, pausarJuego
	beq $s1, 27, salir
	lw $t2, rana
	add $t1, $t1, $s7
	sw $t2, ($t1)
	b loop

	salir:
	li $v0, 10
	syscall

	arriba:
	addi $s7, $s7, -64
	j moverRana

	abajo:
	addi $s7, $s7, 64
	j moverRana

	izquierda:
	addi $s7, $s7, -4
	j moverRana

	derecha:
	addi $s7, $s7, 4
	j moverRana

	moverRana:
	add $t1, $t1, $s7
	lw $s6, ($t1)
	jal evaluar

	lw $t2, rana
	sw $t2, ($t1)
	j loop

	evaluar:
	beq $s6, 0xB9A029, perderVida
	beq $s6, 0x1F5DB6, perderVida
	beq $s6, 0x21618C, perderVida
	beq $s6, 0x000000, stop1
	beq $s6, 0x000001, stop2
	beq $s6, 0x000002, stop3
	beq $s6, 0x0B5345, stop4
	beq $s6, 0x2471A3, goal
	beq $s6, 0xF4D03F, stop4
	beq $s6, 0x00FFFF, mosquitaEspecial # aqui tambien tomamos en cuenta la mosca especial
	beq $s6, 0xFF0040, mosquita
	jr $ra

	stop1:
	lw $t1, mapa($zero)
	add $t1, $t1, $t5
	lw $t2, rana
	sw $t2, ($t1)
	move $s7, $t5
	lw $s6, safe
	j loop

	stop2:
	lw $t1, mapa($zero)
	add $t1, $t1, $t5
	lw $t2, rana
	sw $t2, ($t1)
	move $s7, $t5
	lw $s6, 4($t1)
	j loop

	stop3:
	lw $t1, mapa($zero)
	add $t1, $t1, $t5
	lw $t2, rana
	sw $t2, ($t1)
	move $s7, $t5
	lw $s6, -4($t1)
	j loop

	stop4:
	lw $t1, mapa($zero)
	add $t1, $t1, $t5
	lw $t2, rana
	sw $t2, ($t1)
	move $s7, $t5
	lw $s6, tronco
	j loop

	goal:
	lw $t8, goalsLlegados
	add $t8, $t8, 1
	sw $t8, goalsLlegados
	lw $t9, puntuacion
	addi $t9, $t9, 60
	sw $t9, puntuacion
	lw $t2, llegadaOk
	sw $t2, ($t1)
	  beq $t8, 4, ganar
	j recargarMapa

	perderVida:
	lw $t9, vidasNum
	addi $t9, $t9, -1
	sw $t9, vidasNum
	beq $t9, 2, lost1
	beq $t9, 1, lost2
	beq $t9, 0, lost3
	j recargarMapa

	lost1:
	lw $t2, vidaNo
	lw $t1, mapa($zero)
	addi $t1, $t1, 88
	sw $t2, ($t1)
	j recargarMapa

	lost2:
	lw $t2, vidaNo
	lw $t1, mapa($zero)
	addi $t1, $t1, 80
	sw $t2, ($t1)
	j recargarMapa

	lost3:
	lw $t2, vidaNo
	lw $t1, mapa($zero)
	addi $t1, $t1, 72
	sw $t2, ($t1)
	li $v0, 56
	la $a0, perdiste
	lw $t9, puntuacion
	move $a1, $t9
	syscall
	li $v0, 56
	la $a0, tiempoJugado
	lw $t9, tiempo
	li $s5, 1000
	div $t9, $s5
	mflo $a1
	syscall
	j terminarPartida

	ganar:
	li $v0, 56
	la $a0, ganaste
	lw $t9, puntuacion
	move $a1, $t9
	syscall
	li $v0, 56
	la $a0, tiempoJugado
	lw $t9, tiempo
	li $s5, 1000
	div $t9, $s5
	mflo $a1
	syscall
	j terminarPartida

# la mosca especial nos da 45 puntos
mosquitaEspecial:
    li $t0, 45
    j sumarPuntosMosca

# la normal sigue dando 15 puntos
mosquita:
    li $t0, 15

# sumamos los puntos segun la mosca que comimos
sumarPuntosMosca:
    lw $t9, puntuacion
    add $t9, $t9, $t0
	sw $t9, puntuacion
	lw $t2, rana
	sw $t2, ($t1)
	lw $t9, mapa($zero)
	addi $t9, $t9, 640
	blt $t1, $t9, caso1
	lw $t9, mapa($zero)
	addi $t9, $t9, 704
	bgt $t1, $t9, caso1
	lw $s6, calle2
	j loop

	caso1:
	lw $s6, calle1
	j loop

	crearCarro1:
	lw $t4, mapa($zero)
	addi $t4, $t4, 708
	lw $t4, 8($t4)
	beq $t4, 0xB9A029, regresar
	lw $t4, random1
	lw $t6, tiempo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar

	lw $t6, mapa($zero)
	addi $t6, $t6, 708
	lw $t6, ($t6)
	beq $t6, 0xA93226, perderVida
	pintar(708, carro)
	randomAdentro(random1)
	j regresar

	moverCarro1:
	lw $t6, tiempo
	lw $t4, tiempoVehiculo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar

	lw $t6, mapa($zero)
	addi $t6, $t6, 756
	li $s3, 0

	movimiento1:
	lw $t3, ($t6)
	beq $s3, 13, continuar1
	addi $s3, $s3, 1
	beq $t3, 0xB9A029, car1
	beq $t3, 0x424949, cal1
	beq $t3, 0xA93226, ran1
	beq $t3, 0x00FFFF, mos1 # aqui tambien tomamos en cuenta la mosca especial
	beq $t3, 0xFF0040, mos1

	mos1:
	lw $t2, calle1
	lw $t9, 4($t6)
	beq $t9, 0xA93226, mos11
	sw $t2, 4($t6)
	mos11:
	addi $t6, $t6, -4
	j movimiento1

	ran1:
	lw $t2, calle1
	lw $t9, 4($t6)
	beq $t9, 0x00FFFF, ran11 # aqui tambien tomamos en cuenta la mosca especial
	beq $t9, 0xFF0040, ran11
	sw $t2, 4($t6)
	ran11:
	addi $t6, $t6, -4
	j movimiento1

	car1:
	lw $t2, carro
	lw $t9, 4($t6)
	beq $t9, 0xA93226, perderVida
	sw $t2, 4($t6)
	addi $t6, $t6, -4
	j movimiento1

	cal1:
	lw $t2, calle1
	lw $t9, 4($t6)
	beq $t9, 0x00FFFF, cal11 # aqui tambien tomamos en cuenta la mosca especial
	beq $t9, 0xFF0040, cal11
	beq $t9, 0xA93226, cal11
	sw $t2, 4($t6)

	cal11:
	addi $t6, $t6, -4
	j movimiento1

	continuar1:
	lw $t6, mapa($zero)
	addi $t6, $t6, 708
	lw $t2, ($t6)
	lw $t3, 4($t6)
	beq $t2, $t3, P1
	j regresar

	P1:
	bne $t3, 0xB9A029, regresar
	li $v0, 32
	li $a0, 30
	syscall
	lw $t9, 8($t6)
	beq $t9, 0xA93226, perderVida
	lw $t4, calle1
	sw $t4, ($t6)
	lw $t4, carro
	sw $t4, 8($t6)

	regresar:
	jr $ra

	crearCarro3:
	lw $t4, mapa($zero)
	addi $t4, $t4, 580
	lw $t4, 8($t4)
	beq $t4, 0xB9A029, regresar3
	lw $t4, random3
	lw $t6, tiempo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar3

	lw $t6, mapa($zero)
	addi $t6, $t6, 580
	lw $t6, ($t6)
	beq $t6, 0xA93226, perderVida
	pintar(580, carro)
	randomAdentro(random3)
	j regresar3

	moverCarro3:
	lw $t6, tiempo
	lw $t4, tiempoVehiculo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar3

	lw $t6, mapa($zero)
	addi $t6, $t6, 628
	li $s3, 0

	movimiento3:
	lw $t3, ($t6)
	beq $s3, 13, continuar3
	addi $s3, $s3, 1
	beq $t3, 0xB9A029, car3
	beq $t3, 0x424949, cal3
	beq $t3, 0xA93226, ran3
	beq $t3, 0x00FFFF, mos3 # aqui tambien tomamos en cuenta la mosca especial
	beq $t3, 0xFF0040, mos3

	mos3:
	lw $t2, calle1
	lw $t9, 4($t6)
	beq $t9, 0xA93226, mos33
	sw $t2, 4($t6)
	mos33:
	addi $t6, $t6, -4
	j movimiento3

	ran3:
	lw $t2, calle1
	lw $t9, 4($t6)
	beq $t9, 0x00FFFF, ran33 # aqui tambien tomamos en cuenta la mosca especial
	beq $t9, 0xFF0040, ran33
	sw $t2, 4($t6)
	ran33:
	addi $t6, $t6, -4
	j movimiento3

	car3:
	lw $t2, carro
	lw $t9, 4($t6)
	beq $t9, 0xA93226, perderVida
	sw $t2, 4($t6)
	addi $t6, $t6, -4
	j movimiento3

	cal3:
	lw $t2, calle1
	lw $t9, 4($t6)
	beq $t9, 0x00FFFF, cal33 # aqui tambien tomamos en cuenta la mosca especial
	beq $t9, 0xFF0040, cal33
	beq $t9, 0xA93226, cal33
	sw $t2, 4($t6)

	cal33:
	addi $t6, $t6, -4
	j movimiento3

	continuar3:
	lw $t6, mapa($zero)
	addi $t6, $t6, 580
	lw $t2, ($t6)
	lw $t3, 4($t6)
	beq $t2, $t3, P3
	j regresar3

	P3:
	bne $t3, 0xB9A029, regresar3
	li $v0, 32
	li $a0, 30
	syscall
	lw $t9, 8($t6)
	beq $t9, 0xA93226, perderVida
	lw $t4, calle1
	sw $t4, ($t6)
	lw $t4, carro
	sw $t4, 8($t6)

	regresar3:
	jr $ra

	crearCamion2:
	lw $t4, mapa($zero)
	addi $t4, $t4, 696
	lw $t4, -12($t4)
	beq $t4, 0x1F5DB6, regresar2
	lw $t4, random2
	lw $t6, tiempo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar2

	lw $t6, mapa($zero)
	addi $t6, $t6, 696
	lw $t6, ($t6)
	beq $t6, 0xA93226, perderVida
	pintar(696, camion)
	pintar(692, camion)
	randomAdentro(random2)
	j regresar2

	moverCamion2:
	lw $t6, tiempo
	lw $t4, tiempoVehiculo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar2

	lw $t6, mapa($zero)
	addi $t6, $t6, 648
	li $s3, 0

	movimiento2:
	lw $t3, ($t6)
	beq $s3, 13, continuar2
	addi $s3, $s3, 1
	beq $t3, 0x1F5DB6, cam2
	beq $t3, 0x515A5A, cal2
	beq $t3, 0xA93226, ran2
	beq $t3, 0x00FFFF, mos2 # aqui tambien tomamos en cuenta la mosca especial
	beq $t3, 0xFF0040, mos2

	mos2:
	lw $t2, calle2
	lw $t9, -4($t6)
	beq $t9, 0xA93226, mos22
	sw $t2, -4($t6)
	mos22:
	addi $t6, $t6, 4
	j movimiento2

	ran2:
	lw $t2, calle2
	lw $t9, -4($t6)
	beq $t9, 0x00FFFF, ran22 # aqui tambien tomamos en cuenta la mosca especial
	beq $t9, 0xFF0040, ran22
	sw $t2, -4($t6)
	ran22:
	addi $t6, $t6, 4
	j movimiento2

	cam2:
	lw $t2, camion
	lw $t9, -4($t6)
	beq $t9, 0xA93226, perderVida
	sw $t2, -4($t6)
	addi $t6, $t6, 4
	j movimiento2

	cal2:
	lw $t2, calle2
	lw $t9, -4($t6)
	beq $t9, 0x00FFFF, cal22 # aqui tambien tomamos en cuenta la mosca especial
	beq $t9, 0xFF0040, cal22
	beq $t9, 0xA93226, cal22
	sw $t2, -4($t6)

	cal22:
	addi $t6, $t6, 4
	j movimiento2

	continuar2:
	lw $t6, mapa($zero)
	addi $t6, $t6, 696
	lw $t2, ($t6)
	lw $t3, -4($t6)
	bne $t2, $t3, regresar2
	lw $t2, -8($t6)
	beq $t2, $t3, P2
	j regresar2

	P2:
	bne $t3, 0x1F5DB6, regresar2
	li $v0, 32
	li $a0, 30
	syscall
	lw $t9, -12($t6)
	beq $t9, 0xA93226, perderVida
	lw $t4, calle2
	sw $t4, ($t6)
	lw $t4, camion
	sw $t4, -8($t6)
	sw $t4, -12($t6)
	regresar2:
	jr $ra

	crearTronco4:
	lw $t4, mapa($zero)
	addi $t4, $t4, 504
	lw $t4, -12($t4)
	beq $t4, 0x2F0701, regresar4
	lw $t4, random4
	lw $t6, tiempo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar4
	pintar(504, tronco)
	pintar(500, tronco)
	randomAdentro(random4)
	j regresar4

	moverTronco4:
	lw $t6, tiempo
	lw $t4, tiempoTronco
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar4

	lw $t6, mapa($zero)
	addi $t6, $t6, 456
	li $s3, 0
	lw $t9, mapa($zero)
	addi $t9, $t9, 452
	lw $t8, ($t9)
	beq $t8, 0xA93226, perderVida

	movimiento4:
	lw $t3, ($t6)
	beq $s3, 13, continuar4
	addi $s3, $s3, 1
	beq $t3, 0xA93226, ran4

	sw $t3, -4($t6)
	addi $t6, $t6, 4
	j movimiento4

	ran4:
	sw $t3, -4($t6)
	addi $t6, $t6, 4
	addi $s7, $s7, -4
	j movimiento4

	continuar4:
	lw $t6, mapa($zero)
	addi $t6, $t6, 504
	lw $t2, ($t6)
	beq $t2, 0xA93226, continuar41
	lw $t3, -4($t6)
	beq $t3, 0xA93226, continuar42
	bne $t2, $t3, regresar4
	lw $t2, -8($t6)
	beq $t2, $t3, P4
	j regresar4

	P4:
	bne $t3, 0x2F0701, regresar4
	li $v0, 32
	li $a0, 100
	syscall
	lw $t4, rio1
	sw $t4, ($t6)
	lw $t4, tronco
	sw $t4, -8($t6)
	sw $t4, -12($t6)
	j regresar4

	continuar41:
	li $v0, 32
	li $a0, 100
	syscall
	lw $t4, rio1
	sw $t4, ($t6)
	lw $t8, rana
	lw $t4, tronco
	addi $s7, $s7, -8
	sw $t8, -8($t6)
	sw $t4, -12($t6)
	j regresar4

	continuar42:
	li $v0, 32
	li $a0, 100
	syscall
	lw $t4, rio1
	sw $t4, ($t6)
	lw $t8, rana
	lw $t4, tronco
	addi $s7, $s7, -8
	sw $t4, -4($t6)
	sw $t4, -8($t6)
	sw $t8, -12($t6)

	regresar4:
	jr $ra

	crearTronco5:
	lw $t4, mapa($zero)
	addi $t4, $t4, 388
	lw $t4, 12($t4)
	beq $t4, 0x2F0701, regresar5
	lw $t4, random5
	lw $t6, tiempo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar5
	pintar(388, tronco)
	pintar(392, tronco)
	randomAdentro(random5)
	j regresar5

	moverTronco5:
	lw $t6, tiempo
	lw $t4, tiempoTronco
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar5

	lw $t6, mapa($zero)
	addi $t6, $t6, 436
	li $s3, 0
	lw $t9, mapa($zero)
	addi $t9, $t9, 440
	lw $t8, ($t9)
	beq $t8, 0xA93226, perderVida

	movimiento5:
	lw $t3, ($t6)
	beq $s3, 13, continuar5
	addi $s3, $s3, 1
	beq $t3, 0xA93226, ran5

	sw $t3, 4($t6)
	addi $t6, $t6, -4
	j movimiento5

	ran5:
	sw $t3, 4($t6)
	addi $t6, $t6, -4
	addi $s7, $s7, 4
	j movimiento5

	continuar5:
	lw $t6, mapa($zero)
	addi $t6, $t6, 388
	lw $t2, ($t6)
	lw $t3, 4($t6)
	bne $t2, $t3, regresar5
	lw $t2, 8($t6)
	beq $t2, $t3, P5
	j regresar5

	P5:
	bne $t3, 0x2F0701, regresar5
	li $v0, 32
	li $a0, 100
	syscall
	lw $t4, rio1
	sw $t4, ($t6)
	lw $t4, tronco
	sw $t4, 8($t6)
	sw $t4, 12($t6)
	regresar5:
	jr $ra

	crearTronco6:
	lw $t4, mapa($zero)
	addi $t4, $t4, 376
	lw $t4, -12($t4)
	beq $t4, 0x2F0701, regresar6
	lw $t4, random6
	lw $t6, tiempo
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar6
	pintar(376, tronco)
	pintar(372, tronco)
	randomAdentro(random6)
	j regresar6

	moverTronco6:
	lw $t6, tiempo
	lw $t4, tiempoTronco
	div $t6, $t4
	mfhi $t6
	bnez $t6, regresar6

	lw $t6, mapa($zero)
	addi $t6, $t6, 328
	li $s3, 0
	lw $t9, mapa($zero)
	addi $t9, $t9, 324
	lw $t8, ($t9)
	beq $t8, 0xA93226, perderVida

	movimiento6:
	lw $t3, ($t6)
	beq $s3, 13, continuar6
	addi $s3, $s3, 1
	beq $t3, 0xA93226, ran6

	sw $t3, -4($t6)
	addi $t6, $t6, 4
	j movimiento6

	ran6:
	sw $t3, -4($t6)
	addi $t6, $t6, 4
	addi $s7, $s7, -4
	j movimiento6

	continuar6:
	lw $t6, mapa($zero)
	addi $t6, $t6, 376
	lw $t2, ($t6)
	lw $t3, -4($t6)
	bne $t2, $t3, regresar6
	lw $t2, -8($t6)
	beq $t2, $t3, P6
	j regresar6

	P6:
	bne $t3, 0x2F0701, regresar6
	li $v0, 32
	li $a0, 100
	syscall
	lw $t4, rio1
	sw $t4, ($t6)
	lw $t4, tronco
	sw $t4, -8($t6)
	sw $t4, -12($t6)
	regresar6:
	jr $ra

	generarMosquita:
	addi $t8, $zero, 0
	lw $t4, tiempo
	lw $t6, tiempoMosca
	div $t4, $t6
	mfhi $t6
	bnez $t6, regresar7

	generarRandom:
	li $v0, 30
	syscall
	li $v0, 42
	li $a1, 45
	syscall
	mul $t8, $a0, 4
	addi $t8, $t8, 580
	lw $t9, mapa($zero)
	add $t9, $t9, $t8
	lw $t4, ($t9)
	beq $t4, 0xA93226 ,generarRandom
	beq $t4, 0xB9A029 ,generarRandom
	beq $t4, 0x1F5DB6 ,generarRandom
	beq $t4, 0x000001 ,generarRandom
	beq $t4, 0x000002 ,generarRandom

    # salen dos moscas normales y despues una especial
    lw $t4, moscasGeneradas
    addi $t4, $t4, 1
    sw $t4, moscasGeneradas
    li $t6, 3
    blt $t4, $t6, generarMoscaNormal
    sw $zero, moscasGeneradas
    lw $t6, colorMoscaEspecial
    j pintarMoscaElegida

generarMoscaNormal:
    lw $t6, mosca

pintarMoscaElegida:
    sw $t6, ($t9)

	regresar7:
	jr $ra

	terminarPartida:
	# antes de volver a jugar revisamos el record
	jal actualizarRecord
	li $v0, 50
	la $a0, pregunta
	syscall
	beq $a0, 0, inicioJuego
	li $v0, 10
	syscall

	pintarBienvenida:

	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()

	li $v0 32
	li $a0, 600
	syscall

	pintar(8, letra)
	pintar(12, letra)
	pintar(16, letra)
	pintar(24, letra)

	pintar(984, letra)
	pintar(988, letra)
	pintar(992, letra)
	pintar(1000, letra)
	pintar(1004, letra)
	pintar(1008, letra)

	li $v0 32
	li $a0, 600
	syscall

	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()

	pintar(72, letra)
	pintar(76, letra)
	pintar(80, letra)
	pintar(88, letra)

	pintar(920, letra)
	pintar(924, letra)
	pintar(928, letra)
	pintar(936, letra)
	pintar(940, letra)
	pintar(944, letra)

	pintar(8, letra)
	pintar(24, letra)
	pintar(28, letra)

	pintar(984, letra)
	pintar(992, letra)
	pintar(1000, letra)
	pintar(1008, letra)

	li $v0 32
	li $a0, 600
	syscall

	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()

	pintar(1008, letra)
	pintar(1000, letra)
	pintar(1004, letra)
	pintar(1012, letra)
	pintar(992, letra)
	pintar(984, letra)
	pintar(944, letra)
	pintar(936, letra)
	pintar(924, letra)
	pintar(920, letra)
	pintar(880, letra)
	pintar(872, letra)
	pintar(864, letra)
	pintar(856, letra)
	pintar(816, letra)
	pintar(812, letra)
	pintar(808, letra)
	pintar(800, letra)
	pintar(796, letra)
	pintar(792, letra)
	pintar(152, letra)
	pintar(156, letra)
	pintar(216, letra)
	pintar(200, letra)
	pintar(204, letra)
	pintar(208, letra)
	pintar(136, letra)
	pintar(88, letra)
	pintar(72, letra)
	pintar(24, letra)
	pintar(28, letra)
	pintar(32, letra)
	pintar(8, letra)
	pintar(12, letra)
	pintar(16, letra)

	li $v0 32
	li $a0, 600
	syscall

	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()

	pintar(944, letra)
	pintar(948, letra)
	pintar(940, letra)
	pintar(936, letra)
	pintar(928, letra)
	pintar(920, letra)
	pintar(880, letra)
	pintar(872, letra)
	pintar(860, letra)
	pintar(856, letra)
	pintar(816, letra)
	pintar(808, letra)
	pintar(800, letra)
	pintar(792, letra)
	pintar(752, letra)
	pintar(748, letra)
	pintar(744, letra)
	pintar(736, letra)
	pintar(732, letra)
	pintar(728, letra)
	pintar(280, letra)
	pintar(272, letra)
	pintar(268, letra)
	pintar(264, letra)
	pintar(220, letra)
	pintar(216, letra)
	pintar(200, letra)
	pintar(152, letra)
	pintar(136, letra)
	pintar(96, letra)
	pintar(92, letra)
	pintar(88, letra)
	pintar(80, letra)
	pintar(76, letra)
	pintar(72, letra)

	li $v0 32
	li $a0, 1500
	syscall

	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	lw $t2, carga
	addi $s4, $t1, 900
	addi $s5, $t1, 904
	carga1:
	sw $t2, ($s4)
	sw $t2, ($s5)
	addi $s4, $s4, -64
	addi $s5, $s5, -64
	addi $t5, $t5, 1

	li $v0 32
	li $a0, 100
	syscall

	ble $t5, 7, carga1

	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	lw $t2, carga
	addi $s4, $t1, 460
	addi $s5, $t1, 524
	carga2:
	sw $t2, ($s4)
	sw $t2, ($s5)
	addi $s4, $s4, 4
	addi $s5, $s5, 4
	addi $t5, $t5, 1

	li $v0 32
	li $a0, 100
	syscall

	ble $t5, 11, carga2

	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	lw $t2, carga
	addi $s4, $t1, 436
	addi $s5, $t1, 440
	carga3:
	sw $t2, ($s4)
	sw $t2, ($s5)
	addi $s4, $s4, -64
	addi $s5, $s5, -64
	addi $t5, $t5, 1

	li $v0 32
	li $a0, 100
	syscall

	ble $t5, 5, carga3

	li $v0 32
	li $a0, 2000
	syscall

	jr $ra

# aqui escogemos facil, normal o dificil
seleccionarDificultad:
    li $v0, 51
    la $a0, menuDificultad
    syscall
    li $t0, -2
    # si cancelamos, queda en normal
    beq $a1, $t0, dificultadNormal
    # si escribimos algo que no sirve, preguntamos otra vez
    bnez $a1, seleccionarDificultad
    li $t0, 1
    beq $a0, $t0, dificultadFacil
    li $t0, 2
    beq $a0, $t0, dificultadNormal
    li $t0, 3
    beq $a0, $t0, dificultadDificil
    j seleccionarDificultad

# en facil los carros y troncos van mas despacio
dificultadFacil:
    li $t0, 400
    sw $t0, tiempoVehiculo
    li $t0, 1200
    sw $t0, tiempoTronco
    jr $ra

# en normal dejamos la velocidad del original
dificultadNormal:
    li $t0, 200
    sw $t0, tiempoVehiculo
    li $t0, 1000
    sw $t0, tiempoTronco
    jr $ra

# en dificil se mueven mas rapido
dificultadDificil:
    li $t0, 100
    sw $t0, tiempoVehiculo
    li $t0, 800
    sw $t0, tiempoTronco
    jr $ra

# dejamos la rana dibujada mientras el juego esta pausado
pausarJuego:
    lw $t1, mapa
    add $t1, $t1, $s7
    lw $t2, rana
    sw $t2, ($t1)
# esperamos otra p para seguir, o Esc para salir
esperarFinPausa:
    li $v0, 32
    li $a0, 20
    syscall
    li $t7, 0xffff0000
    lw $t8, 0($t7)
    andi $t8, $t8, 1
    beqz $t8, esperarFinPausa
    lw $t8, 4($t7)
    beq $t8, 27, salir
    beq $t8, 112, loop
    beq $t8, 80, loop
    j esperarFinPausa

# solo cambiamos el record si hicimos mas puntos
actualizarRecord:
    lw $t0, puntuacion
    lw $t1, recordMaximo
    ble $t0, $t1, mostrarRecord
    sw $t0, recordMaximo
# mostramos el record al terminar la partida
mostrarRecord:
    li $v0, 56
    la $a0, mensajeRecord
    lw $a1, recordMaximo
    syscall
    jr $ra
