require_relative 'user'
require_relative 'accounts'
require_relative 'console_adapter'

# User
user1 = User.new(name: "Daniel", surname: "Wawrzyńczyk")
user1.balance += 100

user2 = User.new(name: "Donald", surname: "Kaczor")
user2.balance = 132

# Accounts
accounts = Accounts.instance
user1_account_number = accounts.add_account_and_return_its_number(user1)
accounts.add_account_and_return_its_number(user2)

_, found_user = accounts.find { |account_number, _| account_number == user1_account_number }
puts "Właściciel numeru konta #{user1_account_number} to #{found_user.name} #{found_user.surname}. Jego stan konta to #{found_user.balance}."

puts "Wszyscy użytkownicy:"
accounts.each do |account_number, user_data|
    puts "#{account_number}; #{user_data.name} #{user_data.surname}; #{user_data.balance}"
end

# ConsoleAdapter
console = ConsoleAdapter.new
