! Kompilacja: gfortran -shared -fPIC -o plugins/libfortran_plugin.so fortran_plugin.f90
module plugin_mod
    use iso_c_binding
    implicit none

    ! Nazwa wyświetlana w menu głównym
    character(kind=c_char), target, save :: name_str(*) = "Fortran Loudener" // c_null_char
    
    ! Treść instrukcji wyświetlanej w oknie dialogowym
    character(kind=c_char), target, save :: help_str(*) = &
        "Ta wtyczka zamienia wszystkie male litery na wielkie (LOUDENER)." // c_new_line // &
        "Dziala bezposrednio na pamieci edytora, korzystajac z szybkosci Fortranu." // c_null_char

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

        ! Mapujemy wskaźnik C na tablicę Fortranu
        ! Zakładamy bezpieczny zakres bufora na 1MB
        call c_f_pointer(input_ptr, str, [1000000]) 

        do i = 1, 1000000
            ! Sprawdzamy koniec ciągu znaków C (\0)
            if (str(i) == c_null_char) exit
            
            ! Jeśli mała litera (ASCII 97-122), zamień na wielką (odejmij 32)
            if (iachar(str(i)) >= 97 .and. iachar(str(i)) <= 122) then
                str(i) = achar(iachar(str(i)) - 32)
            end if
        end do

        ! Zwracamy ten sam wskaźnik do zmodyfikowanej pamięci
        run_plugin = input_ptr
    end function run_plugin

end module plugin_mod