require_relative 'output_adapter'

class ConsoleAdapter < OutputAdapter
    DEFAULT_chosen_option = 1000
    PROMPT = ">> "

    def generate_menu(title, return_states_and_msgs)
        puts "*** #{title.upcase} ***"
        chosen_option = DEFAULT_chosen_option

        until valid_user_responce?(expected: (0...return_states_and_msgs.size), actual: chosen_option)
            puts
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

    def insert_view(title, field_names)
        puts "*** #{title.upcase} ***"

        field_names.map do |field|
            puts
            puts "Podaj #{field}:"

            print PROMPT
            [field, gets.strip]
        end.to_h
    end

    def generate_info_view(title, info)
        puts "*** #{title.upcase} ***"
        puts
        puts info
        puts
        puts "Prosze przycisnąć enter by zamknąć"
        gets
        nil
    end

    private
    def valid_user_responce?(expected:, actual:)
        expected.include? actual
    end
end
