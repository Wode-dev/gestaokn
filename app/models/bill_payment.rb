class BillPayment < ApplicationRecord

    belongs_to :bill
    belongs_to :payment

end
