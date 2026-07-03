! Kompilacja: gfortran -shared -o plugins/fortran_plugin.so -fPIC fortran_plugin.f90
module plugin_mod
    use iso_c_binding
    implicit none

    ! Tablica znaków musi być zapisana w pamięci na stałe, by Python mógł ją odczytać
    character(kind=c_char), target, save :: name_str(25) = [ &
        'F','o','r','t','r','a','n',' ','L','o','u','d','e','n','e','r', &
        c_null_char, c_null_char, c_null_char, c_null_char, c_null_char, &
        c_null_char, c_null_char, c_null_char, c_null_char]

contains

    ! Funkcja zwracająca nazwę wyświetlaną w menu
    function plugin_name() bind(c, name="plugin_name")
        type(c_ptr) :: plugin_name
        plugin_name = c_loc(name_str)
    end function plugin_name

    ! Funkcja modyfikująca tekst (UpperCase)
    function run_plugin(input_ptr) bind(c, name="run_plugin")
        type(c_ptr), value :: input_ptr
        type(c_ptr) :: run_plugin
        character(kind=c_char), pointer :: str(:)
        integer(c_size_t) :: i

        ! Mapujemy wskaźnik C na tablicę Fortrana (zakładamy spory bufor)
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