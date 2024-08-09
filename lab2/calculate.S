.section .note.GNU-stack,""
.global calculate
.text

calculate:
    push %rbp           
    mov %rsp, %rbp      
    push %rbx            
    push %r12
    push %r13
    push %r14

    mov %rdi, %r12      

    lea 3(%r12), %r13    # a = x + 3, store in %r13

    mov %r12, %rdi      
    mov %r13, %rsi
    call f
    mov %rax, %r14       # b = f(x, a), store in %r14

    mov %r14, %rdi      
    mov %r12, %rsi
    call f
    mov %rax, %rbx       # c = f(b, x), store in %rbx

    mov %r12, %rdi     
    mov %rbx, %rsi
    call f
    mov %rax, %r10       # d = f(x, c), store in %r10

    # Calculate a + b + c + d
    add %r13, %r14      
    add %rbx, %r14      
    add %r10, %r14      
    mov %r14, %rax       # Moving result to %rax

    pop %r14             # Restore callee-saved registers
    pop %r13
    pop %r12
    pop %rbx
    mov %rbp, %rsp       # Restore base pointer
    pop %rbp
    ret                  # Return