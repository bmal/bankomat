require 'singleton'

class Accounts
    include Singleton
    include Enumerable

    def initialize
        @accounts = {}
    end

    def each
        return @accounts.to_enum(:each) unless block_given?

        @accounts.each { |account| yield(account) }
    end

    def add_account_and_return_its_number(user)
        new_account_number = generate_unique_account_number
        @accounts[new_account_number] = user

        new_account_number
    end

    private
    def generate_unique_account_number
        account_number = generate_account_number
        unless unique? account_number
            account_number = generate_account_number
        end

        account_number
    end

    def generate_account_number
        Random.new.rand(1000000000...10000000000)
    end

    def unique?(account_number)
        @accounts.keys.include? account_number
    end
end
