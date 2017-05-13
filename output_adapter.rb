require 'abstract_method'

class OutputAdapter
    abstract_method :generate_main_menu,
                    :generate_account_menu,
                    :generate_balance_view,
                    :generate_cash_out_view,
                    :generate_transfer_view
end
