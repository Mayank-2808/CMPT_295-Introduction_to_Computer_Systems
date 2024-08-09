.section .note.GNU-stack,""
.text

.global hailstone_length_cmov
.global hailstone_length

hailstone_length_cmov:
    
    mov $0, %rax          

hailstone_cmov_start:
    
    cmp $1, %rdi
    je hailstone_cmov_end

    inc %rax

    test $1, %rdi
    cmovz %rdi, %rax             # Move rdi to rax if if rdi is even

    imul $3, %rdx                
    add $1, %rdx                 

    shr $1, %rdi                 

    cmovnz %rdx, %rdi            # Move rdx to rdi if rdi is odd

    jmp hailstone_cmov_start

hailstone_cmov_end:
    ret


# Copied from assignment 3
hailstone_length:
    
    xor %rax, %rax          

hailstone_start:
    
    cmp $1, %rdi            
    je hailstone_end        

    inc %rax                

    test $1, %rdi           
    jz is_even              

    imul $3, %rdi           
    add $1, %rdi            
    jmp hailstone_start      

is_even:
    
    shr $1, %rdi            
    jmp hailstone_start      

hailstone_end:
    ret                             
