.section .note.GNU-stack,""
.text

.global fibonacci

fibonacci:
    cmp $1, %rdi
    jle base_case       # jump to base_case if %rdi <= 1

    push %rbp           # save the base pointer
    push %rbx           # save the rbx register

    dec %rdi
    mov %rdi, %rbx 
    call fibonacci
    mov %rax, %rbp      # store F(n-1) in %rbp
    
    dec %rbx  
    mov %rbx, %rdi
    call fibonacci
    add %rbp, %rax      # F(n-1) + F(n-2) stored in %rax
   
    pop %rbx            # restore rbx
    pop %rbp            # restore rbp

    ret

base_case:
    mov %rdi, %rax      # set %rax to %rdi
    ret

.global polynomial1

polynomial1: 
    mov %rdi, %rax       
    imul %rdi, %rax     
    imul %rdi, %rax     # %rax = x*x*x

    imul %rsi, %rax     # %rax = a*x*x*x
    mov %rax, %r9       # store a*x*x*x in %r9

    mov %rdi, %rax      
    imul %rdi, %rax     # %rax = x*x
    imul %rdx, %rax     # %rax = b*x*x

    add %rax, %r9       # %r9 = a*x*x*x + b*x*x
    imul %rcx, %rdi     # %rdi = c*x
    add %rdi, %r9       # %r9 += c*x
    add %r8, %r9        # %r9 += d

    mov %r9, %rax       
    ret

.global polynomial2

polynomial2:
    mov %rdi, %rax      
    imul %rsi, %rax     
    add %rdx, %rax      
    imul %rdi, %rax     # %rax = x*(a*x + b)
    add %rcx, %rax      # %rax += c
    imul %rdi, %rax     # %rax = x*(x*(a*x + b) + c)
    add %r8, %rax       # %rax += d

    ret

.global is_odd1

is_odd1:
    mov %rdi, %rax       # copy %rdi to %rax
    xor %rdx, %rdx       # clear %rdx
    mov $2, %rcx         # load 2 into %rcx
    idiv %rcx            # divide %rax by 2, remainder in %rdx
    mov %rdx, %rax       # move remainder to %rax
    ret

.global is_odd2

is_odd2:
    mov %rdi, %rax       
    and $1, %rax         # mask all but the least significant bit
    ret

.global mul1

mul1:
    mov %rdi, %rax      
    mov $65537, %rcx   
    mul %rcx            # multiply %rdi by 65537
    ret

.global mul2

mul2:
    mov %rdi, %rax      
    shl $16, %rax       # shift %rdi left by 16 bits
    add %rdi, %rax      # add original %rdi
    ret 