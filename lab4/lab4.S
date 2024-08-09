.section .note.GNU-stack,""
.text

.global is_prime

is_prime:
    cmpq $2, %rdi       # Compare n with 2
    je handle_special   # Jump if n is 2

    movl $2, %ecx       # Initialize ECX to 2

prime_loop:
    movq %rdi, %rax     # Move n to RAX for division
    xorq %rdx, %rdx     # Clear RDX
    divq %rcx           # Divide n by i
    test %rdx, %rdx     # Check if remainder is zero
    je not_prime        # Jump if n is divisible by i
    addl $1, %ecx       # Increment i
    cmpq %rdi, %rcx     # Compare i with n
    jb prime_loop       # Loop if i < n

    movl $1, %eax       # n is prime, return 1
    ret

handle_special:
    movl $1, %eax       # n is 2, return 1
    ret

not_prime:
    movl $0, %eax       # n is not prime, return 0
    ret

.global largest_power_unsigned

largest_power_unsigned:
    mov $1, %rax        # Initialize RAX to 1
    mov %rdi, %rbx      # Store n in RBX

power_loop:
    mov %rax, %r8       # Save current power in R8
    mul %rbx            # Multiply RAX by RBX
    jc power_done       # Jump if carry flag is set
    jmp power_loop      # Repeat the loop

power_done:
    mov %r8, %rax       # Move the highest power to RAX
    ret

.global overflowing_subtract

overflowing_subtract:
    mov %rdi, %rax      # Move a to RAX
    sub %rsi, %rax      # Subtract b from a
    jo overflow_case    # Jump if overflow occurred
    ret                 # Return result

overflow_case:
    mov $0, %rax        # Return 0 on overflow
    ret

.global dumb

dumb:
    cmp $0, %rdi        # Compare a with 0
    je return_second    # Return b if a is 0

    cmp $0, %rsi        # Compare b with 0
    je return_first     # Return a if b is 0

    sub $32, %rsp       # Allocate stack space

    mov %rdi, (%rsp)    # Save a
    mov %rsi, 8(%rsp)   # Save b

    dec %rdi            # Decrement a
    dec %rsi            # Decrement b
    mov %rdi, 16(%rsp)  # Save decremented a
    mov %rsi, 24(%rsp)  # Save decremented b

    call dumb

    mov (%rsp), %rdi    # Restore a
    mov 8(%rsp), %rsi   # Restore b

    add $32, %rsp       # Clean up stack

    add %rdi, %rax      # Add a to result
    add %rsi, %rax      # Add b to result
    add %rsi, %rax      # Add b again to result
    ret

return_second:
    mov %rsi, %rax      # Return b
    ret

return_first:
    mov %rdi, %rax      # Return a
    ret
