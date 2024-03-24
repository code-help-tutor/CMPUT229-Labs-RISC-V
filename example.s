WeChat: cstutorcs
QQ: 749389476
Email: tutorcs@163.com

# The following format is required for all submissions in CMPUT 229

        .data
# This is the buffer where the number will be stored.
buffer:
        .word   0, 0, 0         # 12 bytes of zeroes
str_newline:
        .asciz "\n"            # null-terminated ascii string for (CR+LF)

        .text

#-------------------------------------------------------------------------------
# main
# The main program loads a0 and a1 with the input parameters for
# hex2dec, calls the subroutine hex2dec to perform hexadecimal to
# ASCII-coded decimal conversion, and prints the result using the
# print_string system call.
#
# Register Usage:
#       a0: contains the number to be converted
#       a1: contains the address of the output buffer
#-------------------------------------------------------------------------------
main:
        li      a0, -0x1234     # a0 <- the number to be converted 
        la      a1, buffer      # a1 <- the address of buffer for
                                #   ASCII decimal 
        jal     ra, hex2dec     # call the subroutine and save
                                #   the return address to ra
        # a0 has the address to result buffer from hex2dec

        # print out the result of the conversion using the system call print_int
        li      a7, 4           # set system call no. 4 (PrintString)
        ecall                   # make the call

        # print a newline character
        la      a0, str_newline # a0 <- the address of the newline char
        li      a7, 4           # set system call no. 4 (PrintString)
        ecall                   # make the actual call

        # Return to OS
        li      a7, 10          # return to the OS by call sys call no. 10
        ecall                   # make the actual call


#-------------------------------------------------------------------------------
# hex2dec
# Takes as input a 32-bit number and converts it to ASCII decimal. 
#
# Inputs:
#       a0: number to be converted
#       a1: address of result buffer
#       ra: return address
#                 
# Register Usage
#       t0: 1 if a0 was negative, otherwise 0
#       t1: holds the number 10 for dividing by 10
#       t2: buffer pointer (starts at end of buffer and moves backwards)
#       t3: remainder of division, converted to ascii decimal
#
# Return Values
#       a0: address to result buffer
#-------------------------------------------------------------------------------
hex2dec:
        slt     t0, a0, zero    # determine the sign, setting t0
                                #   to 1 if a0 is negative
        beqz    t0, next        # skip the next instruction if >= 0
        neg     a0, a0          # negate the sign if negative

next:
        li      t1, 10          # for dividing by 10
        addi    t2, a1, 11      # t2 <- end of buffer

while_loop:
        beqz    a0, done_while

        rem     t3, a0, t1      # t3 <- put remainder of (a0 / 10) 
        div     a0, a0, t1      # a0 <- quotient of (a0 / 10)
        addi    t3, t3, 0x30    # convert to ascii decimal
        addi    t2, t2, -1      # decrement buffer pointer
        sb      t3, 0(t2)       # store it in the next available location

        b       while_loop      # continue loop
        done_while:

        # add the sign to the buffer if negative
        beqz    t0, quit        # branch to quit if t0 == 0
        li      t0, '-'         # reusing t0 to hold '-'
        addi    t2, t2, -1      # decrement buffer pointer
        sb      t0, 0(t2)       # add '-' to the front of string

quit:
        mv      a0, t2          # a0 <- last used buffer address
        jalr    zero, ra, 0     # return to calling program





