; Rle compress bytes

; A0 - вход 0x80
; A1 - выход 0x84
; A2 - cpr_ln_bt
; A3 - ct_words
; A4 - out_words buffer
; A7 - stack pointer

; D0 - input length / compressed length
; D1 - счетчик слов / remaining compressed bytes (from D0)
; D2 - текущее слово / packed output word
; D3 - текущий байт
; D4 - remaining_bytes
; D5 - current_run_byte
; D6 - current_run_count
; D7 - внутренний счетчик

.data
.org 0x100
input_addr: .word 0x80
output_addr: .word 0x84

cpr_ln_bt: .word 0 ; compressed length bytes
ct_words: .word 0 ; count of input words
out_words: .word 0 ; buffer start for compressed bytes

.text
.org 0x300
_start:
    ;;; Initial ;;;
    movea.l input_addr, A0
    movea.l (A0), A0

    movea.l output_addr, A1
    movea.l (A1), A1

    movea.l cpr_ln_bt, A2
    movea.l ct_words, A3
    movea.l out_words, A4

    movea.l 0x77C, A7

    move.l (A0), D0 ; D0 - length

    ;;; Domain check ;;;
    cmp.l 0, D0
    blt negative_input
    beq zero_input

    ;;; Main code ;;;
    move.l D0, D1 ; счетчик слов
    add.l 3, D1
    div.l 4, D1
    move.l D1, (A3)

    move.l D0, D4 ; remaining_bytes
    move.l 0, (A2) ; cpr_ln_bt
    move.l 0, D6 ; current_run_count

words_loop:
    cmp.l 0, D1
    beq words_done

    move.l (A0), D2 ; текущее слово
    move.l D2, -(A7)
    jsr process_word
    move.l (A7)+, D7

    add.l -1, D1
    jmp words_loop

process_word:
    link A6, 0
    move.l 8(A6), D2
    move.l 4, D7

bytes_loop:
    cmp.l 0, D4
    beq process_word_done

    move.l D2, D3
    lsr.l 24, D3
    and.l 0xFF, D3

    cmp.l 0, D6
    beq start_new_run

    cmp.l D5, D3
    bne flush_and_restart

    cmp.l 255, D6
    beq flush_and_restart

    add.l 1, D6
    jmp byte_done

flush_and_restart:
    move.l D6, (A4)+
    move.l D5, (A4)+
    add.l 2, (A2)

start_new_run:
    move.l D3, D5
    move.l 1, D6

byte_done:
    asl.l 8, D2
    add.l -1, D4
    add.l -1, D7
    bne bytes_loop

process_word_done:
    unlk A6
    rts

words_done:
    cmp.l 0, D6
    beq pack_output

    move.l D6, (A4)+
    move.l D5, (A4)+
    add.l 2, (A2)

;;; Packaging ;;;
pack_output:
    move.l (A2), D0 ; cpr_ln_bt
    move.l D0, (A1)

    movea.l out_words, A4 ; указатель на начало послед. (ct, word)
    move.l D0, D1

pack_words_loop:
    cmp.l 0, D1
    beq end

    move.l 0, D2
    move.l 4, D7

pack_bytes_loop:
    asl.l 8, D2
    cmp.l 0, D1
    beq pack_slot_done

    move.l (A4)+, D3
    and.l 0xFF, D3
    or.l D3, D2
    add.l -1, D1

pack_slot_done:
    add.l -1, D7
    bne pack_bytes_loop

    move.l D2, (A1)
    jmp pack_words_loop

zero_input:
    move.l 0, (A1)
    jmp end

negative_input:
    move.l -1, (A1)
    jmp end

end:
    halt
