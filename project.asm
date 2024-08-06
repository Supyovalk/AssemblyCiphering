.model small
.stack 100h
.data
data db 16 dup(?)
key dw ?
message1 db 'Enter a 16 letter code(please dont press enter.)',10,13,'$'
message2 db 'Enter a key (0 to exit the program)',10,13,'$'
message3 db 'Enter 0 to crypt,anything else to decrypt',10,13,'$'
message4 db 'Thank you for using yoval cry9er program!',10,13,'$'
message5 db 'see you soon and "t axuunm d a arl"!','$'
len equ 16
.code
 mov ax,@data
 mov ds,ax
 lop9:
 push offset message1
 call printstring
 push offset data
 call input
 call dbreak
 push offset message2
 call printstring
 call inputkey
 call dbreak
 mov si,offset key
 mov ax,[si]
 cmp al,0
 je skip7
 push offset message3
 call printstring
 push offset data
 push offset key
 mov ah,1
 int 21h
 cmp al,'0'
 je skip5
 call clearcon
 call decrypt
 jmp skip6
 skip5:
 call clearcon
 call crypt
 skip6:
 call dbreak
 push offset data
 call printarr
 call dbreak
 jmp lop9
 skip7:
 push offset message4
 call printstring
 push offset message5
 call printstring
.exit
;this proc will clear the console
;no input or output
clearcon PROC near
push ax
push es
mov ax,0b800h 
mov es,ax
xor di,di
mov cx,2000 
mov ax,0720h 
rep stosw
pop es
pop es
ret
clearcon ENDP
; this proc will let the user enter a value (need to be from 0 to 9) and store it at key 
; no input or output
inputkey PROC near
 push bp
 mov bp,sp
 mov ah,1
 int 21h
 sub al,30h
 mov ah,0
 mov si,offset key
 mov [si],ax
 pop bp
 ret
ENDP inputkey
; this proc will print a string ending with $.
; input:address of the start of the string
 printstring PROC near
 push bp
 mov bp,sp
 mov dx,[bp+4]
 mov ah,9h
 int 21h
 pop bp
 ret 2
ENDP printstring
; this proc decrypt the code using the data.
; input:bp+4:the decryptkey,bp+6:address of the start of arr
decrypt PROC near
 push bp
 mov bp,sp
 mov si,[bp+4]
 mov cx,[si]
 mov si,[bp+6]
 lop8:
 push cx
 push si
 push si
 call deshift
 pop si
 pop cx
 push cx
 push si
 push si
 call deconvertarr
 pop si
 pop cx
 loop lop8
 pop bp
 ret 4
ENDP decrypt
; this proc crypt the code using the data.
; input:bp+4:the decryptkey,bp+6:address of the start of arr
crypt PROC near
 push bp
 mov bp,sp
 mov si,[bp+4]
 mov cx,[si]
 mov si,[bp+6]
 lop7:
 push cx
 push si
 push si
 call shift
 pop si
 pop cx
 push cx
 push si
 push si
 call convertarr
 pop si
 pop cx
 loop lop7
 pop bp
 ret 4
ENDP crypt
; this proc does a line break.
; no input
dbreak PROC near
 push bp
 mov bp,sp
 mov ah,2
 mov dx,10
 int 21h
 mov dx,13
 int 21h
 pop bp
 ret 0
ENDP
; this will let the user input 'len' chars to the array.
; input:the address of the input array
input PROC near
 push bp
 mov bp,sp
 mov si,[bp+4]
 mov cx,len
 mov ah,1
 lop1:
 int 21h
 mov [si],al
 inc si
 loop lop1
 pop bp
 ret 2
ENDP input
; this proc converts an byte size address by the crypt rules.
; input:the address to convert
convert PROC near 
push bp
mov bp,sp
mov bx,[bp+4]
mov dl,[bx]
cmp dl,32
je skip2
cmp dl,44
je skip2
cmp dl,46
je skip2
inc dl
cmp dl,123
jne skip1
mov dl,97
skip1:
cmp dl,91
jne skip2
mov dl,65
skip2:
mov [bx],dl
pop bp
ret 2
ENDP convert
; this proc converts an array by the crypt rules.
; input:the address of the array
convertarr PROC near 
push bp
mov bp,sp
mov si,[bp+4]
mov cx,len
lop3:
push cx
push si
push si
call convert
pop si
pop cx
inc si
loop lop3
pop bp
ret 2
ENDP convertarr
; this proc unconverts an array by the crypt rules.
; input:the address of the array
deconvertarr PROC near 
push bp
mov bp,sp
mov si,[bp+4]
mov cx,len
lop4:
push ax
push cx
push si
push si
call deconvert
pop si
pop cx
pop ax
inc si
loop lop4
pop bp
ret 2
ENDP deconvertarr
; this proc deconverts a address by the crypt rules.
; input:the address to convert
deconvert PROC near 
push bp
mov bp,sp
mov bx,[bp+4]
mov dl,[bx]
cmp dl,32
je skip4
cmp dl,44
je skip4
cmp dl,46
je skip4
dec dl
cmp dl,96
jne skip3
mov dl,122
skip3:
cmp dl,64
jne skip4
mov dl,90
skip4:
mov [bx],dl
pop bp
ret 2
ENDP deconvert
; this proc will print the code array an string.
; input:the address of the array.
printarr PROC near
push bp
mov bp,sp
mov si,[bp+4]
mov cx,len
mov ah,2
lop2:
mov dl,[si]
int 21h
inc si
loop lop2
pop bp
ret 2
ENDP printarr
; this proc will shift an array.
; input:the address of the array.
shift PROC near
push bp
mov bp,sp
mov si,[bp+4]
add si,len
dec si
mov dl,[si]
lop5:
dec si
mov dh,[si]
mov [si+1],dh
cmp si,[bp+4]
jne lop5
mov [si],dl
pop bp
ret 2
ENDP shift
; this proc will deshift an array.
; input:the address of the array.
deshift PROC near
push bp
mov bp,sp
mov si,[bp+4]
mov cx,len
add cx,si
dec cx
mov dl,[si]
lop6:
inc si
mov dh,[si]
mov [si-1],dh
cmp si,cx
jne lop6
mov si,cx
mov byte ptr[si],dl
pop bp
ret 2
ENDP deshift
end