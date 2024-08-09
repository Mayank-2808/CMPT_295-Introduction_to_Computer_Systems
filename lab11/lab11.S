.section .note.GNU-stack,""

.global dot_double
.global map_poly_double
.global dot_single
.global map_poly_single
.global dot_double_vec
.global dot_single_vec
.global map_poly_double_vec
.global map_poly_single_vec

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

dot_double_vec:
    
    vxorpd %ymm0, %ymm0, %ymm0
    xor %rax, %rax

dot_double_vec_start:
    
    cmp %rdx, %rax
    jge dot_double_vec_end

    vmovupd (%rdi, %rax, 8), %ymm1
    vmovupd (%rsi, %rax, 8), %ymm2
    vmulpd %ymm2, %ymm1, %ymm1
    vaddpd %ymm1, %ymm0, %ymm0

    add $4, %rax
    jmp dot_double_vec_start

dot_double_vec_end:
    
    vextractf128 $0x1, %ymm0, %xmm1
    vaddpd %xmm1, %xmm0, %xmm0
    vshufpd $0b01, %xmm0, %xmm0, %xmm1
    vaddsd %xmm1, %xmm0, %xmm0
    ret

dot_single_vec:
    
    vpxor %ymm0, %ymm0, %ymm0
    xor %rax, %rax

dot_single_vec_start:
    
    cmp %rdx, %rax
    jge dot_single_vec_end

    vmovups (%rdi, %rax, 4), %ymm1
    vmovups (%rsi, %rax, 4), %ymm2
    vmulps %ymm2, %ymm1, %ymm1
    vaddps %ymm1, %ymm0, %ymm0

    add $8, %rax
    jmp dot_single_vec_start

dot_single_vec_end:
    
    vextractf128 $0x1, %ymm0, %xmm1
    vaddps %xmm1, %xmm0, %xmm0
    vshufps $0b00001110, %xmm0, %xmm0, %xmm1
    vaddps %xmm1, %xmm0, %xmm0
    vshufps $0b00000001, %xmm0, %xmm0, %xmm1
    vaddss %xmm1, %xmm0, %xmm0
    ret

map_poly_double_vec:
    
    vbroadcastsd %xmm4, %ymm4
    vbroadcastsd %xmm5, %ymm5
    vbroadcastsd %xmm6, %ymm6
    vbroadcastsd %xmm7, %ymm7

    xor %rax, %rax

map_poly_double_vec_start:
    
    cmp %rdx, %rax
    jge map_poly_double_vec_end

    vmovupd (%rdi, %rax, 8), %ymm0
    vmovupd %ymm0, %ymm1
    vmulpd %ymm0, %ymm1, %ymm1
    vmulpd %ymm0, %ymm1, %ymm1
    vfmadd213pd %ymm6, %ymm5, %ymm1
    vfmadd213pd %ymm7, %ymm6, %ymm1

    vmovupd %ymm1, (%rsi, %rax, 8)

    add $4, %rax
    jmp map_poly_double_vec_start

map_poly_double_vec_end:
    ret

map_poly_single_vec:
    
    vbroadcastss %xmm4, %ymm4
    vbroadcastss %xmm5, %ymm5
    vbroadcastss %xmm6, %ymm6
    vbroadcastss %xmm7, %ymm7

    xor %rax, %rax

map_poly_single_vec_start:
    
    cmp %rdx, %rax
    jge map_poly_single_vec_end

    vmovups (%rdi, %rax, 4), %ymm0
    vmovups %ymm0, %ymm1
    vmulps %ymm0, %ymm1, %ymm1
    vmulps %ymm0, %ymm1, %ymm1
    vfmadd213ps %ymm6, %ymm5, %ymm1
    vfmadd213ps %ymm7, %ymm6, %ymm1

    vmovups %ymm1, (%rsi, %rax, 4)

    add $8, %rax
    jmp map_poly_single_vec_start

map_poly_single_vec_end:
    ret