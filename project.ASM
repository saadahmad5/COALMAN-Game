;COAL MAN GAME 
;written by:
;Ahsan Saddique 15-0364 <initials AS> -- Saad Harris Ahmad 15-0305 <initials SA>
;Student at National University of Computer & Emerging
.model small
.stack 100h
include lifes.inc
.data 
;----------<game variables>----------	;AS
 
	canon1 db 'Cannon A','$'			;Cannon 1 Name
	canon2 db 'Cannon B','$'			;Cannon 2 Name
	Ahsan db 10 dup('$'),'$'				;Our Name
	score_string db 'Score:','$'		;Score Title
	life_Of_C1 dw 10					;Life of Cannon B
	life_Of_C2 dw 10					;Life of Cannon A
	life_of_robot dw 10					;Life of Robot
	scline co_ordinate <>				;Struct a line draw containing coordinates
	myscore dw 0						;Global Score Var
	firesnd db 6						;Fire Sound will elapse for 6 iter
	
;----------<Date and Time Variables>------;SA

	ldate db 'Date: ','$'
	syear dw ?
	smonth db ?
	sday db ?
	sslash db '/','$'
	
	ltime db 'Time: ','$'
	shour db ?
	sminute db ?
	ssecond db ?
	scolon db ':','$'
	duration db 'Duration: 35 sec','$'
;----------<coal man variables>----------;SA
	face db "    ( o.0 )","$"			;Coal Man Picture
	neck db "*||*  | |  ","$"
	hand db " \ \[-----]","$"
	tumy db "  \ | Saad|","$"
	tumi db "   \|Ahsan|","$"
	belt db "     ===== ","$"
	leg1 db "     |   | ","$"
	foot db "     D   D ","$"
	isfiring db 0						;Boolean to check only currently firing?
	robo db 0							;Robot current 1st character
	fireclm db ?						;Robot's fire column
	bClm db 0							;Column when Robot fired
	bmove db 19							;Robot's fire row
	mxc dw ?							;Mouse X Cor
	myc dw ?							;Mouse Y Cor
	moux db ?							;Mouse X Byte coord
	btn dw ?							;LMB
	filename db "Coalman.txt",0			;File Handling
	buffer db 5000 dup('$')
	nameenter db "Enter your beautiful name (Max 4 char): ","$"
	credits db "Game by Saad Ahmad and Ahsin Saddique","$"
	copyrights db "This product is protected by PAK and Int'l copyrights laws.","$"
	namee db 'Name: ','$'				;Title
	newlinee db ' ','$'					;Newline
	timee db 'Time: ','$'				;Time label
	scrp1 db 1							;Score Tens Part
	scrp2 db 8							;Score Ones Part
	scrp3 db 0
	scorep dw ?
;----------<cannons variables>----------;SA
	move1 db ?							;Cannon A current position (1st char)
	move2 db ?							;Cannon B current position (1st char)
	clr db ?							;color of cannon (deprecated)
	drop db 4							;Cannons A&B fire row
	firex db 3							;Cannon A fire Column
	firex2 db 57						;Cannon B fire Column
	
;----------<splash screen>----------	;AS
   levela db 0ah,0ah, "     #       ######  #       #   ######    #        ",0ah,0dh,"$"
	        levelb db "     #       #        #     #    #         #        ",0ah,0dh,"$"
	        levelc db "     #       #####     #   #     #####     #        ",0ah,0dh,"$"
	        leveld db "     #       #          # #      #         #        ",0ah,0dh,"$"
	        levele db "     ######  ######      #       ######    ######   ",0ah,0dh,"$"
			
;----------<defeat>----------			;AS
	lose11 db 0ah,0ah,"     #######    #    ###   ###  ######       #####   #   #  ######  ######  ",0ah,0dh,"$"
            lose12 db "     #     #   # #   #  # #  #  #           #     #  #   #  #       #    #  ",0ah,0dh,"$"
	        lose13 db "     #        #####  #   #   #  ######      #     #  #   #  ######  #    #  ",0ah,0dh,"$"
	        lose14 db "     #  ####  #   #  #       #  #           #     #  #   #  #       # # #   ",0ah,0dh,"$"
	        lose15 db "     #  #  #  #   #  #       #  #           #     #   # #   #       #    #  ",0ah,0dh,"$"
	        lose16 db "     #######  #   #  #       #  ######       #####     #    ######  #     # ",0ah,0dh,"$"
			
;----------<Level 1>----------			;AS
	level1a db 0ah,0ah,"                                 ####                       ",0ah,0dh,"$"
	        level1b db "                                ## ##                       ",0ah,0dh,"$"
	        level1c db "                               ##  ##                       ",0ah,0dh,"$"
	        level1d db "                                   ##                       ",0ah,0dh,"$"
	        level1e db "                                   ##                       ",0ah,0dh,"$"
	        level1f db "                                   ##                       ",0ah,0dh,"$"
	        level1g db "                                   ##                       ",0ah,0dh,"$"
	        level1h db "                               #########                    ",0ah,0dh,"$"
			
;----------<victory>----------			;SA
	win1 db 0ah,0ah,"       #   #   ###   #    #       #       #  #  #     #   ",0ah,0dh,"$"
			win2 db "        # #   #   #  #    #       #       #  #  ##    #   ",0ah,0dh,"$"
			win3 db "         #    #   #  #    #       #       #  #  # #   #   ",0ah,0dh,"$"
			win4 db "         #    #   #  #    #       #   #   #  #  #  #  #   ",0ah,0dh,"$"
			win5 db "         #    #   #   #  #         # # # #   #  #   # #   ",0ah,0dh,"$"
			win6 db "         #     ###     ##           #   #    #  #    ##   ",0ah,0dh,"$"
			
			
			
			
;----------<double digit IO>----------	;AS
enteredNumber dw 0						;Number to be displayed
digitCount dw 0							;Digit Count

.code
;assume cs:@code,ds:@data										;Associating CS and DS
mov ax,@data 							;Associating Data segment
mov ds,ax

main proc								;The Main Procedure
mov ah,0								;Clearing Ah
mov al,12h								;Setting MS-DOS/ Unix/ Windows 3.1 resolution to VGA (640 x 480 x 16 bit color)
int 10h									;Graphics Interrupt (VESA)

call cls								;Clear Screen procedure


call splash								;Splash Screen
call Print_leval1_String

;----------<Start>----------		;SA
mov ah,02ah
int 21h
mov syear,cx
mov smonth,dl
add smonth,63
mov sday,dh
add sday,40

mov ah,02ch
int 21h
mov shour,ch
add shour,36
mov sminute,cl
mov ssecond,dh

newline
newline
newline

mov dx,offset credits
mov ah,09h
int 21h
newline

mov dx,offset copyrights
mov ah,09h
int 21h


mov cx,01Fh								;Timer controlling the splash screen
mov dx,0FFFFh							;Number of microseconds to elapse
mov ah,86h
int 15h
;----------<Game>----------				;SA

mov ax,0
mov al,12h
int 10h
	
	newline
	newline
	newline
	newline
	newline
	newline
	newline
	mov dx,offset nameenter
	mov ah,09h
	int 21h

	mov dx,offset Ahsan
	mov ah,3fh
	int 21h
	
	
	
	mov ax,0							;Mouse Detect
	int 33h								;Mouse Int

	mov ax,1
	int 33h

	mov ax,4							;Setting Mouse at specific coord
	mov cx,319							;Row of Cursor
	mov dx,0							;Column of Cursor
	int 33h								;Mouse Interrupt

	mov robo,16							;Our Robot/CoalMan's X-Axis 1st char
	mov move1,0							;Cannon A X-Axis 1st char
	mov move2,54						;Cannon B X-Axis 1st Char
fps:									;Game Loop
	show_color							;BackGround Color
	backclr
	mov ax,3							;Current Mouse coord to vars
	int 33h								;Mouse Interrupt
	mov mxc,cx							;Moving X-Axis to Mouse X
	mov myc,dx							;Moving Y-Axis to Mouse Y
	mov btn,bx							;Moving LMB
	
	
	
	cmp isfiring,1						;Boolean for checking whether fire in progress or not
	je fireit							;If true, jump 'fireit'
	jmp nofire							;If false, jump 'nofire'

fireit:
	firesound
	mov al,fireclm						;Column where the coal man in currently
	add al,1							;Adding 1 so that fire escapes from hand
	mov bClm,al							
	mov dl,bClm							;Robot Fire X-Axis
	mov dh,bmove						;Robot Fire Y-Axis
	mov ah,02h							;Reach at that position
	int 10h
	mov al,221							;ASCII
	mov bl,159							;Color (deprecated) with added transparency
	mov ah,09h
	mov cx,1							;Times the character prints
	int 10h
	dec bmove							;Coal man's bullet y axis
	
nofire:									;Moving in --> direction Cannon A
	cmp move1,54						;If Cannon A reaches at right cornor
	jne run								;If not then run normally
	mov move1,0							;Changing starting positions of Cannon A
	mov move2,54						;& of Cannon B

run:
	cmp bmove,0							;If COALMAN Bullet Y-Axis is reached on full top
	je run1								;Jump Run1
	jmp run2							;Normal
run1:
	mov isfiring,0						;Boolean isfiring is falsed
	mov bmove,20						;Now initial bullet fire Coalman is set as 20 hand x-coord
run2:
;----------<Macros>----------			;AS
	print_score_title					;Score heading print
	score_update myscore			 	;Score of COAL Man updation
	Cannon_1_Str						;Cannon A name display
	Cannon_1_Life						;Cannon A score display
	Cannon_2_Str						;Cannon B Name
	Cannon_2_Life						;Cannon B score
	Robot_Name_Disp Ahsan 				;Our name show on stat list
	Update2_robot_life					;Coal man life updation
	
;----------<Cannon Detection>---------- ;AS
	cmp life_Of_C1,2					;checking for Cannon1 is destroyed
	je destroy1							;Cannon A dead, checking for B
	jb destroy1
	cannon move1,03						;Cannon A X-Coord and Color (deprecated)
	cannonfire firex,drop,142			;Cannon A Fire X-Axis,Y-Axis,Color
	jmp not_overA						;Cannon A Not Dead						
	
destroy1:
	cmp life_Of_C2,2					;checking for Cannon2 is destroyed alongwith A
	je gamewin							;GameWin splashed
	jb gamewin							;Cannon A&B both dead
										;Cannon B alive
not_overA:
	cmp life_Of_C2,2					;checking Cannon B is destroyed
	je destroy2							;Cannon B dead, checking for A
	jb destroy2	
	cannon move2,03						;Cannon B C-Coord and Color (deprecated)
	cannonfire firex2,drop,142			;Cannon B fire X-Axis,Y-Axis,color
	jmp not_overB						;B still alive
	
destroy2:								
	cmp life_Of_C1,2					;If B also dead
	je gamewin							;Splash Game Won
	jb gamewin
	
not_overB:
;----------<Cannon firing Controlling>----------;SA
	cmp drop,21							;If Cannon Y-Axis bullet reached coalmam
	je zerofirex						;Zero a.k.a take bullet back to cannon
	jmp next							;If not 'next'
	zerofirex:
	mov drop,4							;Bullet Y-Axis made 4 as their default value is
	mov dl,move1
	add dl,3
	mov firex,dl						;Bullet will fire from Cannon A (X-Axis)
	mov dl,move2
	add dl,3
	mov firex2,dl						;Bullet will fire from Cannon B (Y-Axis)
	next:
	
;----------<Mouse COAL MAN Control>----------;SA
	mov dl,byte ptr mxc					;Conversion from Word to Byte Mouse X-Coord
	mov moux,dl							;Putting that value to Mouse X Var
	
	cmp myc,400							;If Mouse is below gray-patti
	ja mousechalay						;Then Mouse Chalay ga ;)
	jmp mnothing						;Else jump to nothing
mousechalay:
	
	cmp btn,1
	je dhuzdhuz
	jmp mchecks
	
dhuzdhuz:
	mov isfiring,1
	mov bl,robo
	mov fireclm,bl
	
mchecks:	
	cmp mxc,0							;If mouse is more than 0 in X Coord
	ja mousemove						;Mouse Move
	jmp mnothing						;Else jump to nothing

	cmp mxc,480							;Also If mouse is less than 480 in X Coord
	jb mousemove						;Mouse Move
	jmp mnothing						;Else jump to nothing
mousemove:

	cmp mxc,240							;Between LR
	jb mleft							;Less than -> Left
	ja mright							;Greater than -> Right
	
mleft:
	jmp left							;Robot Left Move
	jmp mnothing
	
mright:
	jmp right							;Robot Right Move
	mnothing:
	
;----------<KeyBoard COAL MAN Control>----------;SA	
	mov ah,01							;Interrupt-less key entry
	int 16h								;Interrupt for scan codes
	
	cmp ah,48h							;Up-Arrow key
	je up
	cmp ah,4Bh							;Left-Arrow key
	je left
	cmp ah,4Dh							;Right-Arrow key
	je right							
	cmp ah,50h							;Down-Arrow key
	je down						;Pausegame
	jmp move							;Its behavior is same as no key pressed

	
;----------<KeyBoard Key's Action>----------;AS		
left:
	movesound
    mov bl,robo
	sub robo,3							;Towards left
	cmp robo,1
	jb not_chang						;Don't change Robot X-Axis
	je not_chang
	mov ah,0ch							;Clear keyboard buffer
	int 21h
	jmp move
	
	not_chang:
	mov robo,bl							;Clear keyboard buffer
	mov ah,0ch
	int 21h
	jmp move
	
right:
	movesound
    mov bl,robo
	add robo,3							;Towards right
	cmp robo,52
	ja not_chang2						;Don't change Robot X-Axis
	je not_chang2
	mov ah,0ch							;Clear keyboard buffer
	int 21h
	jmp move
	
	not_chang2:
	mov robo,bl
	mov ah,0ch							;Clear keyboard buffer
	int 21h
	jmp move

up:  									;To fire with upper key
	firesound
	mov isfiring,1
	mov bl,robo
	mov fireclm,bl
	mov ah,0ch
	int 21h
	jmp move
down:
	
	mov ah,00
	int 16h
	mov ah,0ch
	int 16h
	jmp pase
pase:
	mov ah,00
	int 16h
	cmp ah,50h
	je resumegame
	jmp down
resumegame:

move:
	coalmam robo,142					;Coal Man X-C-Coord, Color
	backclr
	mov cx, 01h
	mov dx, 4825h						;Game Timer to limit FPS
	mov ah, 86h
	int 15h
	backclr
	inc drop
;----------<Collision Detection Cannon B>----------;AS	
	mov cx,0
	mov ax,0
	mov bx,0
	mov cl,bmove    ;bullet row
	cmp bmove,3
	jb real
	;jl real
    jmp notdetec	
	real:
	mov cl,move1    
	add cl,6
	mov bl,move1   ; col of bullet  
	
		   mov al,bClm
		   cmp al,bl
		   je se
		   jmp se2
		   se2:
		   cmp al,bl
		   ja se
		   jmp notdetec
		   
		   se:
		   cmp al,cl
		   jb sne
		   je sne
		   jmp notdetec
		   
		   sne:
		   jmp detect1	
	detect1:
	cmp life_Of_C1,2
	je not_dec1
	jb not_dec1
	
	dec life_Of_C1
	not_dec1:
	mov ax,myscore
	add ax,10
	mov myscore,ax
	jmp detect_cannon2
	notdetec:
		
	detect_cannon2:
;----------<Collision Cannon A>----------;AS	
	mov cx,0
	mov ax,0
	mov bx,0
	mov cl,bmove    ;bullet row
	cmp bmove,3
	jb real2
    jmp notdetec2	
	real2:
	mov cl,move2    
	add cl,6
	mov bl,move2   ; col of bullet  
	
		   mov al,bClm
		   cmp al,bl
		   je m_se
		   jmp SS2
		   SS2:
		   cmp al,bl
		   ja m_se
		   jmp notdetec2
		   
		   m_se:
		   cmp al,cl
		   jb sne2
		   je sne2
		   jmp notdetec2
		   
		   sne2:
		   jmp detect2
	
	detect2:
	cmp life_Of_C2,2
	je not_dec2
	jb not_dec2
	
	dec life_Of_C2
	not_dec2:
	mov ax,myscore
	add ax,10				; updating score
	mov myscore,ax
	jmp continue
	
	
	
	;detect1ed2:
	
	notdetec2:
	continue:
;----------<COAL MAN Collision detection>----------;SA
	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0
	cmp drop,20					;drop =  bullet is in range of coal w.r.t y axis
	jae maarnaykikoshish
	jmp naa_kaam
maarnaykikoshish:
	mov bl,robo					;Coal mam body ending x-coord
	add bl,11
	mov al,robo					;Coal man body starting x-coord
	
		mov dl,firex			;firex = bullet 1 X-Coord resp.
		cmp dl,al
		jae sahi1
		jmp naa_kaam
	sahi1:
		cmp dl,bl
		jbe lifekam
		jmp naa_kaam
		
		mov dl,firex2			;fire2x = bullet 2 X-Coord resp.
		cmp dl,al
		jae sahi2
		jmp naa_kaam
	sahi2:
		cmp dl,bl
		jbe lifekam
		jmp naa_kaam
		
	lifekam:
		mov ax,life_of_robot
		sub ax,2
		mov life_of_robot,ax
naa_kaam:	
	inc move1					;Move Cannon A towards right
	dec move2					;Move Cannon B towards left
	endsound
	
;----------<ScoreBoard>----------;AS
	mov ax,myscore
	mov enteredNumber,ax
	;savedata
	cmp life_of_robot,0
	je gameOver
	jb gameOver
	jmp fps						;Main Game Loop	
	
	gameOver:					;Jump Label for game over
	savedata
	call Game_over				;call gameover procedure
	jmp exit					;Exit/ Return to MS DOS
	youwin:			;Jump Label for game win
	savedata
	call gamewin				;call gameWin procedure

exit:							;Return to MS-DOS
mov ah,4ch
int 21h

main endp



;----------<Clear Screen Procedure>----------;AS
cls proc
	mov     ax,0600h    	; scroll window up
	mov     cx,0        	; upper left corner (0,0)
	mov     dx,1e4Fh    	; lower right corner (24,79)
	mov     bh,7        	; normal attribute
	int     10h         	; call BIOS
	mov     ah,2        	; locate cursor at 0,0
	mov     bh,0        	; video page 0
	mov     dx,0			; row 0, column 0
	int     10h
ret
cls endp

;----------<String display procedure>----------;AS
stringprint proc
mov ah,09
int 21h
ret
stringprint endp

;----------<Game Win>----------;SA
gamewin proc
	mov ah,0
	mov al,12h
	int 10h
	mov dx,offset win1
	call stringprint
	mov dx,offset win2
	call stringprint
	mov dx,offset win3
	call stringprint
	mov dx,offset win4
	call stringprint
	mov dx,offset win5
	call stringprint
	mov dx,offset win6
	call stringprint
	ret
gamewin endp

;----------<Splash Screen>----------;AS
splash proc
	mov ah,0
	mov al,12h
	int 10h
	mov dx,offset levela
	call stringprint
		mov dx,offset levelb
	call stringprint
		mov dx,offset levelc
	call stringprint
		mov dx,offset leveld
	call stringprint
		mov dx,offset levele
	call stringprint
ret
splash endp

;----------<Game Lost Screen>----------;AS
Game_over proc
	mov ah,0
	mov al,12h
	int 10h
		mov dx,offset lose11
	call stringprint
		mov dx,offset lose12
	call stringprint
		mov dx,offset lose13
	call stringprint
		mov dx,offset lose14
	call stringprint
		mov dx,offset lose15
	call stringprint
		mov dx,offset lose16
	call stringprint
ret
Game_over endp 


;------------------------ <Print Leval 1 String >--****--- ;AS
Print_leval1_String proc
		mov dx,offset level1a
	call stringprint
		mov dx,offset level1b
	call stringprint
		mov dx,offset level1c
	call stringprint
		mov dx,offset level1d
	call stringprint
		mov dx,offset level1e
	call stringprint
		mov dx,offset level1f
	call stringprint
	mov dx,offset level1g
	call stringprint
	mov dx,offset level1h
	call stringprint
ret
Print_leval1_String endp 
;------------------------ <Print Leval 1 String >--****--- 

;-----------------<Score saving event>------ ;SA
scoresaver proc
	mov ax,0
	mov ax, 128
BreakIta:
	mov dx,0      ;AX= Quotient, DX= Remainder
	mov bx,10
	div bx   
	push dx      ;Dx: Remainder   
	inc digitCount
	cmp ax,0
	je displayIta 
	jmp BreakIta

 
displayIta: 
	pop bx
	add bx,48
	mov scorep,bx
	mov bl,byte ptr scorep
	mov scrp1,bl
	
	pop bx
	add bx,48
	mov scorep,bx
	mov bl,byte ptr scorep
	mov scrp2,bl
	
	pop bx
	add bx,48
	mov scorep,bx
	mov bl,byte ptr scorep
	mov scrp3,bl

	exitdca:
ret

scoresaver endp			

end