.model small

.data
    message1 db "Enter text: $"
    message2 db "Encrypted text: $"
    maxLetters = 10

    arrEntered db maxLetters dup(?)  
    arrOuted db maxLetters dup(?)  

.code
main proc Far
    
    ;mov ax, @data
    ;mov ds, ax
    .startup
    
    lea dx, message1
    mov ah, 09h
    int 21h

    
    lea si, arrEntered   
    mov cx, 0              

readInputLoop:

    mov ah, 01h 
    int 21h         ; Read Char

    ; Check for Enter key (13 decimal)
    cmp al, 13
    je inputEntered

    ; Store character
    mov [si], al
    inc si
    inc cx

    cmp cx, maxLetters
    jl readInputLoop

inputEntered:
    
    ; Prepare for encryption
    lea si, arrEntered    
    lea di, arrOuted  
    mov bx, cx             ; Store character count

; Encryption loop
encryptLoop:
    
    cmp bx, 0
    je encryptionDone

    
    mov al, [si]
    
    call encryptProc       

    ; Store encrypted character
    mov [di], al

    ; Move to next characters
    inc si
    inc di
    dec bx

    jmp encryptLoop

encryptionDone:
    
    mov byte ptr [di], '$'
    
    mov ah, 09h
    lea dx, message2
    int 21h

    mov ah, 09h
    lea dx, arrOuted
    int 21h

    ;mov ah, 4Ch
    ;int 21h
    .exit
    

main endp

encryptProc proc NEAR

    ; Encrypt character in AL
    cmp al, 'A'            
    jb returnChar         
    cmp al, 'z'
    ja returnChar         

    
    cmp al, 'Z'
    jle shifting
    
    cmp al, 'a'
    jge shifting

returnChar:
    ret           ; Return Same Char

shifting:
    add al, 2              
    ret
    
    encryptProc endp  
end main