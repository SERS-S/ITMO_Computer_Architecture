; Upper_case_pstr

; t1 - адрес начала буфера / индекс буфера
; t2 - длина строки
; t3 - output адрес
; t4 - регистр для чтения символов
; t5 - регистр общего назначения
; s1 - макс кол-во символов

.data
input_addr: .word 0x80
output_word: .word 0x84

.text
    .org 0x88
_start:

    addi t0, zero, 0x80
    addi t3, zero, 0x84

    addi s1, zero, 0x1f

    addi t1, zero, 0
    addi t2, zero, 0
    addi t5, zero, '_'

init_buffer:
    bgt t1, s1, read_loop

    sb t5, 0(t1)

    addi t1, t1, 1
    j init_buffer

read_loop:
    lw t4, 0(t0)

    addi t5, zero, 10
    beq t4, t5, end

    beq t2, s1, overflow

    addi t5, zero, 'a'
    bgt t5, t4, write_char

    addi t5, zero, 'z'
    bgt t4, t5, write_char

    addi t4, t4, -32

write_char:
    addi t1, t2, 1
    sb t4, 0(t1)

    addi t2, t2, 1
    j read_loop

overflow:
    lui t5, 0xCCCCC
    addi t5, t5, 0xCCC

    sw t5, 0(t3)

    j halt

end:
    sb t2, 0(zero)

    addi t1, zero, 1

write_output:
    bgt t1, t2, halt

    lw t4, 0(t1)
    sb t4, 0(t3)

    addi t1, t1, 1
    j write_output

halt:
    halt
