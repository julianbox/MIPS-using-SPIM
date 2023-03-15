.data
    userInput: .space 20
    prompt1: .asciiz "Enter the amount of numbers you wish to sort: "
    prompt2: .asciiz "Enter the List of Integers 1 at a Time (press Enter after each Number): "
    prompt3: .asciiz "Entered: "
    prompt4: .asciiz "Sorted: "
    prompt5: .asciiz "\nSorting...\n"
    spacer:  .asciiz " " 
    iterator: .word 0
    error1: .asciiz "The Array is empty\n"
    exitMessage: .asciiz "\n--program exiting--"

.text
main:
    #print prompt1
    li $v0, 4              #4 is stored in $v0, 4 is a system call to print a string
    la $a0, prompt1        #prompt1 is stored in $a0
    syscall                #execute $a0

    #get number of integers
    li $v0, 5              #5 is stored in $v0, 5 is a system call to input an integer
    syscall                #execute $v0

    move $s0, $v0           #save the user entered number to sort in $v0 to $s0

    #allocate space to hold array based on entered number
    sll $a0, $v0, 2         #number of bytes now in $a0 = user entered integer X 4 (left bitwise shift in binary 2X2)
    move $s1, $a0           #$a is now in $s1 = user entered integer
    li  $v0, 9              #9 is now in $v0, 9 is the system call to store an address of allocated bytes
    syscall                 #execute $v0

                            #address of space now in $v0
    
    move $s2, $v0           #save address of allocated bytes in in $v0 to $s2
    
    #User is prompted to enter a list of integers
    li $v0, 4               #4 is stored in $v0, 4 is a system call to input an integer
    la $a0, prompt2         #prompt2 is stored in $a0
    syscall                 #execute $a0

    lw $t3, iterator        #iterator 0 is assigned to $t3
    move $t0, $s2           #move byte address in $s2 to $t0
    
    jal readArray           #jump to readArray, save return address in $ra

readArray:
    beq $t3, $s1, printArrayPrompt  #When iterator hits the end of the array branch to printArrayPrompt

    li $v0, 5               #5 is loaded into $v0, 5 is a system call to input an integer
    syscall                 #$v0 is executed and now contains user input
    sw $v0,  0($t0)         #store user input in $v0 into array address at $t0

    addi $t3, $t3, 4        #4 is added to $t3 and stored in $t3, adds 4 to iterator $t3
    addi $t0, $t0, 4        #4 is added to array address at $t0
    j readArray             #loop

printArrayPrompt:
    li $v0, 4               #4 is stored in $v0, 4 is a system call to user input
    la $a0, prompt3         #prompt3 is loaded into $a0
    syscall                 #$a0 is called
    lw $t3, iterator        #iterator is stored in $t3, $t3 is back to 0
    move $t0, $s2           #$s2 is moved to $t0, $t0 is set back base address
    j printArray1           #jump printArray1 loop

printArray1:
    beq $t3, $s1, sorter    #When iterator hits the end of the array branch to sorter
    lw $t1 0($t0)           #Load array address into $t1
    li $v0, 1               #1 is stored in $v0, 1 is a system call to output an integer
    move $a0, $t1           #Move array address in $t1 to $a0
    syscall                 #Execute $a0

    addi $t3, $t3, 4        #4 is added to $t3 and stored in $t3, adds 4 to iterator $t3
    addi $t0, $t0, 4        #4 is added to array address at $t0
    
    li $v0, 4               #4 is stored in $v0, 4 is a system call to input an integer
    la $a0, spacer          #spacer into $a0, puts space between each integer
    syscall                 #execute $a0

    j printArray1           #loop

sorter:
    li $v0, 4               #4 is stored in $v0, 4 is a system call to input an integer
    la $a0, prompt5         #prompt5 is loaded into $a0
    syscall                 #execute $a0
    move $a0, $s2           #saved base address to $a0 in preparation to call sort
    move $a1, $s0           #saved amount of numbers to sort into $a1 in preparation to call sort
    jal sort                #jumpt to sort save return address in $ra
    j printArrayPrompt2     #jumpt to printArrayPRompt2

printArrayPrompt2:
    li $v0, 4               #4 is stored in $v0, 4 is a system call to input an integer
    la $a0, prompt4         #prompt4 is loaded into $a0
    syscall                 #execute $a0
    lw $t3, iterator        #iterator is stored in $t3, $t3 is back to 0
    move $t0, $s2           #$s2 is moved to $t0, $t0 is set back base address
    j printArray2           #jumpt to printArray2 loop

printArray2:
    beq $t3, $s1, exit      #When iterator hits the end of the array branch to exit
    lw $t1 0($t0)           #Load array address into $t1
    li $v0, 1               #1 is stored in $v0, 1 is a system call to output an integer
    move $a0, $t1           ##Move array address in $t1 to $a0
    syscall                 #execute $a0

    addi $t3, $t3, 4        #4 is added to $t3 and stored in $t3, adds 4 to iterator $t3
    addi $t0, $t0, 4        #4 is added to array address at $t0
    
    li $v0, 4               #4 is stored in $v0, 4 is a system call to input an integer
    la $a0, spacer          #spacer into $a0, puts space between each integer
    syscall                 #execute $a0

    j printArray2           #loop

exit:
    li $v0, 4               #4 is stored in $v0, 4 is a system call to input an integer
    la $a0, exitMessage     #exitMessage stored in $a0
    syscall                 #execute $a0

    li $v0, 10              #10 is is loaded into $v0, 10 is a system call to exit
    syscall                 #progrm exits

swap: 
    sll $t1, $a1, 2   # $t1 = k * 4
    add $t1, $a0, $t1 # $t1 = v+(k*4)
            #   (address of v[k])
    lw $t0, 0($t1)    # $t0 (temp) = v[k]
    lw $t2, 4($t1)    # $t2 = v[k+1]
    sw $t2, 0($t1)    # v[k] = $t2 (v[k+1])
    sw $t0, 4($t1)    # v[k+1] = $t0 (temp)

    jr $ra            # return to calling routine

sort:    
    addi $sp,$sp, -20      # make room on stack for 5 registers
    sw $ra, 16($sp)        # save $ra on stack
    sw $s3,12($sp)         # save $s3 on stack
    sw $s2, 8($sp)         # save $s2 on stack
    sw $s1, 4($sp)         # save $s1 on stack
    sw $s0, 0($sp)         # save $s0 on stack
    move $s2, $a0           # save $a0 into $s2
    move $s3, $a1           # save $a1 into $s3
    move $s0, $zero         # i = 0

for1tst:
    slt  $t0, $s0, $s3      # $t0 = 0 if $s0 = $s3 (i = n)
    beq  $t0, $zero, exit1  # go to exit1 if $s0 = $s3 (i = n)
    addi $s1, $s0, -1       # j = i – 1

for2tst:
    slti $t0, $s1, 0        # $t0 = 1 if $s1 < 0 (j < 0)
    bne  $t0, $zero, exit2  # go to exit2 if $s1 < 0 (j < 0)
    sll  $t1, $s1, 2        # $t1 = j * 4
    add  $t2, $s2, $t1      # $t2 = v + (j * 4)
    lw   $t3, 0($t2)        # $t3 = v[j]
    lw   $t4, 4($t2)        # $t4 = v[j + 1]
    slt  $t0, $t4, $t3      # $t0 = 0 if $t4 = $t3
    beq  $t0, $zero, exit2  # go to exit2 if $t4 = $t3
    move $a0, $s2           # 1st param of swap is v (old $a0)
    move $a1, $s1           # 2nd param of swap is j
    jal  swap               # call swap procedure
    addi $s1, $s1, -1       # j –= 1
    j    for2tst            # jump to test of inner loop

exit2:
    addi $s0, $s0, 1        # i += 1
    j    for1tst            # jump to test of outer loop

exit1:
    lw $s0, 0($sp)  # restore $s0 from stack
    lw $s1, 4($sp)         # restore $s1 from stack
    lw $s2, 8($sp)         # restore $s2 from stack
    lw $s3,12($sp)         # restore $s3 from stack
    lw $ra,16($sp)         # restore $ra from stack
    addi $sp,$sp, 20    # restore stack pointer
    jr $ra                 # return to calling routine

