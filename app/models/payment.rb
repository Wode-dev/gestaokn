class Payment < ApplicationRecord

    belongs_to :secret
    belongs_to :payment_form

end
