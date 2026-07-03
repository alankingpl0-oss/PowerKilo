module my_plugin
    use iso_c_binding
    implicit none

contains

    ! Funkcja zwracająca nazwę wtyczki
    function plugin_name() bind(c, name="plugin_name")
        type(c_ptr) :: plugin_name
        character(kind=c_char), target, save :: name_str = "Licznik Fortranowy" // c_null_char
        plugin_name = c_loc(name_str)
    end function plugin_name

    ! Główna funkcja przetwarzająca tekst
    function run_plugin(input_ptr) bind(c, name="run_plugin")
        type(c_ptr), value :: input_ptr
        type(c_ptr) :: run_plugin
        character(kind=c_char), pointer :: f_ptr(:)
        character(len=:), allocatable, save :: output_str
        integer :: i, n

        ! Konwersja wskaźnika C na tablicę w Fortranie
        call c_f_pointer(input_ptr, f_ptr, [1000000]) ! Zakładamy max rozmiar dla uproszczenia

        ! Znajdź długość ciągu (do znaku null)
        n = 0
        do while (f_ptr(n+1) /= c_null_char)
            n = n + 1
        end do

        ! Prosta operacja: dodajemy informację od Fortranu na początku
        output_str = "Fortran mówi: Tekst ma " // char(48 + mod(n, 10)) // " znaków (jedności). " // c_null_char
        
        run_plugin = c_loc(output_str)
    end function run_plugin

end module my_plugin