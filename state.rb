require 'abstract_method'

class State
    abstract_method :receive_request
end

class UserCreationState < State
    def receive_request(console, accounts, _logged_user)
        received = console.generate_insert_view(title: "TWORZENIE UŻYTKOWNIKA",
                                     field_names: ["imię", "nazwisko", "hasło"])
        user = User.new(name: received["imię"], surname: received["nazwisko"], password: received["hasło"])
        account_number = accounts.add_account_and_return_its_number(user)
        console.generate_info_view(title: "Numer konta", msg: "Twój numer konta to: #{account_number}")
    end
end

class LoggedOutState < State
    def receive_request(console, _accounts, _logged_user)
        console.generate_menu(title: "MENU GŁÓWNE - jesteś niezalogowany",
                              return_states_and_msgs: {loggin_request: "zaloguj się",
                                                       user_creation_request: "załóż konto",
                                                       cancel_request: "zaniechaj"})
    end
end

class AttemptToLoggedInState < State
    def receive_request(console, accounts, _logged_user)
        received = console.generate_insert_view(title: "LOGOWANIE UŻYTKOWNIKA",
                                     field_names: ["numer konta", "hasło"])
        parsed_account_number = received["numer konta"].to_i
        _, found_user = accounts.find { |account_number, _| account_number == parsed_account_number }
        if found_user == nil or received["hasło"] != found_user.password
            console.generate_info_view(title: "Niepoprawna kombinacja login-hasło", msg: "Spróbuj jeszcze raz")
        else
            found_user
        end
    end
end

class EndingState < State
    def receive_request(console, _accounts, _logged_user)
        console.generate_info_view(title: "Koniec sesji", msg: "Dziękujemy za skorzystanie z naszych usług")
    end
end

class LoggedInState < State
    def receive_request(console, _accounts, logged_user)
        console.generate_menu(title: "MENU GŁÓWNE - jesteś zalogowany, witaj #{logged_user.name}, #{logged_user.surname} - stan konta #{logged_user.balance}",
                              return_states_and_msgs: {deposite_request: "wplać",
                                                       withdraw_request: "wypłać",
                                                       transfer_request: "przelej",
                                                       cancel_request: "wyloguj"})
    end
end

class DepositeInState < State
    def receive_request(console, _accounts, logged_user)
        received = console.generate_insert_view(title: "EKRAN DEPOZYTU",
                                                field_names: ["kwota"])
        logged_user.balance += received["kwota"].to_i
        nil
    end
end

class WithdrawOutState < State
    def receive_request(console, _accounts, logged_user)
        received = console.generate_insert_view(title: "EKRAN WYPLATY",
                                                field_names: ["kwota"])
        if logged_user.balance >= received["kwota"].to_i
            logged_user.balance -= received["kwota"].to_i
        else
            console.generate_info_view(title: "Błąd", msg: "Brak wystarczającej środków na koncie")
        end
        nil
    end
end

class TransferState < State
    def receive_request(console, accounts, logged_user)
        received = console.generate_insert_view(title: "EKRAN Przelewu",
                                                field_names: ["kwota", "numer konta odbiorcy"])
        parsed_account_number = received["numer konta odbiorcy"].to_i
        if logged_user.balance >= received["kwota"].to_i
            _, found_user = accounts.find { |account_number, _| account_number == parsed_account_number }
            if found_user == nil
                console.generate_info_view(title: "Błąd", msg: "Brak użytkownika o podanym numerze konta w bazie")
            else
                logged_user.balance -= received["kwota"].to_i
                found_user.balance += received["kwota"].to_i
            end
        else
            console.generate_info_view(title: "Błąd", msg: "Brak wystarczającej środków na koncie")
        end
        nil
    end
end

class StateFactory
    attr_reader :logged_in_state, :logged_out_state, :attempt_to_logged_in_state, :user_creation_state, :ending_state, :deposite_in_state, :withdraw_out_state, :transfer_state

    def initialize
        @logged_out_state = LoggedOutState.new
        @logged_in_state = LoggedInState.new
        @attempt_to_logged_in_state = AttemptToLoggedInState.new
        @user_creation_state = UserCreationState.new
        @ending_state = EndingState.new
        @deposite_in_state = DepositeInState.new
        @withdraw_out_state = WithdrawOutState.new
        @transfer_state = TransferState.new
    end
end