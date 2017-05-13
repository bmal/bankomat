require_relative 'output_adapter'

class ConsoleAdapter < OutputAdapter
    def generate_main_menu(return_states_and_msgs)
        puts "*** MENU GŁÓWNE ***"
        puts "Proszę wybrać opcję:"
        return_codes_and_msgs.each.with_index do |index, (return_state, msg)|
            puts "\t[#{index}] #{msg}"
        end
    end
end
