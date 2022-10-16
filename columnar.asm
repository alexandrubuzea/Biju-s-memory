; Copyright 2021 Buzea Alexandru-Mihai-Iulian 321CAb and the IOCLA team (skel)

; some useful global variables
section .data
    extern len_cheie, len_haystack
    index dd 0
    current_length dd 0

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE

    ; clean the ecx register in order to use it as counter for loop
    xor ecx, ecx

    ; in this variable we want to always keep the current length of
    ; our built cipher
    mov dword[current_length], 0
    
; while there are more characters in the key, we search for the
; corresponding characters in the haystack
key_label:
    xor eax, eax
    mov eax, dword[edi + 4 * ecx]
    mov dword[index], eax

; write all the characters from the haystack to cipher
haystack_label:

    ; extract current index from the key
    mov edx, dword[index]
    xor eax, eax

    ; extract the character from the haystack
    mov al, byte[esi + edx]

    ; extract the current length of the cipher text
    mov edx, dword[current_length]

    ; put the extracted character from the haystack into the ciphertext
    mov byte[ebx + edx], al
    inc edx
    mov dword[current_length], edx

    ; calculating the new index from where to extract the character
    ; from haystack
    mov edx, dword[index]
    add edx, dword[len_cheie]
    mov dword[index], edx

    ; check if we have finished the loop corresponding to the given
    ; base index from the order array
    cmp edx, [len_haystack]
    jl haystack_label

    ; go to the next index from the column order array
    inc ecx
    cmp ecx, dword[len_cheie]
    jnz key_label

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY