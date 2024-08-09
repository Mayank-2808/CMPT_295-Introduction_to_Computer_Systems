.section .note.GNU-stack,""

.section .data
.align 8
seed:
    .quad 0  # 64-bit integer initialized to 0

.section .text
.global randint
.global fill_array
.global dot
.global dot_struct

randint:
   
    movabs $6364136223846793005, %r8
    movabs $1442695040888963407, %r9

    mov seed(%rip), %rax
    imul %r8, %rax
    add %r9, %rax

    mov %rax, seed(%rip)

    ret

fill_array:
   
    mov %rdi, %r10  # get the array pointer
    mov %rsi, %r11  # get the number of elements

fill_array_start:
   
    test %r11, %r11
    jz fill_array_end

    call randint
    and $0xff, %rax
    sub $128, %rax

    mov %rax, (%r10)
    add $8, %r10

    dec %r11

    jmp fill_array_start

fill_array_end:
   
    ret

dot:
  
    mov %rdi, %r8  # get pointer to array 1
    mov %rsi, %r9  # get pointer to array 2
    mov %rdx, %rcx # get the length of the arrays
    mov $0, %rax

dot_start:
   
    test %rcx, %rcx
    jz dot_end

    mov (%r8), %r10
    mov (%r9), %r11

    imul %r10, %r11
    add %r11, %rax

    add $8, %r8
    add $8, %r9

    dec %rcx

    jmp dot_start

dot_end:
    ret

dot_struct:
   
    mov %rdi, %r8
    mov %rsi, %rcx
    mov $0, %rax

dot_struct_start:
   
    test %rcx, %rcx
    jz dot_struct_end

    mov (%r8), %r10
    mov 8(%r8), %r11

    imul %r10, %r11

    add %r11, %rax

    add $16, %r8

    dec %rcx

    jmp dot_struct_start

dot_struct_end:
    ret
