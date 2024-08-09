.section .text
.global multiply_add

# %rdi = (a)
# %rsi = (b)
# %rdx = (c)
# Return value = %rax

multiply_add:
    imul %rsi, %rdx     # %rdx = %rsi * %rdx (b * c)
    add %rdi, %rdx      # %rdx = %rdi + %rdx (a + b * c)
    mov %rdx, %rax      # move the result to %rax
    ret                 # return