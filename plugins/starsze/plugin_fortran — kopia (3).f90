module plugin_mod
    use iso_c_binding
    implicit none

    character(kind=c_char), target, save :: name_str(*) = "Fortran Loudener" // c_null_char
    character(kind=c_char), target, save :: help_str(*) = &
        "Ta wtyczka zamienia male litery na wielkie." // c_new_line // &
        "Dziala in-place na buforze edytora." // c_null_char

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
        integer(c_size_t) :: i

        ! Mapowanie wskaźnika na tablicę Fortranową
        call c_f_pointer(input_ptr, str, [1000000]) 

        do i = 1, 1000000
            if (str(i) == c_null_char) exit
            if (iachar(str(i)) >= 97 .and. iachar(str(i)) <= 122) then
                str(i) = achar(iachar(str(i)) - 32)
            end if
        end do

        ! ZWRACAMY input_ptr, nie potrzebujemy c_loc na zmiennych lokalnych!
        run_plugin = input_ptr
    end function run_plugin

end module plugin_mod