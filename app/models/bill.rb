class Bill < ApplicationRecord
    belongs_to :secret

    def paid?
        !self.payment_date.nil?
    end
end
