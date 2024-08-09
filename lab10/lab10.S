.section .note.GNU-stack,""

.global dot_double
.global map_poly_double
.global dot_single
.global map_poly_single
.global sin_x87

.text
    
dot_double:
	
    xorpd %xmm0,%xmm0 
	xor %rax, %rax 

dot_double_start:
	
    cmp %rdx, %rax
	jge dot_double_end
	
    movq (%rdi,%rax,8), %xmm1 
	movq (%rsi,%rax,8), %xmm2

    mulsd %xmm2, %xmm1
	addsd %xmm1, %xmm0
	
	inc %rax
	jmp dot_double_start

dot_double_end:
	ret
	
map_poly_double:
    
    xor %rax, %rax
               
map_poly_double_start:
    
    cmp %rdx, %rax
    jge map_poly_double_end

    movq (%rdi,%rax,8), %xmm4
    movq %xmm0, %xmm5

    mulsd %xmm4, %xmm5
    mulsd %xmm4, %xmm5 
    mulsd %xmm4, %xmm5
    mulsd %xmm4, %xmm1
    mulsd %xmm4, %xmm1
    addsd %xmm1, %xmm5
    mulsd %xmm4, %xmm2
    addsd %xmm2, %xmm5
    addsd %xmm3, %xmm5     
  
    movq %xmm5, (%rsi,%rax,8)

    inc %rax
    jmp map_poly_double_start

map_poly_double_end:
    ret

dot_single:

	pxor %xmm0,%xmm0
	xor %rax, %rax

dot_single_start:

	cmp %rdx, %rax
	jge dot_single_end

	movd (%rdi,%rax,4), %xmm1 
	movd (%rsi,%rax,4), %xmm2 
	
    mulss %xmm2, %xmm1
	addss %xmm1, %xmm0 
	
	inc %rax
	jmp dot_single_start

dot_single_end:
	ret
	
map_poly_single:
	
    xor %rax, %rax 

map_poly_single_start:
	
    cmp %rdx, %rax
	jge map_poly_single_end

	movd (%rdi,%rax,4), %xmm4 
	movq %xmm0, %xmm5

    mulss %xmm4, %xmm5
    mulss %xmm4, %xmm5 
    mulss %xmm4, %xmm5
    mulss %xmm4, %xmm1
    mulss %xmm4, %xmm1
    addss %xmm1, %xmm5
    mulss %xmm4, %xmm2
    addss %xmm2, %xmm5
    addss %xmm3, %xmm5
	
    movd  %xmm5, (%rsi,%rax,4)
	
    inc %rax
	jmp map_poly_single_start

map_poly_single_end:
	ret

sin_x87:
    mov $0, %rcx
s87_loop:
    cmp %rdx, %rcx
    jae s87_ret
    fldl (%rdi, %rcx, 8)
    fsin
    fstpl (%rsi, %rcx, 8)
    inc %rcx
    jmp s87_loop
s87_ret:
    ret

