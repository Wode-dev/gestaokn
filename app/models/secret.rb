class Secret < ApplicationRecord
    belongs_to :plan

    before_update :on_enabled_change

    def on_enabled_change

        if enabled_changed?
            mk = MTik::Connection.new(:host=>"177.136.34.190", :user=>"admin",:pass=>"ALCATRAZ")
            
            puts mk.get_reply("/ppp/secret/set",
                "=disabled=#{self.enabled ? "no" : "yes"}",
                "=.id=#{mk.get_reply("/ppp/secret/print", 
                "?name=#{self.secret}")[0][".id"]}")
        end
    end
end
