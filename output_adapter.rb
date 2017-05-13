require 'abstract_method'

class OutputAdapter
    abstract_method :generate_menu, #menu główne, menu konta, menu z kwotami wypłaty
                    :generate_insert_view, #logowanie użytkownika oraz przelew do innego uzytkownika
                    :generate_info_view #stan konta, udane i nieudane logowanie, informacje o wybranej opcji, itd.
end
