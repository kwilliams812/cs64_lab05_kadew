# print_array.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
# Data Area.  
# Note that while this is typically only for global immutable data, 
# for SPIM, this also includes mutable data.
input: 
	.word -72 13 -68 27 94 -49 8 37
filter: 
	.word -63 27 44
output: 
	.word 0 0 0 0 0 0
output_length:
	.word 6
ack: .asciiz "\n"
space: .asciiz " "


.text
conv:
	# load addresses into t0, t1, t2
    # input, filter and output respectively
	move $t0 $a0
    move $t1 $a1
    move $t2 $a2
    # load len of results
    move $t3 $a3
    
    li $t4, 0
    forloopi:
    bge, $t4, $t3, endforloopi

        li $t5, 0
        li $s7, 3
        forloopj:
        bge $t5, $s7, endforloopj

        #Result[i] += inp[i+j] * filt[j]
        addu $t6 $t4 $t5
        li $s1 4
        mult $s1, $t6
        mflo $t6
        addu $t6 $t6 $t0
        lw $t6 0($t6)


        addu $t7 $zero $t5
        mult $s1, $t7
        mflo $t7
        addu $t7 $t7 $t1
        lw $t7 0($t7)

        mult $t6 $t7
        mflo $t7

        mult $s1, $t4
        mflo $t6
        addu $t6, $t6, $t2
        lw $s0 0($t6)
        add $t7, $s0, $t7
        sw $t7 0($t6)



        addi $t5 $t5 1
        j forloopj
        endforloopj:

    addi $t4 $t4 1
    j forloopi
    endforloopi:


    return:
        jr $ra


main:
    la $a0 input
    la $a1 filter
    la $a2 output
    #Result length
    lw $a3 output_length
    jal conv

    #Loop for printing result
    la $t0 output
    lw $t3 output_length
    sll $t3 $t3 2
    li $t1 0
    print_loop:
        add $t2 $t0 $t1
        lw $a0 0($t2)
        li $v0 1
        syscall
        la $a0 space
        li $v0 4
        syscall
        add $t1 4
        bne $t1 $t3 print_loop
    j exit

exit:
    la $a0 ack
    li $v0 4
    syscall
	li $v0 10 
	syscall

