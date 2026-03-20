; Reverse bits

.data
input_addr:  .word 0x80
output_addr: .word 0x84

n: .word 0
res: .word 0
count: .word 32
tmp: .word 0
one: .word 1

.text
_start:
    load input_addr
    load_acc
    store n
loop:
    load res
    shiftl one
    store res
    
    load n
    and one
    store tmp

    load res
    or tmp
    store res

    load n
    shiftr one
    store n

    load count
    sub one

    beqz done
    store count
    jmp loop
done:
    load res
    store_ind output_addr
    halt