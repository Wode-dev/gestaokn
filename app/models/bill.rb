class Bill < ApplicationRecord
    belongs_to :secret

    after_update do

        self.secret.balance
    end
end
