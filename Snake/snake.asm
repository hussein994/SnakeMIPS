#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)


lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2 ###
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
lw $a0 speed #####3
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
speed :        .word 500       # speed of the snake in millisec 	
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur
GameOver:       .asciiz 	"GAME OVER :(  \nScore : "
tryagain :	.asciiz		"\nTry again ?"
.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################


majDirection:#	(Filtrage des preconditions du mouvement du snake)


lw $t0 snakeDir		# t0 == valeur de  snakeDir;



beq $a0 4 exit		# if $a0 == 4 then error ;
beq $a0 $t0 exit 	# if a0 == snakeDir then continue ;


beq $t0 3 caseLeft 	# if snakeDir == 3 then j tp caseLeft ;
beq $t0 2 caseDown	# if snakeDir == 2 then j tp caseDown ;
beq $t0 1 caseRight	# if snakeDir == 1 then j tp caseRight ;
beq $t0 0 caseUp  	# if snakeDir == 0 then j tp caseUp ;

caseLeft:
beq $a0 1 exit 		# if $a0 == 1(right) then exit ;
j store			# if false jump->store ;

caseDown:
beq $a0 0 exit		# if $a0 == 0(up) then exit ;
j store			# if false jump->store ;

caseUp:
beq $a0 2 exit		# if $a0 == 2(down) then exit ;
j store			# if false jump->store ;

caseRight:
beq $a0 3 exit 		# if $a0 == 3(left) then exit ;
j store			# if false jump->store ;

store:
sw $a0 snakeDir 	# store the value of a0 in snakeDir ;
j exit			# exit

# En haut, ... en bas, ... à gauche, ... à droite, ... ces soirées là ...
exit:			#continue
jr $ra 			# exit the function and continue the programe



############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################


updateGameStatus:#	(move snake , new candy-obstacle , if ate a candy)

sub $sp $sp 4			# free up some space
sw $ra ($sp)


lw $t0 tailleSnake		# load value tailleSnake in t0

moveBX:#	(for loop)

beq $t0 0 moveBY		# if tailleSnake == 0 j-> moveBY 
la $t1 snakePosX		# load adress of snakePosX in t1
li $t2 0			# t2 = 0
mul $t2 $t0 4			# t2 = tailleSnake * 4
add $t1 $t1 $t2			# snakePosX + (tailleSnake * 4)
li $t5 0			# t5 =  0
addi $t1 $t1 -4			# snakePosX - 4 
lw $t5 ($t1)			# load value of t1 in t5
sw $t5 4($t1)			# store value of t5 in 4(t1) 
addi $t0 $t0 -1			# sub 1 from tailleSnake 
j moveBX			# jump -> moveBX


moveBY:

lw $t0 tailleSnake		# load value of tailleSnake in t0

moveBY2:#	(for loop)

beq $t0 0 moveHead 		# if tailleSnake == 0 j-> moveHead
la $t1 snakePosY		# load adress of snakePosY in t1
li $t2 0			# t2 = 0
mul $t2 $t0 4			# t2 = tailleSnake * 4
add $t1 $t1 $t2			# snakePosY + (tailleSnake * 4)
li $t5 0			# t5 =  0
addi $t1 $t1 -4			# snakePosY - 4 
lw $t5 ($t1)			# load value of t1 in t5
sw $t5 4($t1)			# store value of t5 in 4(t1) 
addi $t0 $t0 -1			# sub 1 from tailleSnake 
j moveBY2			# jump -> moveBX 





moveHead:#	(Moving head of snake)


lw $t0 snakeDir

				# pos X and Y are reversed !!!
beq $t0 0 caseU			# if snakeDir == 0 then j->caseU ;
beq $t0 1 caseR			# if snakeDir == 1 then j->caseR ;
beq $t0 2 caseD			# if snakeDir == 2 then j->caseD ;
beq $t0 3 caseL			# if snakeDir == 3 then j->caseL ;


caseU :
lw $t1 snakePosX		# load value of posX in t1
addi $t1 $t1 1			# add 1 to t1
sw $t1 snakePosX		# store new value in PosX
j if_ate_candy			# jump -> if nake ate a candy


caseR  :
lw $t1 snakePosY		# load value of posY in t1
addi $t1 $t1 1			# add 1 to t1
sw $t1 snakePosY		# store new value in PosY
j if_ate_candy			# jump -> if nake ate a candy



caseL :
lw $t1 snakePosY		# load value of posY in t1
subi $t1 $t1 1			# add 1 to t1
sw $t1 snakePosY		# store new value in PosY
j if_ate_candy			# jump -> if nake ate a candy


caseD :
lw $t1 snakePosX		# load value of posX in t1
subi $t1 $t1 1			# add 1 to t1
sw $t1 snakePosX		# store new value in PosX
j if_ate_candy			# jump -> if nake ate a candy



if_ate_candy: #  (chek if snake ate a candy) 



lw $a2 candy			# candy position X
lw $a3 candy + 4		# candy position Y
lw $t1 snakePosX		# load value in snakePosX
lw $t2 snakePosY		# load value in snakePosY



beq $t1 $a2 condition_Y		# if snakePosX == candyPosX  then jump->condition_Y
j exitf				# exit

condition_Y:
beq $t2 $a3 ate_condition	# if snakePosY == candyPosY  then jump->ate_condition
j exitf				# exit




ate_condition:#   (if ate_candy == True then)


lw $t0 tailleSnake		# load value tailleSnakein t0
addi $t0 $t0 1 			# add 1 to t0
sw $t0 tailleSnake		# store new value in tailleSnake



jal newRandomObjectPosition	# new candy position
sw $v0 candy			# store new value in coordonne X (candy)
sw $v1 candy + 4		# store new value in coordonne Y (candy + 4)


# (generate new object  +  get the positionning we want with every iteration)


la $t5 obstaclesPosX		# load adress of obstaclesPosX in t5
la $t6 obstaclesPosY		# load adress of obstaclesPosY in t6

lw $t1 numObstacles		# load value of numObstacles in t1
mul $t2 $t1 4			# $t2 = (numbObstacle * 4)
add $t5 $t5 $t2			# obataclePosX =  obataclePosX + (numbObstacle * 4)

lw $t7 numObstacles		# load value of numObstacles in t7
mul $t2 $t7 4			# $t2 = (numbObstacle * 4)
add $t6 $t6 $t2			# obataclePosY =  obataclePosY + (numbObstacle * 4)




jal newRandomObjectPosition	# new obstacles positionning
sw $v0 ($t5)			# store new value in obstaclePos Y
sw $v1 ($t6)			# store new value in obstaclePos Y

lw $t3 numObstacles		# load value of numObstacles in t3
addi $t3 $t3 1			# add 1 to t3
sw $t3 numObstacles		# store new value in numObstacles



# score jeu +1 

lw $t5 scoreJeu 		# load value scoreJeu in t5
addi $t5 $t5 1			# add 1 to t5
sw $t5 scoreJeu			# store new value in scoreJeu


# Speed levels


lw $t8 speed			# load value of speed
addi $t8 $t8 -20		# sub 25 from it
sw $t8 speed 			# store the new value in speed





exitf :
lw $ra ($sp)			# stack pointer
addi $sp $sp 4			# refill stack
jr $ra				# exit function





############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################


conditionFinJeu:

# Aide: Remplacer cette instruction permet d'avancer dans le projet.


la $t1 snakePosX 		# adresse coordenate x ——––—–––– :  Registre pour allocer le snake dans la grille
la $t2 snakePosY 		# adresse coordenate y_________/
lw $t3 ($t1)	 		# value of the adresse x______/
lw $t4 ($t2)     		# value of the adresse y_____/



ifingrille:#     (Is the snake inside the grille ?)   (Conditions)

bgt $t3 15 error	    	# if $t1 <= 15 then jumpto error else next line;
bgt $t4 15 error	    	# if $t2 <=15 then jump to error else next line ;
			    	    
blt $t3 0 error	    		# if $t1 < 0 then jump to error else next line ;									    			    
blt $t4 0 error	    		# if $t2 < 0 then jump to error else next line ;	    
j label

label:

la $s1 obstaclesPosX 		# adresse coordenate x––––––––––– :  Registres pour allocer les obstacles dans la grilles
la $s2 obstaclesPosY 		# adresse coordenate y__________/
lw $s3 ($s1)	     		# value of the adresse x_______/ 
lw $s4 ($s2)	     		# value of the adresse y______/  
li $t8 0   	     		# counter 
lw $a2 numObstacles  		# valeur du numbre d'obstacles 
lw $t3 snakePosX     		# load value of snakePosX in t3
lw $t4 snakePosY     		# load value of snakePosY in t3



incontact_with_ob:#     (Incontact with an obstacle ?)


beq $a2 $t8 pre_contact_with_snake	# if numObstacles == counter jump incontact_with_ob else next line ; (counter loop)


bne $t3 $s3 increment_ob   		# if $t3 =! $s3 then increment  by  4 else next line ;
bne $t4 $s4 increment_ob  		# if $t4 =! $s4 then increment  by  4 else error ;
j error			    		# jump to error if conditions check out ;



increment_ob:#		(Move in the memory adress)	
	    	    
addi $s1 $s1 4		    	# Add 4 to $s1 to move in the memory by 1 and get the next value to load in $s3 ;
addi $s2 $s2 4			# Add 4 to $s2 to move in the memory by 1 and get the next value to load in $s4 ;
lw $s3 ($s1)			# load value from adress in s3
lw $s4 ($s2)			# load value from adress in s4
addi $t8 $t8 1			# add 1 to counter ;
j incontact_with_ob		# jump back until counter == numObstacles



pre_contact_with_snake :



lw $t0 snakePosX  	# –––––––––––––––––––: The head of the snake stored in t0 and t1
lw $t1 snakePosY  	# __________________/
la $t3 snakePosX  	# adress of posX
la $t4 snakePosY  	# adress  of posY
lw $t6 4($t3)     	# value of the adress + 4 bytes
lw $t7 4($t4)     	# value of the adress + 4 bytes
lw $s7 tailleSnake	# counter limit ;
li $t9 0	  	# counter ;



contact_with_snake :#    (Check to see if the head hits its body)



beq $s7 $t9 continue		# if taillesnake == counter then continue else next line ;


addi $t9 $t9 1			# add 1 because we skipped the head of the snake  ;
bne $t0 $t6 increment_sXY 	# if t0 =! t1 jump to increment_sXY ;
bne $t1 $t7 increment_sXY	# if t1 =! t2 jump to increment_sXY ;
j error  			# jump to error if conditions check out ;

increment_sXY :
addi $t3 $t3 4			# increment by 4 to move by 1 in the table ;
lw $t6 ($t3)			# load new value(PosX)
addi $t4 $t4 4 			# increment by 4 to move by 1 in the table ;	
lw $t7 ($t4)			# load new value(PosY)
j contact_with_snake



continue:
li $v0 0			# continue with the game ;
j exitfunction			# then exit the function ;

error:
li $v0 1			# store 1 in v0 to indicate there's an error

exitfunction:
jr $ra				# exit function


############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
li $v0 4		# load imidiate 4 in v0
la $a0 GameOver 	# load adresse gameOver in a0
syscall

li $v0 1		# load imidiate 1 in v0
lw $a0 scoreJeu 	# load word scoreJeu in a0
syscall

li $v0 4		# load imidiate 4 in v0
la $a0 tryagain 	# load adresse tryagain in a0
syscall
# Fin.

jr $ra			# exit function
