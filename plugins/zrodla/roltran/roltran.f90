module plugin_mod
    use iso_c_binding
    implicit none

    character(kind=c_char, len=32), target, save :: name_str = "Rolniczy Translator" // c_null_char
    character(kind=c_char, len=256), target, save :: help_str = &
        "Ta wtyczka dba o poprawna terminologie rolnicza." // c_new_line // &
        "Zamienia 'traktor' na 'ciagnik' (in-place)." // c_null_char

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
        
        ! Pomocnicza zmienna do porownywania
        character(len=7) :: current_chunk
        character(len=7) :: t_word = "traktor"
        character(len=7) :: c_word = "ciagnik"

        call c_f_pointer(input_ptr, str, [1000000]) 

        do i = 1, 1000000 - 7
            if (str(i) == c_null_char) exit
            
            ! Recznie budujemy chunk do porownania
            do j = 1, 7
                current_chunk(j:j) = str(i+j-1)
            end do

            ! Teraz porownanie skalara z wektorem zadziala poprawnie
            if (current_chunk == t_word) then
                do j = 0, 6
                    str(i+j) = c_word(j+1:j+1)
                end do
            end if
        end do

        run_plugin = input_ptr
    end function run_plugin

end module plugin_mod