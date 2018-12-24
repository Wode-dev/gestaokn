class SyncController < ApplicationController

    # verifica entradas no mikrotik e cria as entradas devidas no banco de dados
    # Dados verificados:
    # Profile
    # Secret
    def sync_bring_new
        mk = ApplicationRecord.connect_mikrotik

        all_plans = mk.get_reply("/ppp/profile/print")
        all_plans.each do |plan|
          if Plan.where(profile_name: plan["name"].to_s).length == 0 && plan["name"] != nil
            Plan.create(profile_name: plan["name"], rate_limit: plan["rate-limit"], mk_id: plan[".id"])
          else
            Plan.where(profile_name: plan["name"]).update(mk_id: plan[".id"])
          end
        end
    
        # TODO: adicionar o service e o remote-id no banco de dados quando atualizar
        all_secrets = mk.get_reply("/ppp/secret/print")
        all_secrets.each do |mk_secret|
            if Secret.where(secret: mk_secret["name"]).length <= 0  && mk_secret["name"] != nil
                Secret.create(secret: mk_secret["name"],
                secret_password: mk_secret["password"],
                plan_id: Plan.where(profile_name: mk_secret["profile"]).first.id, mk_id: mk_secret[".id"] )
            else
                Secret.where(secret: mk_secret["name"]).update(mk_id: mk_secret[".id"])
            end
        end

        redirect_to root_path
    end

    def sync_new
        mk = ApplicationRecord.connect_mikrotik

        @all_plans = []
        @all_secrets = []

        mk.get_reply("/ppp/profile/print").each do |profile|
            if profile.key?("name") && Plan.where(profile_name: profile["name"].to_s).length == 0
                @all_plans << profile
            end
        end
        puts @all_plans
        mk.get_reply("/ppp/secret/print").each do |secret|
            if secret.key?("name") && Secret.where(secret: secret["name"].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')).length <= 0
                @all_secrets << secret
            end
        end
        puts @all_secrets
    end
    

    def selective_sync
        @ontime = true
        if Sync.count != 0
            @ontime = DateTime.now - 5.minutes > Sync.last.created_at
        end
        if @ontime
            Sync.sync_mikrotik_and_system
        end
    end

    def update_mikrotik_selective
        Sync.find(params["id"]).update_mikrotik

        redirect_to sync_selective_path
    end

    def update_system_selective
        Sync.find(params["id"]).update_system

        redirect_to sync_selective_path
    end
    
    
end
