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

	LINE1 DB 'H A M A S S E M B L E R  |  H A N G M A N','$'
	LINE2 DB 'GET STARTED','$'
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
	
	level db 1
	score db 15
	win_msg db 'Congratulations!','$'
	lose_msg db 'You lose. Try Again!','$'
	level1_msg db 'Level One Cleared!','$'
	level2_msg db 'Level Two Cleared!','$'
	level3_msg db 'Level Three Cleared!','$'
	play_again db '[1] Stay On Game [0] End Game','$'
	winner db 0
	loser db 0
	lives db 7
	play db ?
	
	
	MSG  DB ?,'$'
	
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
	
	mov dh, 12
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
	
	mov dh, 12
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
	
	mov dh, 12
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
	
	mov dh, 12
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
	
	mov dh, 12
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
	
	mov dh, 12
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
	
	mov dh, 12
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
	
	mov dh, 12
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
	
	ret
	
	game_status endp
	
	win_status proc
	
	call clrscrn
	call print_border
	call print_border2
	call display_error
	
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
	call display_error
	
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

	main proc
	
	mov ax, @data
	mov ds, ax
	
	call clrscrn
	call print_border
	call print_openingmsg
	call delay
	call countdown
	
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
	
	input:
	call game_status
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
	mov ax, 4c00h
	int 21h
	
	main endp
	end main
