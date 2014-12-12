title Hangman
; hangman.asm
; @author HAMssembler

.model small
.data
	
	TEMP DB ?,'$'
	
	PROMPT1 DB 0DH,0AH,'Are you ready to play? (y for YES, n for NO):', '$'
	PROMPT2 DB 0DH,0AH,'Please try again ', '$'
	PROMPT3 DB 0DH,0AH,'What letter do you guess?  ', '$'
	PROMPT4 DB 0DH,0AH,'The word is:',0DH,0AH, '$'
	
	STACK_INPUT DB ?,'$'
	
	PROMPT5 DB 0DH,0AH,'Congratulations! You won the game',0DH,0AH, '$'
	PROMPT6 DB 0DH,0AH,'Sorry you missed.',0DH,0AH, '$'
	PROMPT7 DB 0DH,0AH,'Sorry, duplicate entry.  Please try again.',0DH,0AH, '$'
	PROMPT8 DB 0DH,0AH,'List of chosen letter(s): ', '$'
	CRLF   DB  0DH, 0AH, '$'
	
	LINE0 DB 'Enter your name:', '$'
	LINE1 DB "H A M A S S E M B L E R'S",'$'
	LINE2 DB 'H A N G M A N','$'
	LINE3 DB '[1] PLAY', '$'
	LINE4 DB '[2] VIEW HIGH SCORES', '$'
	LINE5 DB '[3] EXIT', '$'
	LINE6 DB 'Enter Game Mode:', '$'
	LINE7 DB 'HIGH SCORES', '$' 
	LINE8 DB 'NAME', '$' 
	LINE9 DB 'SCORE', '$' 
	LINE10 DB 'CATEGORY', '$'
	LINE10_2 DB 'LEVEL', '$'	
	LINE11 DB 'CATEGORIES', '$' 
	LINE12 DB '[1] UP Profs', '$' 
	LINE13 DB '[2] Only in UP', '$' 
	LINE14 DB '[3] Block 12', '$'
	LINE15 DB 'Choose Category:', '$'
	LINE16 DB 'Time left:', '$'
	ERRORMSG DB 'No such option! ','$'
	HOORAY_MSG DB 'C O N G R A T U L A T I O N S!','$' 
	HOORAY2_MSG DB 'All Levels Cleared.','$' 	
	GAMEOVER_MSG DB 'G A M E  O V E R.','$' 	
	INPUT_MSG DB ' Enter your input :	$'
	DUP_MSG DB ' You already entered$'
	
	filename db "scores.txt", 0
	
	handle dw ?
	
	MSG11 DB  'pia poblador','$'
	MSG12 DB  'lyndon decasa','$'
	MSG13 DB  'george dumanon','$'
	MSG14 DB  'nelson villarante','$'
	MSG15 DB  'althom mendoza','$'
	
	MSG21 DB  'oblation run','$'
	MSG22 DB  'guards','$'
	MSG23 DB  'removals','$'
	MSG24 DB  'enrolment','$'
	MSG25 DB  'sablay','$'
	
	MSG31 DB  'joseph tuazon','$'
	MSG32 DB  'rafael ferrer','$'
	MSG33 DB  'chester francisco','$'
	MSG34 DB  'marvin serrano','$'
	MSG35 DB  'kit sabiniano','$'
	
	HINT11 DB  'MIT connections','$'
	HINT12 DB  '4ft','$'
	HINT13 DB  'Loves Crocodiles','$'
	HINT14 DB  'King and Queen of Hearts','$'
	HINT15 DB  'MP pa more','$'
	
	HINT21 DB  'ibon man may layang lumipad','$'
	HINT22 DB  'tusok gang','$'
	HINT23 DB  'dead or alive','$'
	HINT24 DB  'hunger games','$'
	HINT25 DB  'pangarap ka na lang ba?','$'
	
	HINT31 DB  'AHMMM..','$'
	HINT32 DB  'Curve na sana eh!','$'
	HINT33 DB  'Daniel Padilla','$'
	HINT34 DB  '#DesktopBackGround','$'
	HINT35 DB  'Anong sabi ni ano?','$'

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
	
	count db 3
	countTime db 18
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
	level4_msg db 'Level Four Cleared!','$'
	level5_msg db 'Level Five Cleared!','$'
	play_again db '[1] Stay On Game  [0] End Game','$'
	replay db '(Press Space Bar to Return to Main Menu)','$'
	dash db '/', '$'
	dash2 db '-', '$'
	cat1 db 'UP Instructors', '$'
	cat2 db 'Tatak Isko', '$'
	cat3 db 'Category3', '$'
	stat1 db ' Hint: ','$'
	stat2 db ' Score: ','$'
	stat3 db ' Level: ','$'
	draw0 DB '+=======+', '$'
	level db 1
	score db 0
	winner db 0
	loser db 0
	lives db 7
	play db ?
	
	
	MSG  DB ?,'$'
	ones db 0
	inputChoice db ?
	
	inputTemp db ?
	buffer db 256 DUP(?)
	errormess db "Error in opening file!$"
	
	outputThou db 0
	outputHund db 0
	outputTens db 0
	outputOnes db 0
	outputMid db 0
	dashcount db 0
	playerName db 20 DUP(?)
	inputCategory db ?
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
	
	delaytimer proc
		mov ah, 00
		int 1Ah
		mov bx, dx

		jmp_delay_timer:
			int 1Ah
			sub dx, bx
			cmp dl, countTime
			jl jmp_delay_timer
		ret
		
	delaytimer endp
	
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
	mov yCoor, 8
	mov xCoor, 28
	
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
	mov yCoor, 9
	mov xCoor, 34
	
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
	mov yCoor, 11
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
	mov yCoor, 12
	mov xCoor, 30
	
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
	mov yCoor, 13
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
	mov xCoor, 33
	
	loop_line6:
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		cmp line6[si], '$'
		je option_input
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
	
	option_input:
		mov xCoor, 70
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		opening_input:
		mov ah, 01h 
		int 21h
		mov inputChoice, al
		
		cmp al, '1'
		jb re_enter
		cmp al, '3'
		ja re_enter
		
		jmp return_openingmsg
		
		re_enter:
		mov xCoor, 33
		mov yCoor, 16
		
	loop7:
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h
		int 10h

		mov dx, offset errormsg
		mov ah, 09h
		int 21h
		
		call delay
		jmp next_openingmsg5
		
	return_openingmsg:
	ret
	
	print_openingmsg endp
	
	print_score proc
	
	xor ax, ax
	mov al, score
	
	mov bl, 100
	div bl
	mov outputMid, al
	mov outputTens, ah
	mov al, 00
	mov ah, 00
	mov bl, 00
	mov al, outputMid
	mov bl, 10
	div bl
	add al, 48
	add ah, 48
	mov outputThou, al
	mov outputHund, ah
	mov al, 00
	mov ah, 00
	mov bl, 00
	mov al, outputTens
	mov bl, 10
	div bl
	add al, 48
	add ah, 48
	mov outputTens, al
	mov outputOnes, ah
	
	mov dl, outputThou
	mov ah, 02h
	int 21h

	mov dl, outputHund
	mov ah, 02h
	int 21h
	
	mov dl, outputTens
	mov ah, 02h
	int 21h
	
	mov dl, outputOnes
	mov ah, 02h
	int 21h
	
	mov dl, 10
	mov ah, 02h
	int 21h
	
	ret
	
	print_score endp
	
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
	
	;insert HINT HERE
	cmp inputCategory, '1'
	jne next_catHint2
		cmp  level, 1
		jne next_hint12
		mov dx, offset hint11
		jmp print_hint
		next_hint12:
		cmp  level, 2
		jne next_hint13
		mov dx, offset hint12
		jmp print_hint
		next_hint13:
		cmp  level, 3
		jne next_hint14
		mov dx, offset hint13
		jmp print_hint
		next_hint14:
		cmp  level, 4
		jne next_hint15
		mov dx, offset hint14
		jmp print_hint
		next_hint15:
		mov dx, offset hint15
		jmp print_hint
	next_catHint2:
	cmp inputCategory, '2'
	jne next_catHint3
		cmp  level, 1
		jne next_hint22
		mov dx, offset hint21
		jmp print_hint
		next_hint22:
		cmp  level, 2
		jne next_hint23
		mov dx, offset hint22
		jmp print_hint
		next_hint23:
		cmp  level, 3
		jne next_hint24
		mov dx, offset hint23
		jmp print_hint
		next_hint24:
		cmp  level, 4
		jne next_hint25
		mov dx, offset hint24
		jmp print_hint
		next_hint25:
		mov dx, offset hint25
		jmp print_hint
	next_catHint3:
		cmp  level, 1
		jne next_hint32
		mov dx, offset hint31
		jmp print_hint
		next_hint32:
		cmp  level, 2
		jne next_hint33
		mov dx, offset hint32
		jmp print_hint
		next_hint33:
		cmp  level, 3
		jne next_hint34
		mov dx, offset hint33
		jmp print_hint
		next_hint34:
		cmp  level, 4
		jne next_hint35
		mov dx, offset hint34
		jmp print_hint
		next_hint35:
		mov dx, offset hint35
		jmp print_hint
	print_hint:
	mov ah, 09h
	int 21h
		
	mov dh, 17
	mov dl, 33
	xor bh, bh 
    mov ah, 02h 
    int 10h
	
	mov dx, offset stat2
	mov ah, 09h
	int 21h
	
	call print_score
	
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
	;	WORD TABLE (depends on the level)
	;----------------------------------------------------;
	
	word_table proc
    
	cmp inputCategory, '1'
	jne next_category1
	
	cmp level, 1
	jne next_msg11
	call message11
	jmp end_wtable
	
	next_msg11: 
	cmp level, 2
	jne next_msg12
	call message12
	jmp end_wtable
	
	next_msg12:
	cmp level, 3
	jne next_msg13
	call message13
	jmp end_wtable
	
	next_msg13:
	cmp level, 4
	jne next_msg14
	call message14
	jmp end_wtable
	
	next_msg14:
	call message15
	jmp end_wtable
	
	next_category1:
	cmp inputCategory, '2'
	jne next_category2
	
	cmp level, 1
	jne next_msg21
	call message21
	jmp end_wtable
	
	next_msg21: 
	cmp level, 2
	jne next_msg22
	call message22
	jmp end_wtable
	
	next_msg22:
	cmp level, 3
	jne next_msg23
	call message23
	jmp end_wtable
	
	next_msg23:
	cmp level, 4
	jne next_msg24
	call message24
	jmp end_wtable
	
	next_msg24:
	call message25
	jmp end_wtable
	
	next_category2:
	
	cmp level, 1
	jne next_msg31
	call message31
	jmp end_wtable
	
	next_msg31: 
	cmp level, 2
	jne next_msg32
	call message32
	jmp end_wtable
	
	next_msg32:
	cmp level, 3
	jne next_msg33
	call message33
	jmp end_wtable
	
	next_msg33:
	cmp level, 4
	jne next_msg34
	call message34
	jmp end_wtable
	
	next_msg34:
	call message35
	jmp end_wtable
	
	end_wtable:
	ret
	
	word_table endp
	
	;;;;;CATEGORY 1
	
	message11 proc
	
	xor si, si
	
	rec11:
	cmp msg11[si],'$'
	je end11
	mov dl, msg11[si]
	mov msg[si], dl
	inc si
	jmp rec11
	
	end11:
	mov msg[si],'$'

	ret
	
	message11 endp
	
	message12 proc
	
	xor si, si
	
	rec12:
	cmp msg12[si],'$'
	je end12
	mov dl, msg12[si]
	mov msg[si], dl
	inc si
	jmp rec12
	
	end12:
	mov msg[si],'$'

	ret
	
	message12 endp
	
	message13 proc
	
	xor si, si
	
	rec13:
	cmp msg13[si],'$'
	je end13
	mov dl, msg13[si]
	mov msg[si], dl
	inc si
	jmp rec13
	
	end13:
	mov msg[si],'$'

	ret
	
	message13 endp
	
	message14 proc
	
	xor si, si
	
	rec14:
	cmp msg14[si],'$'
	je end14
	mov dl, msg14[si]
	mov msg[si], dl
	inc si
	jmp rec14
	
	end14:
	mov msg[si],'$'

	ret
	
	message14 endp
	
	message15 proc
	
	xor si, si
	
	rec15:
	cmp msg15[si],'$'
	je end15
	mov dl, msg15[si]
	mov msg[si], dl
	inc si
	jmp rec15
	
	end15:
	mov msg[si],'$'

	ret
	
	message15 endp
	
	;;;;CATEGORY 2
	
	message21 proc
	
	xor si, si
	
	rec21:
	cmp msg21[si],'$'
	je end21
	mov dl, msg21[si]
	mov msg[si], dl
	inc si
	jmp rec21
	
	end21:
	mov msg[si],'$'

	ret
	
	message21 endp
	
	message22 proc
	
	xor si, si
	
	rec22:
	cmp msg22[si],'$'
	je end22
	mov dl, msg22[si]
	mov msg[si], dl
	inc si
	jmp rec22
	
	end22:
	mov msg[si],'$'

	ret
	
	message22 endp
	
	message23 proc
	
	xor si, si
	
	rec23:
	cmp msg23[si],'$'
	je end23
	mov dl, msg23[si]
	mov msg[si], dl
	inc si
	jmp rec23
	
	end23:
	mov msg[si],'$'

	ret
	
	message23 endp
	
	message24 proc
	
	xor si, si
	
	rec24:
	cmp msg24[si],'$'
	je end24
	mov dl, msg24[si]
	mov msg[si], dl
	inc si
	jmp rec24
	
	end24:
	mov msg[si],'$'

	ret
	
	message24 endp
	
	message25 proc
	
	xor si, si
	
	rec25:
	cmp msg25[si],'$'
	je end25
	mov dl, msg25[si]
	mov msg[si], dl
	inc si
	jmp rec25
	
	end25:
	mov msg[si],'$'

	ret
	
	message25 endp
	
	;;;;CATEGORY 3
	
	message31 proc
	
	xor si, si
	
	rec31:
	cmp msg31[si],'$'
	je end31
	mov dl, msg31[si]
	mov msg[si], dl
	inc si
	jmp rec31
	
	end31:
	mov msg[si],'$'

	ret
	
	message31 endp
	
	message32 proc
	
	xor si, si
	
	rec32:
	cmp msg32[si],'$'
	je end32
	mov dl, msg32[si]
	mov msg[si], dl
	inc si
	jmp rec32
	
	end32:
	mov msg[si],'$'

	ret
	
	message32 endp
	
	message33 proc
	
	xor si, si
	
	rec33:
	cmp msg33[si],'$'
	je end33
	mov dl, msg33[si]
	mov msg[si], dl
	inc si
	jmp rec33
	
	end33:
	mov msg[si],'$'

	ret
	
	message33 endp
	
	message34 proc
	
	xor si, si
	
	rec34:
	cmp msg34[si],'$'
	je end34
	mov dl, msg34[si]
	mov msg[si], dl
	inc si
	jmp rec34
	
	end34:
	mov msg[si],'$'

	ret
	
	message34 endp
	
	message35 proc
	
	xor si, si
	
	rec35:
	cmp msg35[si],'$'
	je end35
	mov dl, msg35[si]
	mov msg[si], dl
	inc si
	jmp rec35
	
	end35:
	mov msg[si],'$'

	ret
	
	message35 endp
	
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
	
	cmp msg[si],' '
	jne not_space
	mov temp[si],' '
	
	not_space:
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
	cmp msg[si], ' '
	je not_inclen
	inc str_l
	not_inclen:
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
	mov loser, 0
	mov play, 0
	call reset_stackinput
	
	ret
	
	reset_stats endp
	
	printTimer proc
		xor ax, ax
		mov al, count
		
		mov bl, 100
		div bl
		mov outputMid, al
		mov outputTens, ah
		mov al, 00
		mov ah, 00
		mov bl, 00
		mov al, outputMid
		mov bl, 10
		div bl
		add al, 48
		add ah, 48
		mov outputThou, al
		mov outputHund, ah
		mov al, 00
		mov ah, 00
		mov bl, 00
		mov al, outputTens
		mov bl, 10
		div bl
		add al, 48
		add ah, 48
		mov outputTens, al
		mov outputOnes, ah
		
		mov dh, 5
		mov dl, 58
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		lea dx, line16
		mov ah, 09h
		int 21h
		
		mov dh, 5
		mov dl, 68
		xor bh, bh 
		mov ah, 02h 
		int 10h
		
		mov dl, outputTens
		mov ah, 02h
		int 21h
		
		mov dl, outputOnes
		mov ah, 02h
		int 21h
		
		mov dl, 10
		mov ah, 02h
		int 21h
		ret
	printTimer endp
	
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
	
	xor ax, ax
	mov ah, 01h
	int 16h
	jz proceed
	mov ah, 00h
	int 16h
	mov dl, al
	mov ah, 02h
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
	proceed:
		call printTimer
		call delayTimer
		cmp count, 0
		jne dec_count
		; for displaying the right answer after times up
		call clrscrn
		call print_border
		call print_border2
		
		call display
		
		mov dh, 12
		mov dl, 33
		xor bh, bh 
		mov ah, 02h
		int 10h
		
		mov dx, offset msg
		mov ah, 09h
		int 21h
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		; end
		call game_over
		dec_count:
		dec count
	jmp get_input
	
	STORE_INPUT:
	MOV STACK_INPUT[SI],BL
	INC SI
	MOV STACK_INPUT[SI],'$'
	
	exit_user_input:
	ret 
	
	user_input endp
	
	;--------------------------------------------------;
	;	CHECK INPUT
	;--------------------------------------------------;
	
	check_input proc
	xor si,si
	
	cmp bl, 97
	jge loop_check
	add bl, 32
	
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
	jne gain_score
	inc incorrect
	dec lives
	cmp score, 0
	je check_return
	dec score
	jmp check_return
	
	gain_score:
	inc score
	
	check_return:
	mov credit, 0
	
	ret
	
	check_input endp
	
	;-----------------------------------------------;
	;	GAME STATUS
	;-----------------------------------------------;
	
	game_status proc
	
	mov al, correct
	cmp al, str_l
	jne if_gameover
	mov winner, 1
	cmp level, 1
	jne next_movcount1
	mov count, 30
	next_movcount1:
	cmp level, 2
	jne next_movcount2	
	mov count, 25
	next_movcount2:
	cmp level, 3
	jne next_movcount3
	mov count, 20
	next_movcount3:
	cmp level, 4
	jne next_movcount4
	mov count, 15
	next_movcount4:
	cmp level, 5
	jne next_movcount5
	mov count, 15
	
	next_movcount5:
	jmp gamestat_return
	
	if_gameover:
	cmp lives,0
	jne gamestat_return
	mov loser, 1
	call clrscrn
	call print_border
	call print_border2
	
	call display
	
	mov dh, 12
    mov dl, 33
    xor bh, bh 
    mov ah, 02h
    int 10h
	
	mov dx, offset msg
    mov ah, 09h
    int 21h
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	
	gamestat_return:
	call display
	
	ret
	
	game_status endp
	
	win_status proc
	
	call clrscrn
	call print_border
	call print_border2
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
	cmp level, 3
	jne next_level3
	
	mov dx, offset level3_msg
    mov ah, 09h
    int 21h
	jmp next_winstat
	
	next_level3:
	cmp level, 4
	jne next_level4
	
	mov dx, offset level4_msg
    mov ah, 09h
    int 21h
	jmp next_winstat
	
	next_level4:
	call game_done
	jmp next_winstat
	
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
	
	return_winstat:
	ret
	win_status endp
	
	game_done proc
	
	call clrscrn
	call print_border
	
	mov dh, 12
    mov dl, 30
    xor bh, bh 
    mov ah, 02h
    int 10h 
	
	mov dx, offset hooray_msg
    mov ah, 09h
    int 21h
	
	mov dh, 14
    mov dl, 30
    xor bh, bh 
    mov ah, 02h
    int 10h 
	
	mov dx, offset hooray2_msg
    mov ah, 09h
    int 21h
	
	call delay
	call delay
	call delay
	;call viewhighscore
	
	mov dx, offset filename  
	mov al, 2        
	mov ah, 3dh     
	int 21h 
	
	jc openerr2
	
	mov handle, ax      
	mov bx, handle
	xor cx, cx
	xor dx, dx
	mov ah, 42h
	mov al, 02h
	int 21h	
	
	jmp exit_goto_openerr2
	goto_openerr2:
	jmp openerr2
	
	exit_goto_openerr2:
	xor cx, cx
	xor dx, dx
	mov dx, offset playerName
	mov bx, handle      
	mov cx, 3     
	mov ah, 40h      
	int 21h 
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset inputCategory
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	;add level, 48
	mov dx, 5
	;add dx, 48
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	;mov dl, level
	;mov bx, handle      
	;mov cx, 1  
	;mov ah, 40h      
	;int 21h
	
	add score, 48
	mov dl, 10
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset dash2
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	lea dx, playerName
	mov ah, 09h
	int 21h

	;jc writeerr2
	;cmp ax,cx       
	;jne writeerr2 

	mov bx,handle   
	mov ah,3eh     
	int 21h     
	
	jmp back_to_game2
	
	writeerr2:
	mov dx,offset errormess
	jmp enderr2

	openerr2:
	mov dx,offset errormess
	jmp enderr2
	
	enderr2:
	mov ah, 09h 
	int 21h 
	mov ax, 4c01h 
	int 21h 
	
	back_to_game2:	
		mov dh, 17
		mov dl, 20
		xor bh, bh 
		mov ah, 02h 
		int 10h
			
		mov dx, offset replay
		mov ah, 09h
		int 21h
			
		mov ah, 01h
		int 21h
		cmp al, 32
		jne exit_game3
		call main
			
		exit_game3:
		mov ax, 4c00h
		int 21h
		ret
	
	ret
	
	game_done endp
	
	game_over proc
	
	call clrscrn
	call print_border
	
	mov dh, 12
    mov dl, 30
    xor bh, bh 
    mov ah, 02h
    int 10h 
	
	mov dx, offset gameover_msg
    mov ah, 09h
    int 21h
	
	call delay
	call delay
	call delay
	;call viewHighscore
	
	mov dx, offset filename  
	mov al, 2        
	mov ah, 3dh     
	int 21h 
	
	jc goto_openerr
	
	mov handle, ax      
	mov bx, handle
	xor cx, cx
	xor dx, dx
	mov ah, 42h
	mov al, 02h
	int 21h	
	
	jmp exit_goto_openerr
	goto_openerr:
	jmp openerr
	
	exit_goto_openerr:
	xor cx, cx
	xor dx, dx
	mov dx, offset playerName
	mov bx, handle      
	mov cx, 3     
	mov ah, 40h      
	int 21h 
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset inputCategory
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	;add level, 48
	mov dl, level
	;add dx, 48
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	;mov dl, level
	;mov bx, handle      
	;mov cx, 1  
	;mov ah, 40h      
	;int 21h
	
	;add score, 48
	mov dx, 48
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	
	mov dx, offset dash
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	mov dx, offset dash2
	mov bx, handle      
	mov cx, 1  
	mov ah, 40h      
	int 21h
	
	lea dx, playerName
	mov ah, 09h
	int 21h

	;jc writeerr
	;cmp ax,cx       
	;jne writeerr  

	mov bx,handle   
	mov ah,3eh     
	int 21h     
	
	;call viewHighscore
	
	jmp back_to_game
	
	writeerr:
	mov dx,offset errormess
	jmp enderr

	openerr:
	mov dx,offset errormess
	jmp enderr
	
	enderr:
	mov ah, 09h 
	int 21h 
	mov ax, 4c01h 
	int 21h 
	        
	back_to_game:
			mov dh, 17
			mov dl, 20
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			mov dx, offset replay
			mov ah, 09h
			int 21h
			
			mov ah, 01h
			int 21h
			cmp al, 32
			jne exit_game2
			call main
			
		exit_game2:
		mov ax, 4c00h
		int 21h
		ret

	ret
	
	game_over endp
	
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
		
		call word_table
		call init_temp
		
		start_of_game:
		call clrscrn
		call print_border
		call print_border2
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
		call game_over
		
		lose_question:
		cmp play, 1
		jne end_game
		mov level, 1
		mov score, 0
		jmp start
		
		end_game:
		call game_over
		
		;re_enter:
		;call clrscrn
		;call print_border
		;call print_border2
		
		;mov dh, yinput
		;mov dl, xinput
		;xor bh, bh 
		;mov ah, 02h
		;int 10h

		;mov dx, offset errormsg
		;mov ah, 09h
		;int 21h
		;jmp loop1
		
		endwhile:
			ret
	playGame endp

	
	getName proc
		xor si, si
		mov yCoor, 17
		mov xCoor, 33
		
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
		xor si, si
		;mov playerName, 0
		;scanName:
			;mov ah, 01h
			;int 21h
			;mov inputTemp, al
			;mov playerName[si], al
			;inc si
			;cmp si, 5
		;jl scanName
			;sub si, 1
			;mov playerName[si], '$'
		scanName:
		mov ah, 01h
		int 21h
		mov playerName[0], al
		mov ah, 01h
		int 21h
		mov playerName[1], al
		mov ah, 01h
		int 21h
		mov playerName[2], al
		mov playerName[3], '$'
		
		return1:
		ret
	getName endp
	
	getCategory proc
	
		call clrscrn
		call print_border
		xor si, si
		mov yCoor, 9
		mov xCoor, 33
		
		loop_line11_2:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line11[si], '$'
			je next_line12
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
		jmp loop_line11_2
		
		next_line12:
		
		xor si, si
		mov yCoor, 11
		mov xCoor, 31
		loop_line12:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			cmp line12[si], '$'
			je next_line13
			mov al, line12[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line12
		
		next_line13:
		xor si, si
		mov yCoor, 12
		mov xCoor, 31
		loop_line13:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
				
			cmp line13[si], '$'
			je next_line14
			mov al, line13[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line13
		
		next_line14:
		xor si, si
		mov yCoor, 13
		mov xCoor, 31
		loop_line14:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
				
			cmp line14[si], '$'
			je next_line15
			mov al, line14[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line14
		next_line15:
		
		xor si, si
		mov yCoor, 15
		mov xCoor, 31
		loop_line15:
			mov dh, yCoor
			mov dl, xCoor
			xor bh, bh 
			mov ah, 02h 
			int 10h
				
			cmp line15[si], '$'
			je ret_getCategory
			mov al, line15[si] 
			xor bh, bh
			mov bh, 0
			mov bl, 0Ah
			xor cx, cx
			mov cx, 1
			mov ah, 09h
			int 10h
			inc xCoor
			inc si
		jmp loop_line15
	ret_getCategory:
		mov xCoor, 70
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 01h 
		int 21h
		mov inputCategory, al
		
		cmp al, '1'
		jb re_enter2
		cmp al, '3'
		ja re_enter2
		
		jmp return_categorymsg
		
		re_enter2:
		mov xCoor, 31
		mov yCoor, 15
		
		mov dh, yCoor
		mov dl, xCoor
		xor bh, bh 
		mov ah, 02h
		int 10h

		mov dx, offset errormsg
		mov ah, 09h
		int 21h
		
		call delay
		jmp next_line15
		
	return_categorymsg:
	ret
	getCategory endp
	
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
			
			cmp line10_2[si], '$'
			je openfile
			mov al, line10_2[si] 
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
					cmp buffer[bx], '-'
					je next_buffer
					
					mov dh, yCoor
					mov dl, xCoor
					xor bh, bh 
					mov ah, 02h 
					int 10h
					jmp loop_buffernext
					
					lp:
					jmp loop_buffer
					
					loop_buffernext:
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
					cmp buffer[bx], '-'
					je to_loop_buffer
					jmp gotoloopbuffer
					to_loop_buffer:
						mov dashcount, 0
						add yCoor, 1
						mov xCoor, 9 
						jmp loop_buffer
					gotoloopbuffer:
					cmp buffer[bx], 0
				jne lp
				mov ah, 3eh
				int 21h
		return:
			mov dh, 17
			mov dl, 20
			xor bh, bh 
			mov ah, 02h 
			int 10h
			
			mov dx, offset replay
			mov ah, 09h
			int 21h
			
			mov ah, 01h
			int 21h
			cmp al, 32
			jne exit_game
			call main
			
		exit_game:
		mov ax, 4c00h
		int 21h
		ret
	viewHighScore endp
	
	main proc
	
	mov ax, @data
	mov ds, ax
	
	main_menu:
	mov number, '3' ; reset timer
	mov level, 1
	mov score, 0
	mov count, 30
	call clrscrn
	call print_border
	call print_openingmsg
	call delay
	
	cmp inputChoice, '1'
	je callPlayGame
	jmp next1
	callPlayGame:
		call getName
		call getCategory
		mov dx, offset playerName
		mov ah, 09h
		int 21h
		;call countdown
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
