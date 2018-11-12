class Payment < ApplicationRecord

    belongs_to :secret
    has_one :payment_form

end
