.model small
.data
	string1 db 'Hello World!', '$'
	elsemessage1 db 'This is', '$'
	elsemessage2 db 'Else', '$'
	loopmessage1 db 'Loop1', '$'
	loopmessage2 db 'Loop2', '$'
	done db 'Done!$'
	char1 db 'a'
	integer1 db 5
	integer2 db 10
	integer3 db 1
	string2 db 'Harold$' 
.stack 100h
.code
	main proc
	
	mov ax, @data
	mov ds, ax

	lea dx, string1
	mov ah, 09h
	int 21h
	
	add integer3, 2
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	
	mov dl, char1
	mov ah, 02h
	int 21h
	
	mov dl, 'a'
	mov ah, 02h
	int 21h
	
	mov al, integer1
	cmp al, integer2
	je if_block
	jmp elselabel
	if_block:
		mov dx, offset string2
		mov ah, 09h
		int 21h
		mov dx, offset string1
		mov ah, 09h
		int 21h
	jmp endiflabe
	elselabel:
		lea dx, elsemessage1
		mov ah, 09h
		int 21h
		lea dx, elsemessage2
		mov ah, 09h
		int 21h
	jmp endelselabe
	endiflabe:
	endelselabe:
	
	looplabel:
		lea dx, loopmessage1
		mov ah, 09h
		int 21h
		lea dx, loopmessage2
		mov ah, 09h
		int 21h
		mov bl, integer1
		add integer1, 1
		cmp bl, integer2
		jl looplabel
		jmp endlooplabe
	endlooplabe:
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	
	mov al, integer1
	cmp al, integer2
	je if_block2
	jmp elselabel2
	if_block2:
		mov dx, offset elsemessage1
		mov ah, 09h
		int 21h
		mov dx, offset elsemessage2
		mov ah, 09h
		int 21h
	jmp endiflabe2
	elselabel2:
		lea dx, string1
		mov ah, 09h
		int 21h
		lea dx, string2
		mov ah, 09h
		int 21h
	jmp endelselabe2
	endiflabe2:
	endelselabe2:
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	sub integer3, 2
	looplabel2:
		lea dx, loopmessage2
		mov ah, 09h
		int 21h
		lea dx, loopmessage1
		mov ah, 09h
		int 21h
		mov bl, integer3
		add integer3, 1
		cmp bl, 4
		jl looplabel2
		jmp endlooplabe2
	endlooplabe2:
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	mov dx, offset done
	mov ah, 09h
	int 21h
	exit:
	mov ax, 4c00h
	int 21h
	
	main endp
	
	end main