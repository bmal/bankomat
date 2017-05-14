class User
    attr_accessor :balance, :password
    attr_reader :name, :surname

    def initialize(name:, surname:, password:)
        @name = name
        @surname = surname
        @password = password
        @balance = 0
    end
end
