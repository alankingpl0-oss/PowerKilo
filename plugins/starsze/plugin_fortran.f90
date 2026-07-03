module plugin_mod
    use iso_c_binding
    implicit none

    ! Definiujemy konkretna dlugosc, zeby kompilator wiedzial ile pamieci dac
    character(kind=c_char, len=32), target, save :: name_str = "Fortran Loudener" // c_null_char
    character(kind=c_char, len=256), target, save :: help_str = &
        "Ta wtyczka zamienia male litery na wielkie." // c_new_line // &
        "Dziala in-place na buforze edytora." // c_null_char

contains

    ! --- Zwraca nazwę wtyczki ---
    function plugin_name() bind(c, name="plugin_name")
        type(c_ptr) :: plugin_name
        plugin_name = c_loc(name_str)
    end function plugin_name

    ! --- Zwraca treść instrukcji ---
    function plugin_help() bind(c, name="plugin_help")
        type(c_ptr) :: plugin_help
        plugin_help = c_loc(help_str)
    end function plugin_help

    ! --- Modyfikuje tekst (UpperCase) ---
    function run_plugin(input_ptr) bind(c, name="run_plugin")
        type(c_ptr), value :: input_ptr
        type(c_ptr) :: run_plugin
        character(kind=c_char), pointer :: str(:)
        integer(c_size_t) :: i

        ! Mapowanie wskaźnika C na tablicę Fortranu
        call c_f_pointer(input_ptr, str, [1000000]) 

        do i = 1, 1000000
            if (str(i) == c_null_char) exit
            
            ! Standardowa zamiana ASCII dla malych liter
            if (iachar(str(i)) >= 97 .and. iachar(str(i)) <= 122) then
                str(i) = achar(iachar(str(i)) - 32)
            end if
        end do

        run_plugin = input_ptr
    end function run_plugin

end module plugin_mod