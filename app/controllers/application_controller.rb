class ApplicationController < ActionController::Base

    def remove_mask_for_money(hash = {money: "100.000.000,00"}, key = "money")
        hash[key] = hash[key].gsub(".", "").gsub(",",".").to_f
    end

end
