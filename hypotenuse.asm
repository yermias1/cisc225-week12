; Given two sides of a right triangle, calculate hypotenuse
; Northampton Community College
; CISC 225, Computer Organization

global main		; exposes program entry point to the linker
extern printf	; declare external function
extern scanf

section .text	; start of code segment

main:
	push rbp				; preserve base pointer
	mov rbp,rsp				; copy stack pointer to base pointer

  ; Prompt for input of two sides
	mov rdi, fmt_prompt
	mov rax, 0
	call printf

  ; Input side a and side b
	mov rdi, fmt_input
	lea rsi, [side_a]
	lea rdx, [side_b]
	mov rax, 0
	call scanf

  ; Square side a, leaving result in XMM0
	fld qword [side_a]		; ST0 = a
	fmul st0, st0			; a^2

  ; Square side b, leaving result in XMM1
	fld qword [side_b]		; ST0 = b, ST1 = a^2
	fmul st0, st0			; b^2

  ; Add squares of sides a and b, result in XMM0
	faddp st1, st0			; ST0 = a^2 + b^2

  ; Square root of sum, result in XMM0
	fsqrt					; sqrt(a^2 + b^2)

  ; Output result
	sub rsp, 8				; align stack
	fstp qword [rsp]		; move result to stack for printf
	mov rdi, fmt_output
	mov rax, 1				; 1 floating point argument
	call printf
	add rsp, 8

	pop		rbp				; restore base pointer
	mov		rax, 0			; exit status (0 = success)
	ret

section .data	; start of initialized data segment

  fmt_prompt db "Enter length of two sides: ",0
  fmt_input db "%lf %lf",0
  fmt_output db "The hypotenuse is %0.2lf.",0xa,0

section .bss	; start of uninitialized data segment

  side_a resq 1
  side_b resq 1
