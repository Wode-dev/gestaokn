class PaymentForm < ApplicationRecord

    has_many :payments

    def form
        "#{self.kind} - #{self.place}"
    end

end
