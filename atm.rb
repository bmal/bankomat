require_relative 'user'
require_relative 'accounts'
require_relative 'console_adapter'
require_relative 'state'


class ATM
    def initialize
        @state_factory = StateFactory.new(ConsoleAdapter.new, Accounts)
        @state = @state_factory.logged_out_state
        @logged_user = nil
    end

    def run_loop
        while true do
            handle_request(@state.receive_request(@logged_user))
        end
    end

    private
    def handle_request(request)
        if @logged_user == nil
            handle_unlogged_user(request)
        else
            handle_logged_user(request)
        end
    end
    def handle_logged_user(request)
        p request
        case request
        when nil
            @state = @state_factory.logged_in_state
        when :cancel_request
            @logged_user = nil
            @state = @state_factory.ending_state
        when :deposite_request
            @state = @state_factory.deposite_in_state
        when :withdraw_request
            @state = @state_factory.withdraw_out_state
        when :transfer_request
            @state = @state_factory.transfer_state
        end
    end

    def handle_unlogged_user(request)
        case request
        when nil
            @state = @state_factory.logged_out_state
        when :cancel_request
            @state = @state_factory.ending_state
        when :loggin_request
            @state = @state_factory.attempt_to_logged_in_state
        when :user_creation_request
            @state = @state_factory.user_creation_state
        else
            @logged_user = request
            @state = @state_factory.logged_in_state
        end
    end
end


atm = ATM.new.run_loop


