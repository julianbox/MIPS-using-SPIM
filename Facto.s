#Program to take user input as a number between 1-12 and compute the factorial of inputted number.
.data
	prompt1: .asciiz "Enter a number between 0-12: "
	prompt2: .asciiz "! = "
	error1Text: .asciiz "Input cannot be less than 0.\n"
	error2Text: .asciiz "Input cannot be greater than 12.\n"
.text


fact:    
	addi $sp, $sp, -8     # adjust stack for 2 items
	sw   $ra, 4($sp)      # save return address
	sw   $a0, 0($sp)      # save argument (~push)
	slti $t0, $a0, 1      # test for n < 1
	beq  $t0, $zero, L1
	addi $v0, $zero, 1    # if so, result is 1
	addi $sp, $sp, 8      #   pop 2 items from stack
	jr   $ra              #   and return
L1: 	
	addi $a0, $a0, -1     # else decrement n
	jal  fact             # recursive call
	lw   $a0, 0($sp)      # restore original n
	lw   $ra, 4($sp)      #   and return address
	addi $sp, $sp, 8      # pop 2 items from stack
	mul  $v0, $a0, $v0    # multiply to get result
	jr   $ra              # and return


main:
	li $v0, 4				#4 is loaded into $v0, 4 is a system call to print a string
	la $a0, prompt1			#prompt1 is loaded into $a0
	syscall					#useris prompted to enter a number between 1 and 12

	li $v0, 5				#5 is loaded into $v0, 5 is a system call to input an integer
	syscall					#$v0 is called to enter a integer
				
	move $a0, $v0			#$v0 is moved to $a0
	beq $a0, $zero, zeroFactorial	#Input is compared to zero. If it is branch to zeroFactorial

	li $t1, 12				#12 is moved to $t

	bgt $a0, $t1, error2	#Input is compared to 12 if it is greater than branch to display error2
	blt $a0, $zero, error1	#Input is compared to 0 if it is less than branch to display error1
	jal fact				#jump to fact and save return adress in $ra	

	li $v0, 1				#1 is loaded into $v0, 1 is a system call to ouput an integer
	syscall					#$vo ouputs an integer, the user inputted integer

	li $v0, 4				#4 is loaded into $v0, 4 is a system call to print a string
	la $a0, prompt2			#prompt2 is loaded into $a0
	syscall					#prompt2 is printed to console

	li $v0, 1				#1 is loaded into $v0, 1 is a system call to ouput an integer
	mflo $a0				#Lo is moved to $a0, result of fact is stored in LO
	syscall					#a0 is printed to console

	li $v0, 10				#10 is is loaded into $v0, 10 is a system call to exit
	syscall	 				#progrm exits

zeroFactorial:
	li $v0, 1				#1 is loaded into $v0
	syscall					#User input is printed to console

	li $v0, 4				#4 is loaded into $v0
	la $a0, prompt2			#prompt2 is loaded into $a0
	syscall					#prompt2 is printed to console

	li $v0, 1				#1 is loaded into $v0, 1 is a system call to ouput an integer
	li $a0, 1				#1 is loaded into $a0, 1 is a system call to ouput an integer
	syscall					#factorial  of 0 is printed to console

	li $v0, 10				#10 is loaded into $v0, 10 is a system call to exit
	syscall					#program exits

error1: 
	li $v0, 4				#4 is loaded into $v0
	la $a0, error1Text		#error1Text is loaded into $a0
	syscall					#error1Text is printed to console
	li $v0, 10				#10 is loaded into $v0, 10 is a system call to exit
	syscall					#progrm exits

error2:
	li $v0, 4				#4 is loaded into $v0
	la $a0, error2Text		#error2Text is loaded into $a0
	syscall					#error2Text is printed to console

	li $v0, 10				#10 is loaded into $v0, 10 is a system call to exit
	syscall					#program exits


