# Job responsável por verificar os clientes ativos e fechar o mês para esses clientes
class BillJob < ApplicationJob
  queue_as :default

  def perform(*args)
    
    # Caso o cliente esteja em estado de ativo, deverá fechar o faturamento do cliente
    Secret.where(active: true).each do |sct|

      # Ultima fatura do cliente
      @bill = sct.bills.where(ref_end: nil).order(due_date: :desc)
      if @bill.length > 0 && @bill.first.ref_end.nil?

        #fecha fatura aberta
        @value = ((Date.today - @bill.first.ref_start) / (Date.new(@bill.first.ref_start.year,@bill.first.ref_start.month + 1, 5) - Date.new(@bill.first.ref_start.year,@bill.first.ref_start.month, 6))) * sct.plan.value
        @bill.first.update(ref_end: Date.today, value: @value)
        
        # cria nova fatura aberta
        @next_month = 1.month.from_now
        puts @next_month.year
        puts @next_month.month
        puts sct.due_date
        @due_date = Date.new(@next_month.year.to_i, @next_month.month.to_i, sct.due_date.to_i)
        sct.bills << Bill.new(ref_start: Date.today + 1, due_date: @due_date)
      end
    
    end
  end
end
