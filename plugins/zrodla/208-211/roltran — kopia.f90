module plugin_mod
    use iso_c_binding
    implicit none

    character(kind=c_char, len=32), target, save :: name_str = "Rolniczy Translator" // c_null_char
    character(kind=c_char, len=256), target, save :: help_str = &
        "Ta wtyczka dba o poprawne lata i zamienia rok 2008 na 2012, zeby nie bylo problemow ze smierdzacym rokiem." // c_new_line // &
        "Zamienia '2008' (smierdzi) na '2012' (in-place)." // c_null_char

contains

    function plugin_name() bind(c, name="plugin_name")
        type(c_ptr) :: plugin_name
        plugin_name = c_loc(name_str)
    end function plugin_name

    function plugin_help() bind(c, name="plugin_help")
        type(c_ptr) :: plugin_help
        plugin_help = c_loc(help_str)
    end function plugin_help

    function run_plugin(input_ptr) bind(c, name="run_plugin")
        type(c_ptr), value :: input_ptr
        type(c_ptr) :: run_plugin
        character(kind=c_char), pointer :: str(:)
        integer(c_size_t) :: i, j
        
        ! Zmieniamy na len=4, bo rok ma 4 cyfry
        character(len=4) :: current_chunk
        character(len=4) :: t_word = "2008"

        character(len=4) :: c_word = "2012"

        call c_f_pointer(input_ptr, str, [1000000]) 

        ! Przeszukujemy bufor (z marginesem na 4 znaki)
        do i = 1, 1000000 - 4
            if (str(i) == c_null_char) exit
            
            ! Budujemy chunk 4-znakowy
            do j = 1, 4
                current_chunk(j:j) = str(i+j-1)
            end do

            if (current_chunk == t_word) then
                do j = 0, 3
                    str(i+j) = c_word(j+1:j+1)
                end do
            end if
        end do

        run_plugin = input_ptr
    end function run_plugin

end module plugin_mod