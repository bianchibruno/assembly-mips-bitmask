.data
dat: .word 0x48656c6c, 0x6f303030, 0x38212121 # Hello0008!!!
len: .word 3
.text
la $s0, dat		#s0 holds address of dat
la $s1, len		
lw $s1, 0($s1)		#s1 holds value of len
li $s2, 0		#will hold the value of the parities 
#XOR will only output 1 if either one of its inputs is 1. That is, (a XOR b) = parity of a and b. For individual bits
#For an input of 32 bits = 2^5 bits, will obtain the parity after 5 iterations or ' folds'. a0 contains the current word we are iterating
singleparity:
beqz $s1, terminate
lw $t0, 0($s0)		#loads the current word
srl $t1, $t0, 16	#t1 is the original input shifted to the right 16 bits
xor $t7, $t0, $t1	
srl $t1, $t7, 8
xor $t7, $t7, $t1
srl $t1, $t7, 4
xor $t7, $t7, $t1
srl $t1, $t7, 2
xor $t7, $t7, $t1
srl $t1, $t7, 1
xor $t7, $t7, $t1	#at this point the final bit contains the value of the parity of the original input
and $t7, $t7, 1		#checking the value of the final bit. if $t7 = 1 then the parity is 1, 0 otherwise
xor $s2, $s2, $t7	#xor with the current result to see the overall result of parity
addi $s0, $s0, 4	#0(s0) is now the next word in the dat array
addi $s1, $s1, -1	#using len as a counter
j singleparity
terminate:
add $a0, $0, $s2
li $v0, 1
syscall
li $v0, 10
syscall
