class User
    attr_accessor :balance
    attr_reader :name, :surname

    def initialize(name:, surname:)
        @name = name
        @surname = surname
        @balance = 0
    end
end
