class Payment < ApplicationRecord

    belongs_to :secret
    belongs_to :payment_form

    after_update do

        self.secret.balance

    end
end
