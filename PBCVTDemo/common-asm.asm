EXTERN	HvmSubvertCpu:PROC

.CODE

GetCpuIdInfo PROC
   push   rbp
   mov      rbp, rsp
   push   rbx
   push   rsi

   mov      [rbp+18h], rdx
   mov      eax, ecx
   cpuid
   mov      rsi, [rbp+18h]
   mov      [rsi], eax
   mov      [r8], ebx
   mov      [r9], ecx
   mov      rsi, [rbp+30h]
   mov      [rsi], edx

   pop      rsi
   pop      rbx
   mov      rsp, rbp
   pop      rbp
   ret
GetCpuIdInfo ENDP

CmSubvert PROC
	;备份客户机寄存器
	push	rax
	push	rcx
	push	rdx
	push	rbx
	push	rbp
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12
	push	r13
	push	r14
	push	r15

	sub	rsp, 28h;fastcall 调用约定，rcx,rdx,r8,r9,rip共5个寄存器，5*8=40=28h

	mov	rcx, rsp           ; __fastcall用rcx传递第一个参数GuestRsp
	                       ; x64统一为__fastcall: 前四个参数由RCX,RDX,R8,R9依次传递
	call	HvmSubvertCpu  ; VmxSubvertCpu要求一个参数GuestRsp defined in hvm.c

CmSubvert ENDP

CmGuestEip PROC

	add	rsp, 28h
	;恢复客户机寄存器，在由host进入guest后执行,把进入VMM之前的register恢复到Guest里
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rdi
	pop	rsi
	pop	rbp
	pop	rbx
	pop	rdx
	pop	rcx
	pop	rax

	ret

CmGuestEip ENDP

END
