.section .note.GNU-stack,""
.text

# Function to calculate absolute value
.global abs_value
abs_value:
    mov %rdi, %rax          
    sar $63, %rdi           
    xor %rdi, %rax          
    sub %rdi, %rax          

    ret

# Function to compute powers of 2 and print them
.global power2
power2:
    mov %rdi, %r8           
    inc %r8                 
    mov $1, %rax            

power2_start:
    cmp $0, %r8           
    jle power2_end          

    mov %rax, %rdi          
    push %rax               
    call print_uint64       
    pop %rax                

    sal $1, %rax            
    dec %r8                 

    jmp power2_start        

power2_end:
    ret                     

# Function to calculate the length of the hailstone sequence
.global hailstone_length
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