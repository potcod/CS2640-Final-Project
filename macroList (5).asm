########################## I/O Macro
.macro print(%str)
li $v0, 4
la $a0, %str
syscall
.end_macro

.macro printInt(%int)
li $v0, 1
move $a0, %int
syscall
.end_macro

.macro getString
li $v0, 8
la $a0, userInput
la $a1, 11
syscall
.end_macro

.macro printInt(%int)
li $v0, 1
move $a0, %int
syscall
.end_macro

.macro getWordMac
li $v0, 8
la $a0, playWord
la $a1, 11
syscall
 .end_macro
############################ Array Macro
.macro replace1(%char, %arrIndex)				# Replace an empty array of underscores with the char parameter
li $s7, 1
mul $s7, %arrIndex, 4
sb %char, correctArr($s7)
.end_macro

.macro printArray1(%word, %length)				# Prints the corrected letter

.data
	space: .asciiz "\n"
.text
la $s7, correctArr
li $t3, 0

loop:
	beq $t3, $t1, dropEnd
	beq $t3, 20, infEnd							# Incase it goes infinite
	
	li $v0, 4
	la $a0, ($s7)
	syscall
	
	addi, $t3, $t3, 1
	addi, $s7, $s7, 4
	
	print(space2)
	
	j loop
infEnd:
	print(flagg)
dropEnd:
	print(space)
	# Void
.end_macro

###################### Print macros

.macro hangPrint(%int)

.data
	hang1: .asciiz "  +---+\n"
	hang2: .asciiz "      |\n"
   hang3: .asciiz "  O   |\n"
   hang4: .asciiz "  |   |\n"
   hang5: .asciiz " /|   |\n"
   hang6: .asciiz " /|\\  |\n"
   hang7: .asciiz " /    |\n"
   hang8: .asciiz " / \\  |\n"
   hang9: .asciiz "     _|_\n"
.text
	beq %int, 6, live1
	beq %int, 5, live2
	beq %int, 4, live3
	beq %int, 3, live4
	beq %int, 2, live5
	beq %int, 1, live6
	beq %int, 0, live7
	
live1:
	print(hang1)
	print(hang4)
	print(hang2)
	print(hang2)
	print(hang2)
	print(hang9)
	j dropEnd
	
live2:
	print(hang1)
	print(hang4)
	print(hang3)
	print(hang2)
	print(hang2)
	print(hang9)
	j dropEnd
	
live3:
	print(hang1)
	print(hang4)
	print(hang3)
	print(hang4)		
	print(hang2)
	print(hang9)
	j dropEnd

live4:
	print(hang1)
	print(hang4)
	print(hang3)
	print(hang5)		
	print(hang2)
	print(hang9)
	j dropEnd
	
live5:
	print(hang1)
	print(hang4)
	print(hang3)
	print(hang6)		
	print(hang2)
	print(hang9)
	j dropEnd
	
live6:
	print(hang1)
	print(hang4)
	print(hang3)
	print(hang6)		
	print(hang7)
	print(hang9)
	j dropEnd

live7:
	print(hang1)
	print(hang4)
	print(hang3)
	print(hang6)		
	print(hang8)
	print(hang9)
	j dropEnd
	
dropEnd:
	# Void
.end_macro

.macro start

.data
	line: .asciiz "======================================================\n"
	title0: .asciiz "     __   __  _____    ___   _   _______\n"
	title1: .asciiz "    / /  / / / _  |   /   |/ /  / /   \\ \\\n"
	title2: .asciiz "   / /__/ / / /_| |  / /| | /  | |   ____   \n"
	title3: .asciiz "  / ___  / / /__| | / / |  /   | |     | | \n"
	title4: .asciiz " /_/  /_/ /_/   |_|/_/  |_/     \\_\\___/_/ \n"
	title5: .asciiz "    ____  ___     ____     ___  __   +-----+         \n"
	title6: .asciiz "   /   | /   |   / _  |   /   |/ /   |     |     \n  "
	title7: .asciiz "/ /| |/ /| |  / /_| |  / /| | /    O     | \n"
	title8: .asciiz " / / |   / | | / /__| | / / |  /    /|\\    |    \n"
	title9: .asciiz "/_/  |__/  |_|/_/   |_|/_/  |_/     / \\    |   \n"
	title10:.asciiz "                                          _|_\n"
	welcomeMsg: .asciiz "Welcome to Hangman!\n Please Enter \n"
   menu2: .asciiz "(1) to MANUAL PLAY\n"
   menu3: .asciiz "(2) to EXIT game\n"
.text
print(line)
print(title0)
print(title1)
print(title2)
print(title3)
print(title4)
print(title5)
print(title6)
print(title7)
print(title8)   
print(title9)
print(title10)
print(line)
print(welcomeMsg)
print(menu2)
print(menu3)
.end_macro

.macro createSpace
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
print(space)
.end_macro

