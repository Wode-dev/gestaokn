class ApplicationController < ActionController::Base
    
    before_action :authenticate_user!

    before_action do
        if action_name != "initial_configuration" && Secret.count == 0
            redirect_to initial_configuration_path
        end
    end


    def remove_mask_for_money(hash = {money: "100.000.000,00"}, key = "money")
        hash[key] = hash[key].gsub(".", "").gsub(",",".").to_f

        hash
    end

end
