; fnv32_1_hash

; t0 - input_address
; t1 - output_address
; t2 - fnv_prime
; t3 - initial_hash / final_result
; t4 - counter
; t5 - buffer

.data
input_addr: .word  0x80
output_addr: .word  0x84
fnv_prime: .word  0x01000193
initial_hash: .word  0x811C9DC5

.text
.org 0x100

_start:
    lui t0, %hi(input_addr) / lui t1, %hi(output_addr) / nop / nop
    addi t0, t0, %lo(input_addr) / addi t1, t1, %lo(output_addr)  / nop / nop
    nop / nop / lw t0, 0(t0) / nop
    nop / nop / lw t1, 0(t1) / nop

    lui t2, %hi(fnv_prime) / lui t3, %hi(initial_hash) / nop / nop
    addi t2, t2, %lo(fnv_prime) / addi t3, t3, %lo(initial_hash) / nop / nop
    nop / nop / lw t2, 0(t2) / nop
    nop / nop / lw t3, 0(t3) / nop

read_char:
    nop / nop / lw t4, 0(t0) / nop
    nop / nop / nop / beqz t4, write_result

    ; hash = (hash * prime) ^ character
    mul t5, t3, t2 / nop / nop / nop
    xor t3, t5, t4 / nop / nop / j read_char

write_result:
    nop / nop / sw t3, 0(t1) / nop
    nop / nop / nop / halt
