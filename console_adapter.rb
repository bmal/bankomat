require_relative 'output_adapter'

class ConsoleAdapter < OutputAdapter
    DEFAULT_chosen_option = 1000
    PROMPT = ">> "

    def generate_main_menu(return_states_and_msgs)
        puts "*** MENU GŁÓWNE ***"
        chosen_option = DEFAULT_chosen_option

        until valid?(expected: (0...return_states_and_msgs.size), actual: chosen_option)
            puts "Proszę wybrać opcję:"

            return_states_and_msgs.each.with_index do |(_, msg), index|
                puts "\t[#{index}] #{msg}"
            end

            print PROMPT
            input = gets.strip
            chosen_option = input.to_i unless input == ""
        end

        return_states_and_msgs.keys[chosen_option]
    end

    private
    def valid?(expected:, actual:)
        expected.include? actual
    end
end
