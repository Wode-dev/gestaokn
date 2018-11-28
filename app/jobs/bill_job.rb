# Job responsável por verificar os clientes ativos e fechar o mês para esses clientes
class BillJob < ApplicationJob
  queue_as :default

  def perform(*args)
    
    # Caso o cliente esteja em estado de ativo, deverá fechar o faturamento do cliente
    Secret.where(active: true).each do |secret|
      secret.close_last_open_bill
    end
  end
end
