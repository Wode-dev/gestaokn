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
            if profile.key?("!re")
                verify_profile profile
            end
        end
    end

    def update_mikrotik
        @mk = ApplicationRecord.connect_mikrotik

        @item = ""
        @value = self.value
        @search = "=.id=#{self.mk_id}"

        case self.table
        when "Secret"
            
            case self.column
            when "secret"
                @item = "name"
            when "secret_password"
                @item = "password"
            when "enabled"
                @item = "disabled"
            when "mk_id"
                @item = ".id"
            end
            puts @mk.get_reply("/ppp/secret/set",
                "=#{@item}=#{@value}",
                @search)
        
        when "Plan"
            
            case self.column
            when "rate_limit"
                @item = "rate-limit"
            when "mk_id"
                @item = ".id"
            end
            puts @mk.get_reply("/ppp/profile/set",
                "=#{@item}=#{@value}",
                @search)
        end
        puts @item

        self.destroy
    end

    def update_system
        hash = {}
        hash[self.column] = self.mk_value
        if self.table == "Secret"
            Secret.find(self.table_id).update(hash)
        elsif self.table == "Plan"
            Plan.find(self.table_id).update(hash)
        end

        self.destroy
    end

    def self.verify_secret(secret_hash)
        @table = "Secret"

        @name = secret_hash["name"]
        @name.force_encoding('UTF-8')

        @query = Secret.where(secret: @name)
        if @query.length > 0
            @secret = @query.first

            if @secret.secret != secret_hash["name"]
                Sync.create(table: @table, column: "secret", value: @secret.secret, mk_value: secret_hash["name"], table_id: @secret.id, mk_id: secret_hash[".id"])
            end
            if @secret.secret_password != secret_hash["password"]
                Sync.create(table: @table, column: "secret_password", value: @secret.secret_password, mk_value: secret_hash["password"], table_id: @secret.id, mk_id: secret_hash[".id"])
            end
            if !@secret.enabled != (secret_hash["disabled"] == "true")
                Sync.create(table: @table, column: "enabled", value: @secret.enabled, mk_value: (secret_hash["disabled"] == "false").to_s, table_id: @secret.id, mk_id: secret_hash[".id"])
            end
            if @secret.mk_id != secret_hash[".id"]
                Sync.create(table: @table, column: "mk_id", value: @secret.secret_password, mk_value: secret_hash[".id"], table_id: @secret.id, mk_id: secret_hash[".id"])
            end
        end
    end

    def self.verify_profile(profile_hash)
        @table = "Plan"
        
        @profile = profile_hash["name"]
        @profile.force_encoding('UTF-8')

        @query = Plan.where(profile_name: @profile)
        if @query.length > 0
            @plan = @query.first

            if @plan.rate_limit != profile_hash["rate-limit"]
                Sync.create(table: @table, column: "rate_limit", value: @plan.rate_limit, mk_value: profile_hash["rate-limit"], table_id: @plan.id, mk_id: profile_hash[".id"])
            end
            if @plan.mk_id != profile_hash[".id"]
                Sync.create(table: @table, column: "mk_id", value: @plan.mk_id, mk_value: profile_hash[".id"], table_id: @plan.id, mk_id: profile_hash[".id"])
            end
        end
    end
end
