; Upper_case_pstr

; t1 - адрес начала буфера
; t2 - длина строки
; t3 - output адрес
; t4 - регистр для чтения символов
; t5 - регистр общего назначения
; s1 - макс кол-во символов

.data
input_addr: .word 0x80
output_word: .word 0x84

.text
_start:

    lui t0, %hi(input_addr)
    addi t0, t0, %lo(input_addr)
    lw t0, 0(t0)

    lui sp, %hi(0x1000)
    addi sp, sp, %lo(0x1000)

    addi s1, zero, 0x20

    addi t1, zero, 0
    addi t2, zero, 0

read_loop:
    lw t4, 0(t0)

    addi t5, zero, 10
    beq t4, t5, end

    beq t2, s1, overflow

    addi sp, sp, -4
    sw t4, 0(sp)
    jal ra, uppercase_and_write
    addi sp, sp, 4

    addi t2, t2, 1
    j read_loop

uppercase_and_write:
    lw t4, 0(sp)

    addi t5, zero, 'a'
    bgt t5, t4, write_char

    addi t5, zero, 'z'
    bgt t4, t5, write_char

    addi t4, t4, -32

write_char:
    lui t3, %hi(output_word)
    addi t3, t3, %lo(output_word)
    lw t3, 0(t3)
    sb t4, 0(t3)

    jr ra

overflow:
    lui t3, %hi(output_word)
    addi t3, t3, %lo(output_word)
    lw t3, 0(t3)

    lui t5, 0xCCCCD
    addi t5, t5, 0xCCC

    sw t5, 0(t3)

    j end

end:
    halt
