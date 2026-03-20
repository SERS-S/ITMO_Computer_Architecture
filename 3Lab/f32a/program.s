\ Fibonacci

.data
input_addr: .word 0x80
output_addr: .word 0x84

.text
.org 0x100
_start:
    \ Ввод
    read_input

    \ Тест на возможность рассчитать результат
    dup
    lit -47
    +
    -if out_of_borders

    \ Тест на input == 0
    dup
    if zero_input

    \ Тест на input == 1
    dup
    lit -1
    +
    if one_input

    \ Тест на input < 0
    dup
    -if main_cycle
    negative_input ;

    \ Основной цикл
main_cycle:
    lit -2
    +
    >r
    lit 0 \ a
    lit 1 \ b
loop:
    dup
    a!
    +
    a
    over
    next loop

    write_output
    end ;

negative_input:
    drop
    lit -1
    write_output
    end ;

one_input:
    drop
    lit 1
    write_output
    end ;

zero_input:
    drop
    lit 0
    write_output
    end ;

out_of_borders:
    drop
    lit 0xCCCCCCCC
    write_output
    end ;

    \ Процедуры
read_input:
    @p input_addr
    a!
    @
    ;

write_output:
    @p output_addr
    a!
    !
    ;

end:
    halt
