class SyncController < ApplicationController

    # verifica entradas no mikrotik e cria as entradas devidas no banco de dados
    # Dados verificados:
    # Profile
    # Secret
    def sync_partial
        mk = connect_mikrotik

        all_plans = mk.get_reply("/ppp/profile/print")
        all_plans.each do |plan|
          Plan.where(profile_name: plan["name"]).length > 0 ? nil : Plan.create(profile_name: plan["name"], rate_limit: plan["rate_limit"])
        end
    
        # TODO: adicionar o service e o remote-id no banco de dados quando atualizar
        all_secrets = mk.get_reply("/ppp/secret/print")
        all_secrets.each do |mk_secret|
            if Secret.where(secret: mk_secret["name"]).length <= 0 
                Secret.create(secret: mk_secret["name"],
                secret_password: mk_secret["password"],
                plan_id: Plan.where(profile_name: mk_secret["profile"]).first.id )
            end
        end
    end
end
