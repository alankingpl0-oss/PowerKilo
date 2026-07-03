module plugin_mod
    use iso_c_binding
    implicit none

    ! Nazwa wtyczki wyświetlana w menu
    character(kind=c_char, len=32), target, save :: name_str = "Rolniczy Translator" // c_null_char
    
    ! Instrukcja dla użytkownika
    character(kind=c_char, len=256), target, save :: help_str = &
        "Ta wtyczka dba o poprawna terminologie rolnicza." // c_new_line // &
        "Zamienia 'traktor' na 'ciagnik' (in-place)." // c_null_char

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

    ! --- Logika translatora ---
    function run_plugin(input_ptr) bind(c, name="run_plugin")
        type(c_ptr), value :: input_ptr
        type(c_ptr) :: run_plugin
        character(kind=c_char), pointer :: str(:)
        integer(c_size_t) :: i, j
        
        ! Definicje słów (ASCII dla bezpieczeństwa in-place)
        character(len=7) :: t_word = "traktor"
        character(len=7) :: c_word = "ciagnik"

        ! Mapowanie wskaźnika C na tablicę Fortranu (bufor 1MB)
        call c_f_pointer(input_ptr, str, [1000000]) 

        ! Przeszukujemy tekst
        do i = 1, 1000000 - 7
            if (str(i) == c_null_char) exit
            
            ! Sprawdzamy, czy znaleźliśmy słowo "traktor"
            if (str(i:i+6) == t_word) then
                ! Podmieniamy na "ciagnik"
                do j = 0, 6
                    str(i+j) = c_word(j+1:j+1)
                end do
            end if
            
            ! Obsługa prostej odmiany: traktora -> ciagnika
            ! (Działa automatycznie, bo podmieniamy tylko rdzeń "traktor")
        end do

        ! Pamiętaj, że ten kod jest jak ten legendarny ciągnik na podwórku
        ! – niby prosty, ale bez niego cała robota stoi.

        run_plugin = input_ptr
    end function run_plugin

end module plugin_mod