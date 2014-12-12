.model small
.data
	TEMP DB ?,'$'

	PROMPT1 DB 0DH,0AH,'Are you ready to play? (y for YES, n for NO):', '$'
	PROMPT2 DB 0DH,0AH,'Please try again ', '$'
	PROMPT3 DB 0DH,0AH,'What letter do you guess?  ', '$'
	PROMPT4 DB 0DH,0AH,'The word is:',0DH,0AH, '$'
	PROMPT5 DB 0DH,0AH,'Congratulations! You won the game',0DH,0AH, '$'
	PROMPT6 DB 0DH,0AH,'Sorry you missed.',0DH,0AH, '$'
	PROMPT7 DB 0DH,0AH,'Sorry, duplicate entry.  Please try again.',0DH,0AH, '$'
	PROMPT8 DB 0DH,0AH,'List of chosen letter(s): ', '$'
	CRLF   DB  0DH, 0AH, '$'
	
	STACK_INPUT DB ?,'$'

	LINE0 DB 'Enter your name:', '$'
	LINE1 DB 'H A M A S S E M B L E R  |  H A N G M A N','$'
	LINE2 DB 'GET STARTED','$'
	LINE3 DB '[1] PLAY', '$'
	LINE4 DB '[2] VIEW HIGH SCORES', '$'
	LINE5 DB '[3] EXIT', '$'
	LINE6 DB 'Your choice:', '$'
	LINE7 DB 'HIGH SCORES', '$' 
	LINE8 DB 'NAME', '$' 
	LINE9 DB 'SCORE', '$' 
	LINE10 DB 'CATEGORY', '$' 
	LINE11 DB 'LEVEL', '$' 
	PROMPT DB 'Please Enter The Message Number (0-9)','$'
	ERRORMSG DB 'DIGIT nga eh, enter ka ulit!','$' 
	INPUT_MSG DB ' Enter your input :	$'
	DUP_MSG DB ' You already entered$'
	MSG0 DB  'temperature','$'
	MSG1 DB  'akyladisla','$'
	MSG2 DB  'paradise','$'
	MSG3 DB  'memorial','$'
	MSG4 DB  'wonderful','$'
	MSG5 DB  'substance','$'
	MSG6 DB  'animation','$'
	MSG7 DB  'boutique','$'
	MSG8 DB  'dangerous','$'
	MSG9 DB  'element','$'

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
	number db '2'
	
	yinput db 12
	xinput db 33
	msgcontainer db ?,'$'
	
	win_msg db 'Congratulations! ','$'
	lose_msg db 'You lose. Try Again!','$'
	level1_msg db 'Level One Cleared!','$'
	level2_msg db 'Level Two Cleared!','$'
	level3_msg db 'Level Three Cleared!','$'
	play_again db '[1] Stay On Game  [0] End Game','$'	
	stat1 db ' Category: ','$'
	stat2 db ' Score: ','$'
	stat3 db ' Level: ','$'
	draw0 DB '+=======+', '$'
	level db 1
	score db 0
	winner db 0
	loser db 0
	lives db 7
	play db ?
	dashcount db 0
	
	
	MSG  DB ?,'$'
	ones db 0
	inputChoice db ?
	playerName db ?
	inputTemp db ?
	filename db "scores.txt", 0
	buffer db 256 DUP(?)
	errormess db "Error in opening file!$"
	handle dw ?
	
.stack 100h
.code
	DISP0 PROC
		xor si, si
		mov yCoor, 10
		mov xCoor, 16
		
		loop_hm1:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp draw0[si], '$'
			je next_disp0_2
			mov dl, draw0[si]
			mov ah, 02h
			int 21h
			inc xCoor
			inc si
		jmp loop_hm1
		
		next_disp0_2:
			xor si, si
			mov yCoor, 17
			mov xCoor, 16
			
			loop_hm1_2:
				mov dh, yCoor
				mov dl, xCoor
				xor bh, bh 
				mov ah, 02h 
				int 10h
				
				cmp draw0[si], '$'
				je next_disp0_3
				mov dl, draw0[si]
				mov ah, 02h
				int 21h
				inc xCoor
				inc si
			jmp loop_hm1_2

		next_disp0_3:
			xor si, si
			mov yCoor, 11
			mov xCoor, 24
			
			loop_hm1_3:
				mov dh, yCoor
				mov dl, xCoor
				xor bh, bh 
				mov ah, 02h 
				int 10h
				
				cmp si, 6
				je ret_disp0
				mov dl, '|'
				mov ah, 02h
				int 21h
				inc yCoor
				inc si
			jmp loop_hm1_3
		ret_disp0:
			RET
	DISP0 ENDP
	DISP1 PROC
	;display message1
		call disp0
		mov dh, 11
		mov dl, 16
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '|'
		mov ah, 02h
		int 21h
		
		mov dh, 12
		mov dl, 16
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, 'O'
		mov ah, 02h
		int 21h
			RET
	DISP1 ENDP
	DISP2 PROC
	;display message2
		call disp1
		mov dh, 13
		mov dl, 15
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '/'
		mov ah, 02h
		int 21h
		RET
	DISP2 ENDP
	DISP3 PROC
	;display message3
		call disp2
		mov dh, 13
		mov dl, 17
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '\'
		mov ah, 02h
		int 21h
		RET
	DISP3 ENDP
	DISP4 PROC
	;display message4
		call disp3
		mov dh, 13
		mov dl, 16
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '|'
		mov ah, 02h
		int 21h
		RET
	DISP4 ENDP
	DISP5 PROC
	;display message5
		call disp4
		mov dh, 14
		mov dl, 16
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '|'
		mov ah, 02h
		int 21h
		RET
	DISP5 ENDP
	DISP6 PROC
	;display message6
		call disp5
		mov dh, 15
		mov dl, 15
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '/'
		mov ah, 02h
		int 21h
			RET
	DISP6 ENDP
	DISP7 PROC
	;display message7
		call disp6
		mov dh, 15
		mov dl, 17
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '\'
		mov ah, 02h
		int 21h
		RET
	DISP7 ENDP
	DISP8 PROC
	;display message8
		call disp0
		mov dh, 13
		mov dl, 20
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, 'O'
		mov ah, 02h
		int 21h
		
		mov dh, 13
		mov dl, 19
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '\'
		mov ah, 02h
		int 21h
		
		mov dh, 13
		mov dl, 21
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '/'
		mov ah, 02h
		int 21h
		
		mov dh, 14
		mov dl, 20
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '|'
		mov ah, 02h
		int 21h
		
		mov dh, 15
		mov dl, 20
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '|'
		mov ah, 02h
		int 21h
		
		mov dh, 16
		mov dl, 19
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '/'
		mov ah, 02h
		int 21h
		
		mov dh, 16
		mov dl, 21
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, '\'
		mov ah, 02h
		int 21h

			RET
	DISP8 ENDP
	;*************************************************************************
	;	Display (bitmap) procedure
	;*************************************************************************
	DISPLAY PROC
	;checking score value and display
		CMP incorrect,0
		JE call_DISP0

		CMP incorrect,1
		JE call_DISP1

		CMP incorrect,2
		JE call_DISP2

		CMP incorrect,3
		JE call_DISP3
			
		CMP incorrect,4
		JE call_DISP4

		CMP incorrect,5
		JE call_DISP5

		CMP incorrect,6
		JE call_DISP6

		CMP incorrect,7
		JE call_DISP7

		CMP incorrect,8
		JE call_DISP8

		call_disp0:
			call disp0
			jmp ret_display
		call_disp1:
			call disp1
			jmp ret_display
		call_disp2:
			call disp2
			jmp ret_display
		call_disp3:
			call disp3
			jmp ret_display
		call_disp4:
			call disp4
			jmp ret_display
		call_disp5:
			call disp5
			jmp ret_display
		call_disp6:
			call disp6
			jmp ret_display
		call_disp7:
			call disp7
			jmp ret_display
		call_disp8:
			call disp8
			jmp ret_display
		
		ret_display:
		ret
	DISPLAY ENDP
	
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
	
	print_openingmsg proc
	
	xor si, si
	mov yCoor, 9
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
	mov yCoor, 10
	mov xCoor, 35
	
	loop_line2:
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		cmp line2[si], '$'
		je next_openingmsg2
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
	
	next_openingmsg2:
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	
	xor si, si
	mov yCoor, 12
	mov xCoor, 36
	
	loop_line3:
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		cmp line3[si], '$'
		je next_openingmsg3
		mov al, line3[si] 
		xor bh, bh
		mov bh, 0
		mov bl, 0Ah
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		inc xCoor
		inc si
	jmp loop_line3
	
	next_openingmsg3:
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	
	xor si, si
	mov yCoor, 13
	mov xCoor, 36
	
	loop_line4:
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		cmp line4[si], '$'
		je next_openingmsg4
		mov al, line4[si] 
		xor bh, bh
		mov bh, 0
		mov bl, 0Ah
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		inc xCoor
		inc si
	jmp loop_line4
	
	next_openingmsg4:
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	
	xor si, si
	mov yCoor, 14
	mov xCoor, 36
	
	loop_line5:
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		cmp line5[si], '$'
		je next_openingmsg5
		mov al, line5[si] 
		xor bh, bh
		mov bh, 0
		mov bl, 0Ah
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		inc xCoor
		inc si
	jmp loop_line5
	
	next_openingmsg5:
	
	mov dl, 0ah
	mov ah, 02h
	int 21h
	
	xor si, si
	mov yCoor, 16
	mov xCoor, 36
	
	loop_line6:
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		cmp line6[si], '$'
		je return_openingmsg
		mov al, line6[si] 
		xor bh, bh
		mov bh, 0
		mov bl, 0Ah
		xor cx, cx
		mov cx, 1
		mov ah, 09h
		int 10h
		inc xCoor
		inc si
	jmp loop_line6
	
	return_openingmsg:
		mov xCoor, 70
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 01h 
		int 21h
		mov inputChoice, al
	ret
	
print_openingmsg endp
	
	print_stat proc
	
	xor dx, dx
	
	mov dh, 16
	mov dl, 33
	xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov dx, offset stat1
	mov ah, 09h
	int 21h
	
	;mov dl, 'x'
	;mov ah, 09h
	;int 21h
	
	mov dh, 17
	mov dl, 33
	xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov dx, offset stat2
	mov ah, 09h
	int 21h
	
	mov dl, score
	add dl, 48
	mov ah, 02h
	int 21h
	
	mov dh, 18
	mov dl, 33
	xor bh, bh 
    mov ah, 02h 
    int 10h
	
	
	mov dx, offset stat3
	mov ah, 09h
	int 21h
	
	mov dl, level
	add dl, 48
	mov ah, 02h
	int 21h
	
	ret
	
	print_stat endp
	
	;----------------------------------------------------;
	;	WORD TABLE
	;----------------------------------------------------;
	
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
	call message2
	jmp end_wtable
	
	next_msg3:
	cmp al, '3'
	jne next_msg4
	call message3
	jmp end_wtable
	
	next_msg4:
	cmp al, '4'
	jne next_msg5
	call message4
	jmp end_wtable
	
	next_msg5:
	cmp al, '5'
	jne next_msg6
	call message5
	jmp end_wtable
	
	next_msg6:
	cmp al, '6'
	jne next_msg7
	call message6
	jmp end_wtable
	
	next_msg7:
	cmp al, '7'
	jne next_msg8
	call message7
	jmp end_wtable
	
	next_msg8:
	cmp al, '8'
	jne next_msg9
	call message8
	jmp end_wtable
	
	next_msg9:
	cmp al, '9'
	call message9
	
	end_wtable:
	ret
	
	word_table endp
	
	message0 proc
	
	xor si, si
	
	rec0:
	cmp msg0[si],'$'
	je end0
	mov dl, msg0[si]
	mov msg[si], dl
	inc si
	jmp rec0
	
	end0:
	mov msg[si],'$'

	ret
	
	message0 endp
	
	message1 proc
	
	xor si, si
	
	rec1:
	cmp msg1[si],'$'
	je end1
	mov dl, msg1[si]
	mov msg[si], dl
	inc si
	jmp rec1
	
	end1:
	mov msg[si],'$'

	ret
	
	message1 endp
	
	message2 proc
	
	xor si, si
	
	rec2:
	cmp msg2[si],'$'
	je end2
	mov dl, msg2[si]
	mov msg[si], dl
	inc si
	jmp rec2
	
	end2:
	mov msg[si],'$'

	ret
	
	message2 endp
	
	message3 proc
	
	xor si, si
	
	rec3:
	cmp msg3[si],'$'
	je end3
	mov dl, msg3[si]
	mov msg[si], dl
	inc si
	jmp rec3
	
	end3:
	mov msg[si],'$'

	ret
	
	message3 endp
	
	message4 proc
	
	xor si, si
	
	rec4:
	cmp msg4[si],'$'
	je end4
	mov dl, msg4[si]
	mov msg[si], dl
	inc si
	jmp rec4
	
	end4:
	mov msg[si],'$'

	ret
	
	message4 endp
	
	message5 proc
	
	xor si, si
	
	rec5:
	cmp msg5[si],'$'
	je end5
	mov dl, msg5[si]
	mov msg[si], dl
	inc si
	jmp rec5
	
	end5:
	mov msg[si],'$'

	ret
	
	message5 endp
	
	message6 proc
	
	xor si, si
	
	rec6:
	cmp msg6[si],'$'
	je end6
	mov dl, msg6[si]
	mov msg[si], dl
	inc si
	jmp rec6
	
	end6:
	mov msg[si],'$'

	ret
	
	message6 endp
	
	message7 proc
	
	xor si, si
	
	rec7:
	cmp msg7[si],'$'
	je end7
	mov dl, msg7[si]
	mov msg[si], dl
	inc si
	jmp rec7
	
	end7:
	mov msg[si],'$'

	ret
	
	message7 endp
	
	message8 proc
	
	xor si, si
	
	rec8:
	cmp msg8[si],'$'
	je end8
	mov dl, msg8[si]
	mov msg[si], dl
	inc si
	jmp rec8
	
	end8:
	mov msg[si],'$'

	ret
	
	message8 endp
	
	message9 proc
	
	xor si, si
	
	rec9:
	cmp msg9[si],'$'
	je end9
	mov dl, msg9[si]
	mov msg[si], dl
	inc si
	jmp rec9
	
	end9:
	mov msg[si],'$'

	ret
	
	message9 endp
	
	;---------------------------------------------------;
	;	DISPLAY BLANKS
	;---------------------------------------------------;
	
	display_temp proc
	
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
	
	display_temp endp
	
	init_temp proc
	
	mov str_l, 0
	mov bl, '_'
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
	
	lea dx, temp
	mov ah, 09h
	int 21h
	
	ret
	
	init_temp endp
	
	reset_stackinput proc
	xor si, si
	
	loop_reset:
	cmp stack_input[si], '$'
	je return_reset
	mov stack_input[si], '$'
	inc si
	jmp loop_reset
	
	return_reset:
	ret
	
	reset_stackinput endp
	
	reset_stats proc
	
	mov correct, 0
	mov incorrect, 0
	mov lives, 7
	mov credit, 0
	mov winner, 0
	call reset_stackinput
	
	ret
	
	reset_stats endp
	
	;-----------------------------------------------------;
	;	USER INPUT
	;-----------------------------------------------------;
	
	user_input proc
	
	get_input:
	mov dh, 14
	mov dl, 33
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov dx, offset input_msg
	mov ah, 09h
	int 21h
	
	mov ah, 01h
	int 21h
	mov bl, al
	xor si, si
	
	
	check_dup:
	cmp stack_input[si],'$'
	je store_input
	cmp al, stack_input[si]
	je duplicate
	inc si
	jmp check_dup
	
	duplicate:
	mov dh, 14
	mov dl, 33
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov dx, offset dup_msg
	mov ah, 09h
	int 21h
	call delay
	jmp get_input
	
	STORE_INPUT:
	MOV STACK_INPUT[SI],BL
	INC SI
	MOV STACK_INPUT[SI],'$'
	
	ret 
	
	user_input endp
	
	;--------------------------------------------------;
	;	CHECK INPUT
	;--------------------------------------------------;
	
	check_input proc
	xor si,si
	
	loop_check:
	cmp msg[si],'$'
	je check_credit
	cmp bl, msg[si]
	jne not_matched
	mov temp[si], bl
	inc correct
	inc credit
	not_matched:
	inc si
	jmp loop_check
	
	check_credit:
	cmp credit, 0
	jne check_return
	inc incorrect
	dec lives
	
	check_return:
	mov credit, 0
	
	ret
	
	check_input endp
	
	;-----------------------------------------------------------------;
	;  ERROR DISPLAY
	;-----------------------------------------------------------------;
	
	display_error proc
	
	cmp incorrect, 0
	jne next_error
	call incorrect0
	jmp return_displayerror
	
	next_error:
	cmp incorrect, 1
	jne next_error2
	call incorrect1
	jmp return_displayerror
	
	next_error2:
	cmp incorrect, 2
	jne next_error3
	call incorrect2
	jmp return_displayerror
	
	next_error3:
	cmp incorrect, 3
	jne next_error4
	call incorrect3
	jmp return_displayerror
	
	next_error4:
	cmp incorrect, 4
	jne next_error5
	call incorrect4
	jmp return_displayerror
	
	next_error5:
	cmp incorrect,5 
	jne next_error6
	call incorrect5
	jmp return_displayerror
	
	next_error6:
	cmp incorrect, 6
	jne next_error7
	call incorrect6
	jmp return_displayerror
	
	next_error7:
	cmp incorrect, 7
	call incorrect7
	
	return_displayerror:
	ret
	
	display_error endp
	
	incorrect0 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '0' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect0 endp
	
	incorrect1 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '1' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect1 endp
	
	incorrect2 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '2' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect2 endp
	
	incorrect3 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '3' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect3 endp
	
	incorrect4 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '4' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect4 endp
	
	incorrect5 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '5' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect5 endp
	
	incorrect6 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '6' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect6 endp
	
	incorrect7 proc
	
	mov dh, 8
	mov dl, 20
    xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov al, '7' 
	xor bh, bh
	mov bh, 0
	mov bl, 0Ah
	xor cx, cx
	mov cx, 1
	mov ah, 09h
	int 10h
	
	ret
	
	incorrect7 endp
	
	;-----------------------------------------------;
	;	GAME STATUS
	;-----------------------------------------------;
	
	game_status proc
	
	mov al, correct
	cmp al, str_l
	jne if_gameover
	mov winner, 1
	jmp gamestat_return
	
	if_gameover:
	cmp lives,0
	jne gamestat_return
	mov loser, 1
	
	gamestat_return:
	call display_error
	call display
	
	ret
	
	game_status endp
	
	win_status proc
	
	call clrscrn
	call print_border
	call print_border2
	call display_error
	mov incorrect, 8
	call display
	
	mov dh, 12
    mov dl, 33
    xor bh, bh 
    mov ah, 02h
    int 10h

    mov dx, offset temp
    mov ah, 09h
    int 21h
	
	mov dh, 14
    mov dl, 33
    xor bh, bh 
    mov ah, 02h
    int 10h 
	
	mov dx, offset win_msg
    mov ah, 09h
    int 21h
	
	cmp level, 1
	jne next_level
	
	mov dx, offset level1_msg
    mov ah, 09h
    int 21h
	jmp next_winstat
	
	next_level:
	cmp level, 2
	jne next_level2
	
	mov dx, offset level2_msg
    mov ah, 09h
    int 21h
	jmp next_winstat
	
	next_level2:
	mov dx, offset level3_msg
    mov ah, 09h
    int 21h
	ret
	
	next_winstat:
	inc level
	
	mov dh, 15
    mov dl, 33
    xor bh, bh 
    mov ah, 02h
    int 10h 
	
	mov dx, offset play_again
	mov ah, 09h
	int 21h
	
	mov ah, 01h
	int 21h
	mov play, al
	
	ret
	win_status endp
	
	game_over proc
	
	call clrscrn
	call print_border
	call print_border2
	call display_error
	mov incorrect, 7
	call display
	
	mov dh, 12
    mov dl, 33
    xor bh, bh 
    mov ah, 02h
    int 10h

    mov dx, offset temp
    mov ah, 09h
    int 21h
	
	mov dh, 14
    mov dl, 33
    xor bh, bh 
    mov ah, 02h
    int 10h 
	
	mov dx, offset lose_msg
    mov ah, 09h
    int 21h
	
	ret
	
	game_over endp
	
	high_score proc
	
	mov dh, 12
    mov dl, 40
    xor bh, bh 
    mov ah, 02h
    int 10h
	
	mov dl, '#'
	mov ah, 02h
	int 21h
	
	mov ax, 4c00h
	int 21h
	
	ret
	
	high_score endp
	
	playGame proc
	
		start:
		call reset_stats
		
		call clrscrn
		call print_border
		call print_border2
		mov dh, 12
		mov dl, 33
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
		call init_temp
		
		start_of_game:
		call clrscrn
		call print_border
		call print_border2
		call display_error
		call display
		
		input:
		call game_status
		call print_stat
		cmp winner, 1
		jne check_gameover
		call win_status
		jmp win_question
		check_gameover:
		cmp lives, 0
		jne game_continue
		call game_over
		jmp lose_question
		game_continue:
		call display_temp
		call user_input
		call check_input
		jmp input
		
		
		win_question:
		cmp play, '1'
		je start
		call high_score
		
		lose_question:
		cmp play, 1
		jne end_game
		mov level, 1
		mov score, 0
		jmp start
		
		end_game:
		call high_score
		
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
			ret
	playGame endp

	
	getName proc
		xor si, si
		mov yCoor, 17
		mov xCoor, 36
		
		loop_line0:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line0[si], '$'
			je scanName
			mov al, line0[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line0
		xor bx, bx
		scanName:
			mov ah, 01h
			int 21h
			mov inputTemp, al
			mov playerName[bx], al
			inc bx
			cmp inputTemp, 13
			jne scanName
			sub bx, 1
			mov playerName[bx], '$'
			
			;SAVE PLAYERNAME TO FILE
			mov ah,3dh
			mov al,0
			lea dx,filename
			int 21h
			mov handle, ax
			jc erroropen2
			jmp noerror2
			erroropen2:
				lea dx, errormess
				mov ah, 09h
				int 21h
				jmp return1
			noerror2:
				mov dx, offset playerName
				mov bx, handle
				mov cx,38   
				mov ah,40h              
				int 21h  
				mov ah, 3eh ;close file
				int 21h
			
		return1:
		ret
	getName endp
	
	viewHighScore proc
		call clrscrn
		call print_border
		
		xor si, si
		mov yCoor, 7
		mov xCoor, 35
		
		loop_line7:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line7[si], '$'
			je next_openingmsg6
			mov al, line7[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line7
		
		next_openingmsg6:
		xor si, si
		mov yCoor, 9
		mov xCoor, 10
		
		loop_line8:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line8[si], '$'
			je next_openingmsg7
			mov al, line8[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line8
			
		next_openingmsg7:
		xor si, si
		mov yCoor, 9
		mov xCoor, 60
		
		loop_line9:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line9[si], '$'
			je next_openingmsg8
			mov al, line9[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line9
		
		next_openingmsg8:
		xor si, si
		mov yCoor, 9
		mov xCoor, 30
		
		loop_line10:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line10[si], '$'
			je next_openingmsg9
			mov al, line10[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line10
		
		next_openingmsg9:
		xor si, si
		mov yCoor, 9
		mov xCoor, 50
		
		loop_line11:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line11[si], '$'
			je openfile
			mov al, line11[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line11
		
		openfile:
			mov ah,3dh
			mov al,0
			lea dx,filename
			int 21h
			mov BX,AX
			jc erroropen
			jmp noerror
			erroropen:
				lea dx, errormess
				mov ah, 09h
				int 21h
				jmp return
			noerror:
				mov ah,3fh
				mov cx,200
				lea dx,buffer
				int 21h
				
				mov yCoor, 10
				mov xCoor, 10
				
				xor bx, bx
				loop_buffer:
					cmp buffer[bx], '/'
					je next_loop_buffer
					cmp buffer[bx], 0ah
					je next_buffer
					
					mov dh, yCoor
					mov dl, xCoor
					xor bh, bh 
					mov ah, 02h 
					int 10h
					
					mov dl, buffer[bx]
					mov ah, 02h
					int 21h
					jmp next_buffer
					next_loop_buffer:
					add dashcount, 1
					cmp dashcount, 1
					je for_print_category
					cmp dashcount, 2
					je for_print_level
					cmp dashcount, 3
					je for_print_score
					jmp next_buffer
					for_print_category:	
						dec xCoor
						mov xCoor, 29
						jmp next_buffer
					for_print_level:	
						dec xCoor
						mov xCoor, 49
						jmp next_buffer
					for_print_score:	
						dec xCoor
						mov xCoor, 59
					next_buffer:
					add bx, 1
					inc xCoor
					cmp buffer[bx], 0ah
					je to_loop_buffer
					jmp gotoloopbuffer
					to_loop_buffer:
						mov dashcount, 0
						add yCoor, 1
						mov xCoor, 9 
						jmp loop_buffer
					gotoloopbuffer:
					cmp buffer[bx], 0
				jne loop_buffer
				mov ah, 3eh
				int 21h
		return:
		ret
	viewHighScore endp
	main proc
	
	mov ax, @data
	mov ds, ax
	
	call clrscrn
	call print_border
	call print_openingmsg
	call delay
	;call countdown
	
	;call playGame
	
	cmp inputChoice, '1'
	je callPlayGame
	jmp next1
	callPlayGame:
		call getName
		call countdown
		call playGame

		jmp exit
	next1:
		cmp inputChoice, '2'
		je callViewHighScore
		jmp next2
	callViewHighScore:
		call viewHighScore
		jmp exit
	next2:
		cmp inputChoice, '3'
		je exit
	
	exit:
	mov ax, 4c00h
	int 21h
	
	main endp
	end main
