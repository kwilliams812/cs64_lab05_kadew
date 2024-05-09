# print_array.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
# Data Area.  
# Note that while this is typically only for global immutable data, 
# for SPIM, this also includes mutable data.
# DO NOT MODIFY THIS SECTION
input: 
    .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
length:
    .word 15
fizz:   .asciiz "Fizz "
buzz:   .asciiz "Buzz "
fizzbuzz:   .asciiz "FizzBuzz "
space:  .asciiz " "
ack:    .asciiz "\n"


.text
FizzBuzz:
    move $t0 $a0
    move $t1 $a1

    

    li $t2, 0
    forloop:
        bge $t2, $t1, endforloop

        li $t4, 5
        lw $t3, 0($t0)
        div $t3, $t4
        mfhi $t5
        beq $t5, $zero, divbyfive
        # not div by five
        li $t4, 3
        div $t3, $t4
        mfhi $t5
        beq $t5 $zero, divbythree
        # not div by either
            li $v0, 1
            move $a0, $t3
            syscall
            li $v0, 4
            la $a0, space
            syscall
            j endnested
        divbythree:
            li $v0, 4
            la $a0, fizz
            syscall
            j endnested

        divbyfive:
            li $t4, 3
            div $t3, $t4
            mfhi $t5
            beq $t5 $zero, divbyboth
            li $v0, 4
            la $a0, buzz
            syscall

        divbyboth:
            li $v0, 4
            la $a0, fizzbuzz
            syscall

        endnested:

        addiu $t0, $t0, 4
        add $t2, $t2, 1
        j forloop
    endforloop:

    syscall

    return:
        jr $ra


main:
    #DO NOT MODIFY THIS
    la $a0 input
    lw $a1 length
    jal FizzBuzz
    j exit

exit:
    la $a0 ack
    li $v0 4
    syscall
	li $v0 10 
	syscall

