; Copyright 2021 Buzea Alexandru-Mihai-Iulian 321CAb and the IOCLA team (skel)

section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implement rotp
    ;; FREESTYLE STARTS HERE

    ; retain the value of the length on the stack
    push ecx

label_for:
    ; preparing registers for calculations
    xor eax, eax
    xor ebx, ebx

    ; put in the ebx register the length of the key
    pop ebx
    push ebx

    ; determining the index in the reversed haystack
    sub ebx, ecx
    mov al, byte[esi + ebx]

    ; cleaning the ebx register in order to move the byte from the key
    xor ebx, ebx
    mov bl, byte[edi + ecx - 1]

    ; perform cipher
    xor al, bl

    ; getting the index in the ciphertext again and then moving the
    ; result in the ciphertext
    pop ebx
    push ebx
    sub ebx, ecx
    mov byte[edx + ebx], al;

    loop label_for

    pop ebx

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY