# 2640.01 Final Project (Hang Man)
#
# Name: Brian Song (ID:015118155), Justin Ta (ID:014967745)
# Date: 12/11/2022
# OBjectives: Create Hangman
#					- Get user input
#					- Compare and store
#					- Reset all values

.include "macroList.asm"
 
.data
	line: .asciiz "======================================================\n"
   noCheat: .asciiz "\n\nNo cheating! Game Start!!!!!\n\n\n"
   exitMsg: .asciiz "\n          Thanks for playing Hangman!         \n\n"
   guessMsg: .asciiz "\nGuess a letter for a "
   guessMsg2: .asciiz " letter word: "
   repromptMsg: .asciiz "\nChoose (1) to return to menu or (2) to exit: "
   livesMsg: .asciiz "Lives left: "
   matchMsg: .asciiz "\nMatch found\n"
   noMatchMsg: .asciiz "\nNot a match\n"
   loseMsg: .asciiz "\n            You've lost the game!            \n"
   userCharList: .space 50
   correctArr: .word '_':10
   correctBuff: .space 500
   userInput: .space 10
   buff: .space 500
   winMsg: .asciiz "\n        You've correctly guessed the word!      \n\n"
   getWordMsg: .asciiz "Enter a word to be played:"
   playWord: .space 50
   wrongInputMsg: .asciiz "\nYou already entered that letter! Please Try Again!\n"
   wrongMenuInp: .asciiz "\nPlease the number from the menu!\n"
   space: .asciiz "\n"
   space2: .asciiz " "
   errorMsg: .asciiz "Error Occured"
   flagg: .asciiz "1"
.text

main:
   start
   print(line)
   
   li $t0, 0					# General indicator. For main it used as main menu navigator
   li $t2, 6					# Lives
   li $t4, 0					# t4 - corrected char counter
   
   li $v0, 5
   syscall
   move $t0, $v0
   
   beq $t0, 1, getWord
   beq $t0, 2, exit
   								
wrongMenu:						# Wrong inputs goes through and jump back to main
	print(wrongMenuInp)
	j main
   
getWord:
   print(getWordMsg)
   getWordMac					# Get user input word
   la $s3, playWord 			# Store playword in $s3 to get word length
   
   createSpace
   print(noCheat)
   
   li $t1, 0					# For getWord * t1 * used as word length counter
   li $t0, 0					# General counter t0 to 0
   li $t3, 0					# First letter indicator ()
   
getWordLength:   				# Counts the length of the user inserted word
   lb $a0, ($s3)
   beqz $a0, fixLength
   addi $s3, $s3, 1
   addi $t1, $t1, 1
   j getWordLength
   
fixLength:
   sub $t1, $t1, 1						# Fixing the length since it ends with an addi 1
   j play
   
play:
	print(line)
   print(livesMsg)						# Display lives/chances to guess
   printInt($t2)    						# t2 number of lives
   											
   print(guessMsg)
   printInt($t1)
   print(guessMsg2)
   
   getString
   move $s1, $a0							# s1 will have the input char and will be stored in to s0
   addi, $t3, $t3, 1
   j loadNCheck
   
wrongInput:									#	If user put the same char than it asks to do enter again
	print(wrongInputMsg)
	print(guessMsg)
	printInt($t1)
   print(guessMsg2)
   getString
   move $s1, $a0
   
loadNCheck:									
	lb $t5, 0($s1)							# Loads Char input into t5. offset always be 0
	li $t0, 0								# Reset counter

dupCheckLoop:								# Checking for any Duplicates in the user input array
	lb $t6, userCharList($t0)			# t6 Used for loading each letter

	beq $t0, 20, storeInput				# Avoiding any infinite loop cases
	
	beq $t0, $t1, storeInput			# t1 has length of the word.
	beq $t5, $t6, wrongInput			# Compares with t5 - user Input and t6 - the Array of user Inputs

	addi $t0, $t0, 1
	j dupCheckLoop

storeInput:
   sb $t5, userCharList($t3)			# Stores user input in to the buffer space if its correct
	li $t7, 0
	li $s5, 0								# s5 using as boolean value 0 for true 1 for false
	
	j compare

compare:										# Loop through the word and begins to compares with the Answer
	lb $t6, playWord($t7)
	
	beq $t6, $t5, matchHelper			# If match found
	beq $t7, $t1, compareHelper		# If reaches end of the array

   add $t7, $t7, 1
   j compare
   
compareHelper:								# s5 indicates if the certain word has been stored or not
	beq $s5, 1, match						# If 1 it's not been stored yet
	beq $s5, 0, noMatch					# If 0 it stored or match not found
	
	j errorExit								# If non exits the program
	
matchHelper:								# Adds char into an array, update counter, set s5 to 1 for stored
	replace1($t6, $t7)
	addi $t7, $t7, 1
	addi $t4, $t4, 1 
	li $s5, 1
	j compare
	
match:										# Prints hangman, array of the corrected chars
	print(line)
	print(matchMsg)
	hangPrint($t2)
   la $t0, correctArr
   printArray1($t0, $t1)				# Print array of correct chars here
   										
   beq $t4, $t1, win 					# Compare if enough matches are found with word length, otherwise go back to play 
   j play
   
   
noMatch: 									# When there are no matches found in the user input
	print(line)
   print(noMatchMsg)						# -1 Lives
   sub $t2, $t2, 1			
   hangPrint($t2)
   blt $t2, 1, die
   j play
   
die:
	print(line)
   print(loseMsg)
   print(line)
   li $t2, 0								# Resetting counter/variables needed accordingly
   li $t3, '_'
   j reprompt
   
win:
	print(line)
   print(winMsg)
   print(line)
   li $t2, 0	
   li $t3, '_'
   j reprompt
   
reprompt:									#Ask user if they want to go back to menu or exit
   print(repromptMsg)
   print(space)
   
   li $v0, 5
   syscall
   move $t0, $v0
   
   beq $t0, 1, resetBuffer
   beq $t0, 2, exit
   
   
resetBuffer:								# Resets all the spaces/array for user inputs/stored inputs
	li $t1, 0
	sb $t1, userCharList($t2)
	sb $t1, userInput($t2)
	beq $t2, 200, resetArr1
	addi $t2, $t2, 1
   j resetBuffer
   
resetArr1:
	li $t2, 0
resetArr2:
   sb $t3, correctArr($t2)
   beq $t2, 200, main
   addi $t2, $t2, 4
   j resetArr2
   
   
errorExit:									# If certain loop/function does not do what it suppose to do
	print(errorMsg)
	li $v0, 10
	syscall
exit:											# End program
	print(line)
   print(exitMsg)
   print(line)
   li $v0, 10
   syscall
