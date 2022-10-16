; Copyright 2021 Buzea Alexandru-Mihai-Iulian 321CAb and the IOCLA team (skel)

; This is a structure used to store a date (the birthday for each of our
; teammates and the present date respectively)

struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; some useful global variables
section .data
    present_year dd 0
    present_month dw 0
    present_day dw 0
    birth_year dd 0
    birth_month dw 0
    birth_day dw 0

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE

    ; moving the length of the array in ecx in order to perform loop
    xchg edx, ecx
    push edx

    ; extracting the present year
    mov edx, dword[esi + my_date.year]
    mov dword[present_year], edx

    xor edx, edx

    ; extracting the present month
    mov dx, word[esi + my_date.month]
    mov word[present_month], dx

    ; extracting the present day
    mov dx, word[esi + my_date.day]
    mov word[present_day], dx

loop_for:
    xor edx, edx
    xor eax, eax
    xor ebx, ebx

    ; moving in the registers the birth date of the current teammate
    mov edx, dword[edi + my_date_size * ecx + my_date.year - my_date_size]
    mov ax, word[edi + my_date_size * ecx + my_date.month - my_date_size]
    mov bx, word[edi + my_date_size * ecx + my_date.day - my_date_size]

    ; moving in the global variables the birth date of the current teammate
    mov dword[birth_year], edx
    mov word[birth_month], ax
    mov word[birth_day], bx

    ; check the birth year vs present year
    xor eax, eax
    mov edx, dword[present_year]
    mov eax, dword[birth_year]

    cmp edx, eax

    jle under_one_year_or_not_born

    ; calculating the age (approximately, it can be the exact age or +1)
    sub edx, eax

    ; check the birth month vs present month
    xor eax, eax
    xor ebx, ebx

    mov ax, word[present_month]
    mov bx, word[birth_month]

    cmp eax, ebx
    jl not_yet_celebrated_birthday

    ; if the months are equal, it means that the current teammate is
    ; celebrating the birthday this month, so we need to check the days
    cmp eax, ebx
    je this_month_celebrates_birthday

    pop eax
    push eax

    mov dword[eax + 4 * ecx - 4], edx;
    jmp continue_loop

; the present month and the birth month are equal, so we need to check for
; the present day and birthday
this_month_celebrates_birthday:
    xor eax, eax
    xor ebx, ebx

    mov ax, word[present_day]
    mov bx, word[birth_day]

    cmp eax, ebx
    jl not_yet_celebrated_birthday

    ; get the age array
    pop eax
    push eax

    ; write the age in our array
    mov dword[eax + 4 * ecx - 4], edx;
    jmp continue_loop

; if the teammate has not celebrated the birthday this year
not_yet_celebrated_birthday:
    pop eax
    push eax

    ; substract 1 from the calculated age
    sub edx, 1

    ; write the age in the array
    mov dword[eax + 4 * ecx - 4], edx;
    jmp continue_loop

; if the teammate has under one year or is unborn (improbable, but possible)
under_one_year_or_not_born:

    ; get the age array
    pop eax
    push eax
    xor ebx, ebx;

    ; write the age (which is 0) in the age array
    mov dword[eax + 4 * ecx - 4], ebx
    jmp continue_loop

; continue the calculation if we have not finished the array

continue_loop:
    dec ecx
    jnz loop_for

    ; we have one more element on the stack, so we need to pop it
    ; in order to avoid segfault
    pop eax

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
