class Payment < ApplicationRecord

    belongs_to :secret
    belongs_to :payment_form

    after_update :verify_situation_to_enable
    after_create :verify_situation_to_enable

    def verify_situation_to_enable
        self.secret.balance

        # Desbloquear se não tiver débito
        @status = self.secret.situation_status
        if self.secret.situation >= 0 || @status == "Regular"
            self.secret.enabled_change true
        end
    end
end
