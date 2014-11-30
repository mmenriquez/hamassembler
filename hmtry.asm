.model small
.data

	PROMPT1 DB 0DH,0AH,'Are you ready to play? (y for YES, n for NO):', '$'
	PROMPT2 DB 0DH,0AH,'Please try again ', '$'
	PROMPT3 DB 0DH,0AH,'What letter do you guess?  ', '$'
	PROMPT4 DB 0DH,0AH,'The word is:',0DH,0AH, '$'
	PROMPT5 DB 0DH,0AH,'Congratulations! You won the game',0DH,0AH, '$'
	PROMPT6 DB 0DH,0AH,'Sorry you missed.',0DH,0AH, '$'
	PROMPT7 DB 0DH,0AH,'Sorry, duplicate entry.  Please try again.',0DH,0AH, '$'
	PROMPT8 DB 0DH,0AH,'List of chosen letter(s): ', '$'
	CRLF   DB  0DH, 0AH, '$'

	FIG0    DB 0DH,0AH,' +=======+',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG1    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG2    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/        |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG3    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/ \      |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG4    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG5    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,' |       |',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG6    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,' |       |',0DH,0AH,'/        |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG7    DB 0DH,0AH,' +=======+',0DH,0AH,' |       |',0DH,0AH,' O       |',0DH,0AH,'/|\      |',0DH,0AH,' |       |',0DH,0AH,'/ \      |',0DH,0AH,'         |',0DH,0AH,' ========+',0DH,0AH,'$'
	FIG8    DB 0DH,0AH,' +=======+',0DH,0AH,'         |',0DH,0AH,'         |',0DH,0AH,'   \O/   |',0DH,0AH,'    |    |',0DH,0AH,'    |    |',0DH,0AH,'   / \   |',0DH,0AH,' ========+',0DH,0AH,'$'

	STACK_INPUT DB ?,'$'
	TEMP DB ?,'$'
	MSG  DB ?,'$'

	LINE1 DB 'H A M A S S E M B L E R  |  H A N G M A N','$'
	LINE2 DB 'GET STARTED','$'
	PROMPT DB 'Please Enter The Message Number (0-9)','$'
	ERRORMSG DB 'DIGIT nga eh, enter ka ulit!','$' 
	MSG0 DB  'temperature$'
	MSG1 DB  'akyladisla','$'
	MSG2 DB  'paradise$'
	MSG3 DB  'memorial$'
	MSG4 DB  'wonderful$'
	MSG5 DB  'substance$'
	MSG6 DB  'animation$'
	MSG7 DB  'boutique$'
	MSG8 DB  'dangerous$'
	MSG9 DB  'element$'

	CREDIT    DB ?
	correct   DB ?
	incorrect DB ?
	STR_L	  DB ?
	
	rowBorderCorner db 4	
	colBorderCorner db 7
	rowBorder db 4
	colBorder db 8
	xCoor db 20 
	yCoor db 12
	
	delayTime db 10
	number db '3'
	
	yinput db 12
	xinput db 33
	msgcontainer db ?,'$'
	
.stack 100h
.code
	clrscrn proc
    mov cx, 3200h
    mov ah, 01h
    int 10h
	
	mov ax, 0600h
	mov bh, 07h
	xor cx, cx
	mov dx, 184fh
	int 10h
	
	ret
	
	clrscrn endp
	
	delay proc
		mov ah, 00
		int 1Ah
		mov bx, dx

	jmp_delay:
		int 1Ah
		sub dx, bx
		cmp dl, delaytime
		jl jmp_delay
		ret
		
	delay endp
	
	countdown proc
	
	mov yCoor, 12
	mov xCoor, 40
	
	loop_countdown:
	call clrscrn
	call print_border
	call delay
	
	mov dh, yCoor
	mov dl, xCoor
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, number
	xor bh, bh
	mov bh, 0
	mov bl, 0Eh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	dec number
	call delay
	cmp number, 48
	jge countdown
	
	ret
	
	countdown endp
	
	print_border2 proc
	
	mov rowBorder, 4
	mov colBorder, 30
	
	mov dh, rowBorder
	mov dl, colBorder
	xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 203
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	loop_printborder2:
	inc rowBorder
	mov dh, rowBorder
	mov dl, colBorder
	xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 186
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h

	cmp rowBorder, 19
	jle loop_printborder2
	
	inc rowBorder
	
	mov dh, rowBorder
	mov dl, colBorder
	xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 202
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	print_border2 endp
	
	print_border proc
	
	mov rowBorderCorner, 4
	mov colBorderCorner, 7
	mov rowBorder, 4
	mov colBorder, 8
	
	mov dh, rowBorderCorner 
	mov dl, colBorderCorner
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 201 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	top:
	mov dh, rowBorder 
	mov dl, colBorder
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 205 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	inc colBorder
	cmp colBorder, 71
	jle top
	
	mov colBorderCorner, 72
	
	mov dh, rowBorderCorner 
	mov dl, colBorderCorner
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 187 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	inc rowBorder
	
	right:
	mov dh, rowBorder 
	mov dl, colBorder
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 186 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	inc rowBorder
	cmp rowBorder, 20
	jle right
	
	mov rowBorderCorner, 21
	
	mov dh, rowBorderCorner 
	mov dl, colBorderCorner
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 188 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	dec colBorder
	
	bottom:
	mov dh, rowBorder 
	mov dl, colBorder
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 205 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	dec colBorder
	cmp colBorder, 8
	jge bottom
	
	mov colBorderCorner, 7
	
	mov dh, rowBorderCorner 
	mov dl, colBorderCorner
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 200 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	dec rowBorder
	
	left:
	mov dh, rowBorder
	mov dl, colBorder
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, 186 
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	dec rowBorder
	cmp rowBorder, 4
	jg left
	
	ret
	
	print_border endp
	
	print_openingmsg proc
	
	xor si, si
	mov yCoor, 12
	mov xCoor, 20
	
	loop_line1:
	mov dh, yCoor
	mov dl, xCoor
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	cmp line1[si], '$'
	je next_openingmsg
	mov al, line1[si] 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	inc xCoor
	inc si
	jmp loop_line1
	
	next_openingmsg:
	mov dl, 0ah
	mov ah, 02h
	int 21h
	
	xor si, si
	mov yCoor, 13
	mov xCoor, 35
	
	loop_line2:
	mov dh, yCoor
	mov dl, xCoor
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	cmp line2[si], '$'
	je return_openingmsg
	mov al, line2[si] 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	inc xCoor
	inc si
	jmp loop_line2
	
	return_openingmsg:
	ret
	
	print_openingmsg endp
	
	message0 proc
	
	xor si, si
	
	copy0:
	cmp msg0[si],'$'
	je end0
	mov al, msg0[si]
	mov msg[si], al
	inc si
	loop copy0
	
	end0:
	mov msg[si],'$'
	call display_empty
	
	ret
	
	message0 endp
	
	message1 proc
	
	xor si, si
	xor ax, ax
	
	REC1:
	CMP MSG1[si],'$'
	JE END1
	MOV DL,MSG1[si]
	MOV MSG[si],DL
	INC si
	JMP REC1
	END1:
	MOV MSG[si],'$'
	
	call clrscrn
	call print_border
	call print_border2
	
	call display_empty
	
	ret
	
	message1 endp
	
	word_table proc
    
	cmp al, 30h
	jne next_msg1
	call message0
	jmp end_wtable
	
	next_msg1: 
	cmp al, '1'
	jne next_msg2
	call message1
	jmp end_wtable
	
	next_msg2:
	cmp al, '2'
	jne next_msg3
	;call message2
	jmp end_wtable
	
	next_msg3:
	cmp al, '3'
	;call message3
	jmp end_wtable
	
	cmp al, '4'
	;call message4
	jmp end_wtable
	
	cmp al, '5'
	;call message5
	jmp end_wtable
	
	cmp al, '6'
	;call message6
	jmp end_wtable
	
	cmp al, '7'
	;call message7
	jmp end_wtable
	
	cmp al, '8'
	;call message8
	jmp end_wtable
	
	cmp al, '9'
	;call message9
	
	end_wtable:
	ret
	
	word_table endp
	
	display_empty proc
	call clrscrn
	call print_border
	call print_border2
	
	mov str_l, 0
	mov bl, '-'
	mov ah, 09h
	xor si, si
	
	begin:
	cmp msg[si], '$'
	je end_
	mov temp[si],bl
	inc str_l
	inc si
	jmp begin
	
	end_:
	mov temp[si], '$'
	
	xor si, si
	mov yinput, 12
	mov xinput, 33
	
	loop_displayempty:
	cmp temp[si],'$'
	je end_displayempty
	mov dh, yinput
	mov dl, xinput
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov dl, ' '
	mov ah, 02h
	int 21h
	
	inc xinput
	
	mov dh, yinput
	mov dl, xinput
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, temp[si]
	xor bh, bh
	mov bh, 0
	mov bl, 0Bh
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	inc si
	inc xinput
	jmp loop_displayempty
	
	end_displayempty:
	ret
	
	display_empty endp

	main proc
	
	mov ax, @data
	mov ds, ax
	
	call clrscrn
	call print_border
	call print_openingmsg
	call delay
	call countdown
	
	start_of_game:
	
	call clrscrn
	call print_border
	call print_border2
	
	mov dh, yinput
    mov dl, xinput
    xor bh, bh 
    mov ah, 02h
    int 10h

    mov dx, offset prompt
    mov ah, 09h
    int 21h
	
	loop1:
	mov ah, 01h
	int 21h
	
	cmp al, 30h
	jb re_enter
	cmp al, 39h
	ja re_enter
	
	call word_table
	call match_word
	
	;play again?
	;mov ah, 09h
	;lea dx, prompt12
	;int 21h
	jmp endwhile
	
	re_enter:
	call clrscrn
	call print_border
	call print_border2
	
	mov dh, yinput
    mov dl, xinput
    xor bh, bh 
    mov ah, 02h
    int 10h

    mov dx, offset errormsg
    mov ah, 09h
    int 21h
	jmp loop1
	
	endwhile:
	mov ax, 4c00h
	int 21h
	
	main endp
	end main
