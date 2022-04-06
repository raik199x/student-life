.model small
.stack 100h
.data

    ;txt db 'I',034h,'v',0E9h,'a',0C5h,'n',05Dh ;8
    __map__ db 30 dup('#')                                                                                              ;1
            db '#', 28 dup(32), '#'                                                                                     ;2
            db '#',32,'#','#'.32,32,'#',32,32,32,'#','#',32,3 dup('#'),32,'#','#',32,'#','#',32,32, 3 dup('#'),32,'#'   ;3
            db '#',32,32,'#',32,32,'#',32,32,32,'#',32,32,32,'#',32,32,'#',32,'#',32,'#',32,32,'#',32,32,32,'#'         ;4
            db '#',32,32,'#',32,32,'#',32,32,32,'#','#',32,32,'#',32,32,'#',32,32,32,'#',32,32,'#','#','#',32,'#'       ;5
            db '#','#',4 dup(32),'#',32,32,32,'#',32,32,32,'#',32,32,'#',32,32,32,'#',32,32,'#',32,32,32,'#'            ;6
            db '#','#',4 dup(32),3 dup('#'),32,'#','#',32,32,'#',32,32,'#',32,32,32,'#',32,32,'#','#','#',32,'#'        ;7
            db '#',9 dup(32),'#',32,32,32,'#',32,32,'#',10 dup(32),'#'                                                  ;8
            db '#',9 dup(32),'#',32,32,32,'#',32,32,32,'#',5 dup(32),'#','#',32,32,'#'                                  ;9
            db '#',32,32,32,'#','#',4 dup(32),'#',32,32,32,'#',6 dup(32),'#',32,32,'#',32,32,32,'#'                     ;10
            db '#',5 dup(32),'#',32,32,32,'#',32,32,32,'#',6 dup(32),'#',32,32,'#',32,32,32,'#'                         ;11
            db '#',32,32,'#',32,'#',13 dup(32),'#','#','#',32,32,'#','#','#',32,32,'#','#','#',32,'#'                   ;12
            db '#',32,'#',32,'#',32,32,32,'#',7 dup(32),'#',4 dup(32),'#',6 dup(32),'#'                                 ;13
            db '#',32,'#',6 dup(32),7 dup('#'),9 dup(32),'#',32,32.'#'                                                  ;14
            db '#',32,32,'#',8 dup(32),4 dup('#'),32,32,32,5 dup('#'),32,'#','#',32,'#'                                 ;15
            db '#',32,'#',10 dup(32),4 dup('#'),6 dup(32),'#',32,'#',32,32,'#'                                          ;16
            db '#',13 dup(32),'#','#',32,32,'#',32,32,'#',32,'#',32,'#',32,32,'#'                                       ;17
            db '#',32,'#','#',32,32,3 dup('#'),32,3 dup('#'),6 dup(32),'#',32,'#',32,'#',32,'#','#',32,'#'              ;18
            db '#',32,'#','x','#',32,32,'#',32,32,'#',4 dup(32),'#','#',6 dup(32),'#',32,32,'#',32,'#'                  ;19
            db '#',32,'#','x','#',32,32,'#',32,32,3 dup('#'),32,32,3 dup('#'),3 dup(32),4 dup('#'),32,'#',32,'#'        ;20
            db '#',32,'#','x','#',32,32,'#',32,32,'#',4 dup('#'),'#','#',9 dup(32),'#',32,'#'                           ;21
            db '#',32,'#','#',32,32,3 dup('#'),32,'#','#','#',5 dup(32),'#',32,32,'#',32,'#',32,'#','#',32,32,32,'#'    ;22
            db 30 dup('#')                                                                                              ;23


.code 
; whole screen 80x25

jmp start

    ClearScreen macro
        mov ax,0003h ;; setting graphic mode
        int 10h      ;; + clearing screen
    endm

New_line_output proc
    mov dl,10
    mov ah,2
    int 21h
    mov dl,13
    int 21h
    ret
    New_line_output endp

OutputLine proc
        mov cx,80*25 ; whole line
        xor di,di
        start_loop:
        mov es:di, word ptr '#'
        inc di
        mov es:di, word ptr 1Fh
        inc di
        loop start_loop
        ret
    OutputLine endp
start:
    mov ax,DGROUP
    mov ds,ax

    push 0B800h ; code of vider driver
    pop es      ; setting codes

    ClearScreen

    call OutputLine

    mov ax,4C00h
    int 21h
end start