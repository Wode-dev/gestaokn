module SyncHelper

    def record_details(table, id)
        case table
        when "Secret"

            Secret.find(id).secret
        when "Plan"

            Plan.find(id).profile_name
        end
    end
    
end
