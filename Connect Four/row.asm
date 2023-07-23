IDEAL
MODEL small
STACK 100h
DATASEG
x dw 20h
y dw 20h

red db 4 
white db 0Fh

a dw 20h
b dw 20h

c dw 20h
d dw 40h

e dw 20h
f dw 60h

q dw 20h
r dw 80h		

g dw 20h
h dw 0A0h

i dw 20h
j dw 20h

k dw 40h
l dw 20h

m dw 60h
n dw 20h

o dw 0A0h
p dw 20h

s dw 80h
t dw 20h
	
u dw 20h
v dw 20h
w dw 20h

inst1 db 'Press: 1,2,3 or 4 to drop a disc.',13,10,'$'
inst2 db 'To win the game align 4 discs.',13,10,'$'
inst3 db 'Escape to quit.',13,10,'$'

player1discstring db 'Player 1 Disc:',13,10,'$'
player1disccolor db 0Eh
p1x dw 127h
p1y dw 24h

player2discstring db 'Player 2 Disc:',13,10,'$'
player2disccolor db 1h
p2x dw 127h
p2y dw 39h

FirstColumnArray db 4 dup(0)
SecondColumnArray db 4 dup(0)
ThirdColumnArray db 4 dup(0)
FourthColumnArray db 4 dup(0)

Player1Drawx dw 0h  
Player1Drawy dw 0h

Player2Drawx dw 0h
Player2Drawy dw 0h

Player1Winner db 'Player 1 Won!',13,10,'$'
Player2Winner db 'Player 2 Won!',13,10,'$' 
 
CODESEG
start:
mov ax, @data
mov ds, ax
	
; Graphic mode
mov ax, 13h
int 10h

RedDotLoop:
	mov bh,0h
	mov cx,[x]
	mov dx,[y]
	mov al,[red]
	mov ah,0ch
	int 10h
	inc [x]
	cmp cx, 0A0h
	jl RedDotLoop
		
Square:
	mov bh, 0h
	inc [y]
	mov [x], 20h
	cmp dx, 0A0h
	jl RedDotLoop
	
WhiteHorizontalDotLoop1:
	mov bh,0h
	mov cx,[a]
	mov dx,[b]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [a]
	cmp cx, 0A0h
	jl WhiteHorizontalDotLoop1

WhiteHorizontalDotLoop2:
	mov bh,0h
	mov cx,[c]
	mov dx,[d]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [c]
	cmp cx, 0A0h
	jl WhiteHorizontalDotLoop2
	
WhiteHorizontalDotLoop3:
	mov bh,0h
	mov cx,[e]
	mov dx,[f]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [e]
	cmp cx, 0A0h
	jl WhiteHorizontalDotLoop3
	
WhiteHorizontalDotLoop4:
	mov bh,0h
	mov cx,[g]
	mov dx,[h]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [g]
	cmp cx, 0A0h
	jl WhiteHorizontalDotLoop4
	
WhiteHorizontalDotLoop5:
	mov bh,0h
	mov cx,[q]
	mov dx,[r]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [q]
	cmp cx, 0A0h
	jl WhiteHorizontalDotLoop5

WhiteVerticalDotLoop1:
	mov bh,0h
	mov cx,[i]
	mov dx,[j]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [j]
	cmp dx, 0A0h
	jl WhiteVerticalDotLoop1

WhiteVerticalDotLoop2:
	mov bh,0h
	mov cx,[k]
	mov dx,[l]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [l]
	cmp dx, 0A0h
	jl WhiteVerticalDotLoop2

WhiteVerticalDotLoop3:
	mov bh,0h
	mov cx,[m]
	mov dx,[n]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [n]
	cmp dx, 0A0h
	jl WhiteVerticalDotLoop3
	
WhiteVerticalDotLoop4:
	mov bh,0h
	mov cx,[o]
	mov dx,[p]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [p]
	cmp dx, 0A0h
	jl WhiteVerticalDotLoop4

WhiteVerticalDotLoop5:
	mov bh,0h
	mov cx,[s]
	mov dx,[t]
	mov al,[white]
	mov ah,0ch
	int 10h
	inc [t]
	cmp dx, 0A0h
	jl WhiteVerticalDotLoop5
	
Write1Loop:
	mov dl, ''
	mov ah,2
	int 21h
	inc [u]
	cmp [u], 75h
	jl Write1Loop
	mov dl, '1'
	mov ah, 2
	int 21h

Write2Loop:
	mov dl, ''
	mov ah,2
	int 21h
	inc [v]
	cmp [v], 24h
	jl Write2Loop
	mov dl, '2'
	mov ah, 2	
	int 21h	
	
Write3Loop:
	mov dl, ''
	mov ah,2
	int 21h
	inc [w]
	cmp [w], 23h
	jl Write3Loop
	mov dl, '3'
	mov ah, 2	
	int 21h	
	
Write4Loop:
	mov dl, ''
	mov ah,2
	int 21h
	inc [w]
	cmp [w], 26h
	jl Write4Loop
	mov dl, '4'
	mov ah, 2	
	int 21h
	
Instructions1:
	mov dl, 0   
	mov dh, 21    
	mov ah, 2     
	mov bh, 0     
	int 10h       
	lea dx, [inst1]
	mov dx, offset inst1
	mov ah, 9
    int 21h
  
Instructions2:
	mov dl, 0 
	mov dh, 23    
	mov ah, 2     
	mov bh, 0     
	int 10h       
	lea dx, [inst2]
	mov dx, offset inst2
	mov ah, 9
	int 21h

Instructions3:
	mov dl, 22
	mov dh, 18
	mov ah, 2
	mov bh, 0
	int 10h
	lea dx, [inst3]
	mov dx, offset inst3
	mov ah, 9
	int 21h
	
PlayerOneDisc:
	mov es, ax
	mov ah, 13h
	mov bl, [player1disccolor]
	mov dl, 22   
	mov dh, 5  
	mov ah, 2     
	mov bh, 0     
	int 10h
	lea dx, [player1discstring]
	mov dx, offset player1discstring
	mov ah, 9
	int 21h
	
PlayerTwoDisc:
	mov dl, 22   
	mov dh, 8  
	mov ah, 2     
	mov bh, 0     
	int 10h       
	lea dx, [player2discstring]
	mov dx, offset player2discstring
	mov ah, 9
	int 21h
	
Player1Disc:
	mov bh,0h
	mov cx,[p1x]
	mov dx,[p1y]
	mov al,[player1disccolor]
	mov ah, 0ch
	int 10h
	inc [p1x]
	cmp cx, 135h
	jl Player1Disc
	
Player1Square:
	mov bh, 0h
	inc [p1y]
	mov [p1x], 127h
	cmp dx, 32h
	jl Player1Disc
	
Player2Disc:
	mov bh,0h
	mov cx,[p2x]
	mov dx,[p2y]
	mov al,[player2disccolor]
	mov ah,0ch
	int 10h
	inc [p2x]
	cmp cx, 135h
	jl Player2Disc
	
Player2Square:
	mov bh, 0h
	inc [p2y]
	mov [p2x], 127h
	cmp dx , 47h
	jl Player2Disc

proc CheckPlayer1Number
	mov ah, 7
	int 21h
	cmp al, 31h
	je CheckColumn1
	cmp al, 32h
	je MoveToCheckColumn2
	cmp al, 33h
	je MoveToCheckColumn3
	cmp al, 34h
	je MoveToCheckColumn4
	cmp al, 1Bh
	je Escape1
	jmp CheckPlayer1Number
endp CheckPlayer1Number

Escape1:
	jmp exit

proc CheckColumn1
	cmp [FirstColumnArray], 0
	je ChangeColumn1Number1 
	cmp [FirstColumnArray + 1], 0
	je ChangeColumn1Number2 
	cmp [FirstColumnArray + 2], 0
	je ChangeColumn1Number3 
	cmp [FirstColumnArray + 3], 0
	je ChangeColumn1Number4
	jmp CheckPlayer1Number
endp CheckColumn1

proc ChangeColumn1Number1
	inc [FirstColumnArray]
	mov [Player1Drawx], 25h
	mov [Player1Drawy], 85h
	jmp DrawPlayer1Disc
endp ChangeColumn1Number1

proc ChangeColumn1Number2
	inc [FirstColumnArray + 1]
	mov [Player1Drawx], 25h
	mov [Player1Drawy], 67h
	jmp DrawPlayer1Disc
endp ChangeColumn1Number2

proc ChangeColumn1Number3
	inc [FirstColumnArray + 2]
	mov [Player1Drawx], 25h
	mov [Player1Drawy], 47h
	jmp DrawPlayer1Disc
endp ChangeColumn1Number3

proc ChangeColumn1Number4
	inc [FirstColumnArray + 3]
	mov [Player1Drawx], 25h
	mov [Player1Drawy], 27h
	jmp DrawPlayer1Disc
endp ChangeColumn1Number4

proc MoveToCheckColumn2
	jmp CheckColumn2
endp MoveToCheckColumn2

proc MoveToCheckColumn3
	jmp CheckColumn3
endp MoveToCheckColumn3

proc MoveToCheckColumn4
	jmp CheckColumn4
endp MoveToCheckColumn4

proc CheckColumn2
	cmp [SecondColumnArray], 0
	je ChangeColumn2Number1 
	cmp [SecondColumnArray + 1], 0
	je ChangeColumn2Number2 
	cmp [SecondColumnArray + 2], 0
	je ChangeColumn2Number3 
	cmp [SecondColumnArray + 3], 0
	je ChangeColumn2Number4
	jmp CheckPlayer1Number
endp CheckColumn2

proc ChangeColumn2Number1
	inc [SecondColumnArray]
	mov [Player1Drawx], 45h
	mov [Player1Drawy], 85h
	jmp DrawPlayer1Disc
endp ChangeColumn2Number1

proc ChangeColumn2Number2
	inc [SecondColumnArray + 1]
	mov [Player1Drawx], 45h
	mov [Player1Drawy], 67h
	jmp DrawPlayer1Disc
endp ChangeColumn2Number2

proc ChangeColumn2Number3
	inc [SecondColumnArray + 2]
	mov [Player1Drawx], 45h
	mov [Player1Drawy], 47h
	jmp DrawPlayer1Disc
endp ChangeColumn2Number3

proc ChangeColumn2Number4
	inc [SecondColumnArray + 3]
	mov [Player1Drawx], 45h
	mov [Player1Drawy], 27h
	jmp DrawPlayer1Disc
endp ChangeColumn2Number4

proc CheckColumn3
	cmp [ThirdColumnArray], 0
	je ChangeColumn3Number1 
	cmp [ThirdColumnArray + 1], 0
	je ChangeColumn3Number2 
	cmp [ThirdColumnArray + 2], 0
	je ChangeColumn3Number3 
	cmp [ThirdColumnArray + 3], 0
	je ChangeColumn3Number4
	jmp CheckPlayer1Number
endp CheckColumn3

proc ChangeColumn3Number1
	inc [ThirdColumnArray]
	mov [Player1Drawx], 65h
	mov [Player1Drawy], 85h
	jmp DrawPlayer1Disc
endp ChangeColumn3Number1

proc ChangeColumn3Number2
	inc [ThirdColumnArray + 1]
	mov [Player1Drawx], 65h
	mov [Player1Drawy], 67h
	jmp DrawPlayer1Disc
endp ChangeColumn3Number2

proc ChangeColumn3Number3
	inc [ThirdColumnArray + 2]
	mov [Player1Drawx], 65h
	mov [Player1Drawy], 47h
	jmp DrawPlayer1Disc
endp ChangeColumn3Number3

proc ChangeColumn3Number4
	inc [ThirdColumnArray + 3]
	mov [Player1Drawx], 65h
	mov [Player1Drawy], 27h
	jmp DrawPlayer1Disc
endp ChangeColumn3Number4

proc CheckColumn4
	cmp [FourthColumnArray], 0
	je ChangeColumn4Number1 
	cmp [FourthColumnArray + 1], 0
	je ChangeColumn4Number2 
	cmp [FourthColumnArray + 2], 0
	je ChangeColumn4Number3 
	cmp [FourthColumnArray + 3], 0
	je ChangeColumn4Number4
	jmp CheckPlayer1Number
endp CheckColumn4

proc ChangeColumn4Number1
	inc [FourthColumnArray]
	mov [Player1Drawx], 85h
	mov [Player1Drawy], 85h
	jmp DrawPlayer1Disc
endp ChangeColumn4Number1

proc ChangeColumn4Number2
	inc [FourthColumnArray + 1]
	mov [Player1Drawx], 85h
	mov [Player1Drawy], 67h
	jmp DrawPlayer1Disc
endp ChangeColumn4Number2

proc ChangeColumn4Number3
	inc [FourthColumnArray + 2]
	mov [Player1Drawx], 85h
	mov [Player1Drawy], 47h
	jmp DrawPlayer1Disc
endp ChangeColumn4Number3

proc ChangeColumn4Number4
	inc [FourthColumnArray + 3]
	mov [Player1Drawx], 85h
	mov [Player1Drawy], 27h
	jmp DrawPlayer1Disc
endp ChangeColumn4Number4
	
DrawPlayer1Disc:
	mov dx, [Player1Drawy]
	mov di, 14h

DrawPlayer1DiscyLoop:
	mov cx, [Player1Drawx]
	mov si, 14h
	
DrawPlayer1DiscxLoop:
	push cx
	push dx
	push si 
	push di
	mov bh, 0h
	mov al, [player1disccolor]
	mov ah, 0ch
	int 10h
	pop di
	pop si
	pop dx
	pop cx
	inc cx
	dec si
	jne DrawPlayer1DiscxLoop
	inc dx 
	dec di
	jne DrawPlayer1DiscyLoop
	
proc CheckIfPlayer1Won
	Row1:
	cmp [FirstColumnArray], 1
	je Continue1Row1
	jmp Row2	
	Continue1Row1:
	cmp [SecondColumnArray], 1
	je Continue2Row1
	jmp Row2	
	Continue2Row1:
	cmp [ThirdColumnArray], 1
	je Continue3Row1
	jmp Row2
	Continue3Row1:
	cmp [FourthColumnArray], 1
	je Player1WinnerAnnounce1
	jmp Row2
	
	Row2:
	cmp [FirstColumnArray + 1], 1
	je Continue1Row2
	jmp Row3
	Continue1Row2:
	cmp [SecondColumnArray + 1], 1
	je Continue2Row2
	jmp Row3
	Continue2Row2:
	cmp [ThirdColumnArray + 1], 1
	je Continue3Row2
	jmp Row3
	Continue3Row2:
	cmp [FourthColumnArray + 1], 1
	je Player1WinnerAnnounce1
	jmp Row3
	
	Row3:
	cmp [FirstColumnArray + 2], 1
	je Continue1Row3
	jmp Row4
	Continue1Row3:
	cmp [SecondColumnArray + 2], 1
	je Continue2Row3
	jmp Row4
	Continue2Row3:
	cmp [ThirdColumnArray + 2], 1
	je Continue3Row3
	jmp Row4
	Continue3Row3:
	cmp [FourthColumnArray + 2], 1
	je Player1WinnerAnnounce1
	jmp Row4
	
	Row4:
	cmp [FirstColumnArray + 3], 1
	je Continue1Row4
	jmp Column1
	Continue1Row4:
	cmp [SecondColumnArray + 3], 1
	je Continue2Row4
	jmp Column1
	Continue2Row4:
	cmp [ThirdColumnArray + 3], 1
	je Continue3Row4
	jmp Column1
	Continue3Row4:
	cmp [FourthColumnArray + 3], 1
	je Player1WinnerAnnounce1
	jmp Column1
	
	Player1WinnerAnnounce1:
	mov dl, 22
	mov dh, 12
	mov ah, 2
	mov bh, 0
	int 10h
	lea dx, [Player1Winner]
	mov dx, offset Player1Winner
	mov ah, 9
	int 21h	
	jmp exit
	
	Column1:
	cmp [FirstColumnArray], 1
	je Continue1Column1
	jmp Column2
	Continue1Column1:
	cmp [FirstColumnArray + 1], 1
	je Continue2Column1
	jmp Column2
	Continue2Column1:
	cmp [FirstColumnArray + 2], 1
	je Continue3Column1
	jmp Column2
	Continue3Column1:
	cmp [FirstColumnArray + 3], 1
	je Player1WinnerAnnounce2
	jmp Column2
	
	Column2:	
	cmp [SecondColumnArray], 1
	je Continue1Column2
	jmp Column3
	Continue1Column2:
	cmp [SecondColumnArray + 1], 1
	je Continue2Column2
	jmp Column3
	Continue2Column2:
	cmp [SecondColumnArray + 2], 1
	je Continue3Column2
	jmp Column3
	Continue3Column2:
	cmp [SecondColumnArray + 3], 1
	je Player1WinnerAnnounce2
	jmp Column3
	
	Column3:
	cmp [ThirdColumnArray], 1
	je Continue1Column3
	jmp Column4
	Continue1Column3:
	cmp [ThirdColumnArray + 1], 1
	je Continue2Column3
	jmp Column4
	Continue2Column3:
	cmp [ThirdColumnArray + 2], 1
	je Continue3Column3
	jmp Column4
	Continue3Column3:
	cmp [ThirdColumnArray + 3], 1
	je Player1WinnerAnnounce2
	jmp Column4
	
	Column4:
	cmp [FourthColumnArray], 1
	je Continue1Column4
	jmp DiagnolLine1
	Continue1Column4:
	cmp [FourthColumnArray + 1], 1
	je Continue2Column4
	jmp DiagnolLine1
	Continue2Column4:
	cmp [FourthColumnArray + 2], 1
	je Continue3Column4
	jmp DiagnolLine1
	Continue3Column4:
	cmp [FourthColumnArray + 3], 1
	je Player1WinnerAnnounce2
	jmp DiagnolLine1
	
	Player1WinnerAnnounce2:
	mov dl, 22
	mov dh, 12
	mov ah, 2
	mov bh, 0
	int 10h
	lea dx, [Player1Winner]
	mov dx, offset Player1Winner
	mov ah, 9
	int 21h	
	jmp exit	
	
	DiagnolLine1:
	cmp [FirstColumnArray], 1
	je Continue1DiagnolLine1
	jmp DiagnolLine2
	Continue1DiagnolLine1:
	cmp [SecondColumnArray + 1], 1
	je Continue2DiagnolLine1
	jmp DiagnolLine2
	Continue2DiagnolLine1:
	cmp [ThirdColumnArray + 2], 1
	je Continue3DiagnolLine1
	jmp DiagnolLine2
	Continue3DiagnolLine1:
	cmp [FourthColumnArray + 3], 1
	je Player1WinnerAnnounce3
	jmp DiagnolLine2
	
	DiagnolLine2:
	cmp [FourthColumnArray], 1
	je Continue1DiagnolLine2
	jmp CheckPlayer2Number
	Continue1DiagnolLine2:
	cmp [ThirdColumnArray + 1], 1
	je Continue2DiagnolLine2
	jmp CheckPlayer2Number
	Continue2DiagnolLine2:
	cmp [SecondColumnArray + 2], 1
	je Continue3DiagnolLine2
	jmp CheckPlayer2Number
	Continue3DiagnolLine2:
	cmp [FirstColumnArray + 3], 1
	je Player1WinnerAnnounce3
	jmp CheckPlayer2Number 	
		
	Player1WinnerAnnounce3:
	mov dl, 22
	mov dh, 12
	mov ah, 2
	mov bh, 0
	int 10h
	lea dx, [Player1Winner]
	mov dx, offset Player1Winner
	mov ah, 9
	int 21h	
	jmp exit	
endp CheckIfPlayer1Won
	
proc CheckPlayer2Number
	mov ah, 7
	int 21h
	cmp al, 31h
	je Player2CheckColumn1
	cmp al, 32h	
	je MoveToCheck2Column2
	cmp al, 33h
	je MoveToCheck2Column3
	cmp al, 34h
	je MoveToCheck2Column4
	cmp al, 1Bh
	je Escape2
	jmp CheckPlayer2Number
endp CheckPlayer2Number

Escape2:
	jmp exit

proc Player2CheckColumn1
	cmp [FirstColumnArray], 0
	je Change2Column1Number1 
	cmp [FirstColumnArray + 1], 0
	je Change2Column1Number2 
	cmp [FirstColumnArray + 2], 0
	je Change2Column1Number3 
	cmp [FirstColumnArray + 3], 0
	je Change2Column1Number4
	jmp CheckPlayer2Number
endp Player2CheckColumn1

proc Change2Column1Number1
	add [FirstColumnArray], 2
	mov [Player2Drawx], 25h
	mov [Player2Drawy], 85h
	jmp DrawPlayer2Disc
endp Change2Column1Number1

proc Change2Column1Number2
	add [FirstColumnArray + 1], 2
	mov [Player2Drawx], 25h
	mov [Player2Drawy], 67h
	jmp DrawPlayer2Disc
endp Change2Column1Number2

proc Change2Column1Number3
	add [FirstColumnArray + 2], 2
	mov [Player2Drawx], 25h
	mov [Player2Drawy], 47h
	jmp DrawPlayer2Disc
endp Change2Column1Number3

proc Change2Column1Number4
	add [FirstColumnArray + 3], 2
	mov [Player2Drawx], 25h
	mov [Player2Drawy], 27h
	jmp DrawPlayer2Disc
endp Change2Column1Number4

proc MoveToCheck2Column2
	jmp Player2CheckColumn2
endp MoveToCheck2Column2

proc MoveToCheck2Column3
	jmp Player2CheckColumn3
endp MoveToCheck2Column3

proc MoveToCheck2Column4
	jmp Player2CheckColumn4
endp MoveToCheck2Column4	

proc Player2CheckColumn2
	cmp [SecondColumnArray], 0
	je Change2Column2Number1
	cmp [SecondColumnArray + 1], 0
	je Change2Column2Number2
	cmp [SecondColumnArray + 2], 0
	je Change2Column2Number3
	cmp [SecondColumnArray + 3], 0
	je Change2Column2Number4
	jmp CheckPlayer2Number
endp Player2CheckColumn2

proc Change2Column2Number1
	add [SecondColumnArray], 2
	mov [Player2Drawx], 45h
	mov [Player2Drawy], 85h
	jmp DrawPlayer2Disc
endp Change2Column2Number1

proc Change2Column2Number2
	add [SecondColumnArray + 1], 2
	mov [Player2Drawx], 45h
	mov [Player2Drawy], 67h
	jmp DrawPlayer2Disc
endp Change2Column2Number2

proc Change2Column2Number3
	add [SecondColumnArray + 2], 2
	mov [Player2Drawx], 45h
	mov [Player2Drawy], 47h
	jmp DrawPlayer2Disc
endp Change2Column2Number3

proc Change2Column2Number4
	add [SecondColumnArray + 3], 2
	mov [Player2Drawx], 45h
	mov [Player2Drawy], 27h
	jmp DrawPlayer2Disc
endp Change2Column2Number4

proc Player2CheckColumn3
	cmp [ThirdColumnArray], 0
	je Change2Column3Number1
	cmp [ThirdColumnArray + 1], 0
	je Change2Column3Number2
	cmp [ThirdColumnArray + 2], 0
	je Change2Column3Number3
	cmp [ThirdColumnArray + 3], 0
	je Change2Column3Number4
	jmp CheckPlayer2Number
endp Player2CheckColumn3

proc Change2Column3Number1
	add [ThirdColumnArray], 2
	mov [Player2Drawx], 65h
	mov [Player2Drawy], 85h
	jmp DrawPlayer2Disc
endp Change2Column3Number1

proc Change2Column3Number2
	add [ThirdColumnArray + 1], 2
	mov [Player2Drawx], 65h
	mov [Player2Drawy], 67h
	jmp DrawPlayer2Disc
endp Change2Column3Number2

proc Change2Column3Number3
	add [ThirdColumnArray + 2], 2
	mov [Player2Drawx], 65h
	mov [Player2Drawy], 47h
	jmp DrawPlayer2Disc
endp Change2Column3Number3

proc Change2Column3Number4
	add [ThirdColumnArray + 3], 2
	mov [Player2Drawx], 65h
	mov [Player2Drawy], 27h
	jmp DrawPlayer2Disc
endp Change2Column3Number4

proc Player2CheckColumn4
	cmp [FourthColumnArray], 0
	je Change2Column4Number1
	cmp [FourthColumnArray + 1], 0
	je Change2Column4Number2
	cmp [FourthColumnArray + 2], 0
	je Change2Column4Number3
	cmp [FourthColumnArray + 3], 0
	je Change2Column4Number4
	jmp CheckPlayer2Number	
endp Player2CheckColumn4

proc Change2Column4Number1
	add [FourthColumnArray], 2
	mov [Player2Drawx], 85h
	mov [Player2Drawy], 85h
	jmp DrawPlayer2Disc
endp Change2Column4Number1

proc Change2Column4Number2
	add [FourthColumnArray + 1], 2
	mov [Player2Drawx], 85h
	mov [Player2Drawy], 67h
	jmp DrawPlayer2Disc
endp Change2Column4Number2

proc Change2Column4Number3
	add [FourthColumnArray + 2], 2
	mov [Player2Drawx], 85h
	mov [Player2Drawy], 47h
	jmp DrawPlayer2Disc
endp Change2Column4Number3

proc Change2Column4Number4
	add [FourthColumnArray + 3], 2
	mov [Player2Drawx], 85h
	mov [Player2Drawy], 27h
	jmp DrawPlayer2Disc
endp Change2Column4Number4

DrawPlayer2Disc:
	mov dx, [Player2Drawy]
	mov di, 14h

DrawPlayer2DiscyLoop:
	mov cx, [Player2Drawx]
	mov si, 14h
	
DrawPlayer2DiscxLoop:
	push cx
	push dx
	push si 
	push di
	mov bh, 0h
	mov al, [player2disccolor]
	mov ah, 0ch
	int 10h
	pop di
	pop si
	pop dx
	pop cx
	inc cx
	dec si
	jne DrawPlayer2DiscxLoop
	inc dx 
	dec di
	jne DrawPlayer2DiscyLoop

proc CheckIfPlayer2Won
	Row1T:
	cmp [FirstColumnArray], 2
	je Continue1Row1T
	jmp Row2T
	Continue1Row1T:
	cmp [SecondColumnArray], 2
	je Continue2Row1T
	jmp Row2T
	Continue2Row1T:
	cmp [ThirdColumnArray], 2
	je Continue3Row1T
	jmp Row2T
	Continue3Row1T:
	cmp [FourthColumnArray], 2
	je Player2WinnerAnnounce1
	jmp Row2T
	
	Row2T:
	cmp [FirstColumnArray + 1], 2
	je Continue1Row2T
	jmp Row3T
	Continue1Row2T:
	cmp [SecondColumnArray + 1], 2
	je Continue2Row2T
	jmp Row3T
	Continue2Row2T:
	cmp [ThirdColumnArray + 1], 2
	je Continue3Row2T
	jmp Row3T
	Continue3Row2T:
	cmp [FourthColumnArray + 1], 2
	je Player2WinnerAnnounce1
	jmp Row3T
	
	Row3T:
	cmp [FirstColumnArray + 2], 2
	je Continue1Row3T
	jmp Row4T
	Continue1Row3T:
	cmp [SecondColumnArray + 2], 2
	je Continue2Row3T
	jmp Row4T
	Continue2Row3T:
	cmp [ThirdColumnArray + 2], 2
	je Continue3Row3T
	jmp Row4T
	Continue3Row3T:
	cmp [FourthColumnArray + 2], 2
	je Player2WinnerAnnounce1
	jmp Row4T
	
	Row4T:
	cmp [FirstColumnArray + 3], 2
	je Continue1Row4T
	jmp Column1T
	Continue1Row4T:
	cmp [SecondColumnArray + 3], 2
	je Continue2Row4T
	jmp Column1T
	Continue2Row4T:
	cmp [ThirdColumnArray + 3], 2
	je Continue3Row4T
	jmp Column1T
	Continue3Row4T:
	cmp [FourthColumnArray + 3], 2
	je Player2WinnerAnnounce1
	jmp Column1T
	
	Player2WinnerAnnounce1:
	mov dl, 22
	mov dh, 12
	mov ah, 2
	mov bh, 0
	int 10h
	lea dx, [Player2Winner]
	mov dx, offset Player2Winner
	mov ah, 9
	int 21h	
	jmp exit
	
	Column1T:
	cmp [FirstColumnArray], 2
	je Continue1Column1T
	jmp Column2T
	Continue1Column1T:
	cmp [FirstColumnArray + 1], 2
	je Continue2Column1T
	jmp Column2T
	Continue2Column1T:
	cmp [FirstColumnArray + 2], 2
	je Continue3Column1T
	jmp Column2T
	Continue3Column1T:
	cmp [FirstColumnArray + 3], 2
	je Player2WinnerAnnounce2
	jmp Column2T
	
	Column2T:
	cmp [SecondColumnArray], 2
	je Continue1Column2T
	jmp Column3T
	Continue1Column2T:
	cmp [SecondColumnArray + 1], 2
	je Continue2Column2T
	jmp Column3T
	Continue2Column2T:
	cmp [SecondColumnArray + 2], 2
	je Continue3Column2T
	jmp Column3T
	Continue3Column2T:
	cmp [SecondColumnArray + 3], 2
	je Player2WinnerAnnounce2
	jmp Column3T
	
	Column3T:
	cmp [ThirdColumnArray], 2
	je Continue1Column3T
	jmp Column4T
	Continue1Column3T:
	cmp [ThirdColumnArray + 1], 2
	je Continue2Column3T
	jmp Column4T
	Continue2Column3T:
	cmp [ThirdColumnArray + 2], 2
	je Continue3Column3T
	jmp Column4T
	Continue3Column3T:
	cmp [ThirdColumnArray + 3], 2
	je Player2WinnerAnnounce2
	jmp Column4T
	
	Column4T:
	cmp [FourthColumnArray], 2
	je Continue1Column4T
	jmp DiagnolLine1T
	Continue1Column4T:
	cmp [FourthColumnArray + 1], 2
	je Continue2Column4T
	jmp DiagnolLine1T
	Continue2Column4T:
	cmp [FourthColumnArray + 2], 2
	je Continue3Column4T
	jmp DiagnolLine1T
	Continue3Column4T:
	cmp [FourthColumnArray + 3], 2
	je Player2WinnerAnnounce2
	jmp DiagnolLine1T
	
	Player2WinnerAnnounce2:
	mov dl, 22
	mov dh, 12
	mov ah, 2
	mov bh, 0
	int 10h
	lea dx, [Player2Winner]
	mov dx, offset Player2Winner
	mov ah, 9
	int 21h	
	jmp exit
	
	DiagnolLine1T:
	cmp [FirstColumnArray], 2
	je Continue1DiagnolLine1T
	jmp DiagnolLine2T
	Continue1DiagnolLine1T:
	cmp [SecondColumnArray + 1], 2
	je Continue2DiagnolLine1T
	jmp DiagnolLine2T
	Continue2DiagnolLine1T:
	cmp [ThirdColumnArray + 2], 2
	je Continue3DiagnolLine1T
	jmp DiagnolLine2T
	Continue3DiagnolLine1T:
	cmp [FourthColumnArray + 3], 2
	je Player2WinnerAnnounce3
	jmp DiagnolLine2T
	
	DiagnolLine2T:
	cmp [FourthColumnArray], 2
	je Continue1DiagnolLine2T
	jmp CheckPlayer1Number
	Continue1DiagnolLine2T:
	cmp [ThirdColumnArray + 1], 2
	je Continue2DiagnolLine2T
	jmp CheckPlayer1Number
	Continue2DiagnolLine2T:
	cmp [SecondColumnArray + 2], 2
	je Continue3DiagnolLine2T
	jmp CheckPlayer1Number
	Continue3DiagnolLine2T:
	cmp [FirstColumnArray + 3], 2
	je Player2WinnerAnnounce3
	jmp StartOver
	
	Player2WinnerAnnounce3:
	mov dl, 22
	mov dh, 12
	mov ah, 2
	mov bh, 0
	int 10h
	lea dx, [Player2Winner]
	mov dx, offset Player2Winner
	mov ah, 9
	int 21h	
	jmp exit
endp CheckIfPlayer2Won

StartOver:
jmp CheckPlayer1Number

next:
	; Wait for key press
	 mov ah,00h
	 int 16h
	; Return to text mode
	mov ah, 0
	mov al, 2
	int 10h
	
exit:
	mov ax, 4c00h
	int 21h
END start