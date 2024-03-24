WeChat: cstutorcs
QQ: 749389476
Email: tutorcs@163.com
#
# CMPUT 229
#

        .data

inputStream:    # space for input sequence of tokens to be stored
        .space 2048
noFileStr:
        .asciz "Couldn't open specified file.\n"
        .align 2
stack:          # space for stack
        .space 2048
stackBeginning: # beginning of the stack
        .word 0


        .text
main:
        lw	 a0, 0(a1)	    # Put the filename pointer into a0
        li	 a1, 0		    # Flag: Read Only
        li	 a7, 1024	    # Service: Open File
        # File descriptor gets saved in a0 unless an error happens
        ecall
        bltz	a0, main_err        # Negative means open failed
    
        la	a1, inputStream	    # write into my binary space
        li	a2, 2048            # read a file of at max 2kb
        li      a7, 63              # Read File Syscall
        ecall
    
        la      a0, inputStream	    # supply pointers as arguments
        la      a1, stackBeginning
        jal     calculator          # call the student subroutine/jump to code under the label 'calculator'
    
        j	main_done
    
main_err:
        la	a0, noFileStr       # print error message in the event of an error when trying to read a file                       
        li	a7, 4               # the number of a system call is specified in a7
        ecall                       # Print string whose address is in a0
    
main_done:
   
        li      a7, 10              # ecall 10 exits the program with code 0
        ecall

#-------------------end of common file-------------------------------------------------

