class PendencyJob < ApplicationJob
  queue_as :default

  # Verifica quais usuários estão com pendência de pagamento, e atualiza o status
  def perform(*args)
    
    Secret.all.each do |secret|
      secret.balance

      in_debt = secret.situation < 0

      # Caso o usuário não esteja registrado como atualização automática, o sistema não efetuará bloqueio automático
      if secret.automatic_update
        if in_debt
          secret.update(enabled: false)
        else
          secret.update(enabled: true)
        end
      end
    end

  end
end
