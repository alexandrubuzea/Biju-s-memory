; Copyright 2021 Buzea Alexandru-Mihai-Iulian 321CAb and the IOCLA team (skel)

;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

; defining global variables in order to make the code more clearer
; basically using a global variable for each parameter

section .data
    current_tag dd 0
    cache_matrix dd 0
    tag_array dd 0
    current_offset db 0
    my_register dd 0
    my_address dd 0
    line_to_replace dd 0

; make our function global in order to use it in the C source code

section .text
    global load

; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE],
;            char* address, int to_replace);

load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    ; to_replace (index of the cache line that needs to be replaced
    ; in case of a cache MISS)
    mov edi, [ebp + 24] 
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE
    
    ; retain the value of edx on the stack
    push edx

    ; determining the tag of the given addres in order to search for it
    ; in the tag array

    shr edx, OFFSET_BITS
    mov dword[current_tag], edx

    ; restoring the value of edx register
    pop edx

    ; putting all our parameters into global variables
    mov dword[cache_matrix], ecx
    mov dword[tag_array], ebx
    mov dword[my_register], eax;
    mov dword[my_address], edx
    mov dword[line_to_replace], edi

    ; preparing to iterate through the tag array using ecx counter register
    mov ecx, CACHE_LINES
    mov edx, dword[current_tag]

find_tag:
    ; compare the tag of the given address to each tag in the tag array
    cmp dword[ebx + 4 * ecx - 4], edx

    ; if we find a match, we have a CACHE HIT and we need just to
    ; inspect cache memory
    je cache_hit

    loop find_tag

; if we do not find a match, we have a CACHE MISS and we need to copy a
; set of 8 bytes into our matrix representing the cache memory
cache_miss:

    ; first of all, we want to determine the offset of our byte with
    ; respect to the matrix lines (its address modulo 8)
    mov edx, dword[my_address]
    mov ebx, dword[my_address]
    
    ; getting rid of the last 3 bits
    shr edx, OFFSET_BITS
    shl edx, OFFSET_BITS

    ; using xor in order to determine offset - there will be only the last
    ; three offset bits which can be not zero.
    xor ebx, edx
    mov byte[current_offset], bl 

    ; preparing to use loop
    xor ecx, ecx
    xor ebx, ebx
    
    ; preparing to use cache matrix for copying the set of 8 bytes
    mov eax, dword[cache_matrix]

; copying the memory into the cache
copy_in_cache:

    ; move the byte with the offset kept in ecx register (we will move it
    ; in the cache later)
    mov bl, byte[edx + ecx]

    ; saving the values of ecx and edi
    push ecx
    push edi

    ; here I used shift to left just to perform multiplication by a power of 2
    ; (I used the fact that a line from the cache matrix has a length of 8)

    shl edi, OFFSET_BITS
    add ecx, edi

    ; restoring the value of edi
    pop edi

    ; move the desired byte in the cache memory
    mov byte[eax + ecx], bl

    ; restore the value of ecx
    pop ecx

    inc ecx
    cmp ecx, CACHE_LINE_SIZE

    jnz copy_in_cache

    ; put the tag of the element in the tag array in order to
    ; use the copied memory later
    mov eax, dword[current_tag]
    mov ebx, dword[tag_array]
    mov dword[ebx + 4 * edi], eax

    ; putting the offset of the desired byte in the eax register
    xor eax, eax
    mov al, byte[current_offset]
    mov ebx, dword[cache_matrix]

    ; cleaning the edx register
    xor edx, edx

    mov ecx, dword[line_to_replace]

    ; calculating the index of our byte in the cache memory
    ; treated as an array
    shl ecx, OFFSET_BITS
    add ecx, eax

    ; finally moving the memory in the edx register and then in the
    ; emulated register 
    mov dl, byte[ebx + ecx]
    mov eax, dword[my_register]
    mov byte[eax], dl;

    ; finish
    jmp final_label

; if we have a cache hit, we no longer have to copy from the RAM memory
; into the cache, just use the cache
cache_hit:

    ; calculating the offset of the desired byte
    mov edx, dword[my_address];
    mov ebx, dword[current_tag];
    shl ebx, OFFSET_BITS

    xor edx, ebx
    mov byte[current_offset], dl

    mov ebx, dword[cache_matrix]

    xor eax, eax
    mov al, byte[current_offset]

    xor edx, edx

    ; solving indexing issues (ecx previously used in the loop was indexed
    ; from 1, but here we want to use indexing from 0 as always)
    dec ecx

    ; just multiplying by 8 (here I just used the fact that a line from
    ; the cache matrix has just 8 bytes)
    shl ecx, OFFSET_BITS
    add ecx, eax

    ; copying from cache to the emulated register through edx register
    mov dl, byte[ebx + ecx];

    mov eax, dword[my_register]
    mov byte[eax], dl;

    jmp final_label

; 
final_label:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


