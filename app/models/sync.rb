class Sync < ApplicationRecord
    def self.sync_mikrotik_and_system
        Sync.all.each do |s|
            s.destroy
        end
        @connection = connect_mikrotik

        @secrets = @connection.get_reply("/ppp/secret/print")
        @secrets.each do |secret|
            if secret.key?("!re")
                verify_secret secret
            end
        end
        
        @profiles = @connection.get_reply("/ppp/profile/print")
        @profiles.each do |profile|
            if secret.key?("!re")
                verify_profile profile
            end
        end
    end

    def update_mikrotik
        
    end

    def update_system
        
    end

    def self.verify_secret(secret_hash)
        @name = secret_hash["name"]

        @query = Secret.where(secret: @name)
        if @query.length > 0
            @secret = @query.first

            if @secret.secret != secret_hash["name"]
                Sync.create(table: "Secret", column: "secret", value: @secret.secret, mk_value: secret_hash["name"])
            end
            if @secret.secret_password != secret_hash["password"]
                Sync.create(table: "Secret", column: "secret_password", value: @secret.secret_password, mk_value: secret_hash["password"])
            end
            if !@secret.enabled.to_s != secret_hash["disabled"]
                Sync.create(table: "Secret", column: "enabled", value: @secret.enabled, mk_value: (secret_hash["disabled"] == "false").to_s)
            end
            if @secret.mk_id != secret_hash[".id"]
                Sync.create(table: "Secret", column: "mk_id", value: @secret.secret_password, mk_value: secret_hash[".id"])
            end
        end
    end

    def self.verify_profile(profile_hash)
        @profile = profile_hash["name"]

        @query = Plan.where(profile_name: @profile)
        if @query.length > 0
            @plan = query.first

            if @plan.rate_limit != profile_hash["rate-limit"]
                Sync.create(table: "Plan", column: "rate_limit", value: @plan.rate_limit, mk_value: profile_hash["rate-limit"])
            end
            if @plan.mk_id != profile_hash[".id"]
                Sync.create(table: "Plan", column: "rate_limit", value: @plan.mk_id, mk_value: profile_hash[".id"])
            end
        end
    end
end
