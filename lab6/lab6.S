.section .note.GNU-stack,""
.text

.global strlen_mine

strlen_mine:
    movq %rdi, %rax  # Setting RAX to the address of the string
    xorq %rcx, %rcx  # Clearing RCX to use as a counter

loop_start:  
    cmpb $0, (%rax)  # Comparing the current byte with 0
    je loop_end  # If zero, jump to the end of the loop
    incq %rax  # Move to the next byte
    incq %rcx  # Increment the counter
    jmp loop_start  # Repeat the loop

loop_end:  
    movq %rcx, %rax  # Moving the counter value to RAX
    ret

.global strlen_utf8

strlen_utf8:
    movq %rdi, %rax  # Setting RAX to the address of the string
    xorq %rcx, %rcx  # Clearing RCX to use as a character count

utf8_loop_start:  
    movzbl (%rax), %edx  # Load the current byte into EDX and zero extend
    testb $0x80, %dl  # Test the most significant bit
    jz utf8_inc_count  # If not set, it's a 1-byte character

    testb $0x40, %dl  # Test the second most significant bit
    jz utf8_next_byte  # If not set, it's a continuation byte

utf8_inc_count:  
    incq %rcx  # Increment the character count

utf8_next_byte:  
    incq %rax  # Move to the next byte
    cmpb $0, (%rax)  # Compare the next byte with 0
    jne utf8_loop_start  # If not zero, repeat the loop

    movq %rcx, %rax  # Move the character count to RAX
    ret
