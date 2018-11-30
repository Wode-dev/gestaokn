class Secret < ApplicationRecord
    belongs_to :plan
    has_many :bills
    has_many :payments

    before_update do

        if enabled_changed?
            mk = Secret.connect_mikrotik
            
            enabled = self.enabled
            # puts mk.get_reply("/ppp/secret/set",
            #     "=disabled=#{enabled ? "no" : "yes"}",
            #     "=.id=#{mk.get_reply("/ppp/secret/print", 
            #     "?name=#{self.secret}")[0][".id"]}")
            
            if enabled
              comment = "#{self.mk_print_secret["comment"].split("///")[0]}".strip
            else
              comment = "#{self.mk_print_secret["comment"]} /// Bloq.: #{Time.new}"
            end

            puts mk.get_reply("/ppp/secret/set",
            "=disabled=#{enabled ? "no" : "yes"}",
            "=comment=#{comment}",
            "=.id=#{self.mk_id}")
            
            if !enabled
              
              mk_drop_connection
            end
        end
        # Na mudança de plano, deve-se fechar a ultima fatura com o plano antigo, e então abrir uma nova com o novo plano
        # Quando o plano for fechado na data de fechamento normal, será considerado o valor do plano novo
        puts "before_update"
        puts self.bills.where(ref_end: Date.today - 1).length
        puts plan_id_changed?
        puts !situation_changed?
        if plan_id_changed? && !situation_changed?
          close_last_open_bill(plan_id_was)
        end
    end

    after_create do

      self.update(mk_id: self.mk_print_secret[".id"])

    end

    # Soma todos os pagamentos e subtrai por todos os débtos
    def balance
      
      puts "balance"
      cred = self.payments.pluck(:value).inject(0){|sum, x| sum + x }
      debt = self.bills.pluck(:value).inject(0){|sum, x| sum + x }

      self.update(situation: (cred - debt))
    end

    # Com base no "balance" define a situação do cliente.
    def situation_status
      
      @value = self.situation

      if @value > 0
        "Com Crédito"
      elsif @value == 0
        "Regular"
      else

        if self.bills.length > 0

          @due_date = self.bills.order(due_date: :desc).first.due_date
          if @due_date >= Date.today
            "Regular"
          else
            puts @due_date - Date.today
            "Em Aberto"
          end
        else
          
          "Vazio"
        end
      end
    end

    def self.clients_by_due_date(due_date)
      # 0 -> quantidade
      # 1 -> porcentagem
      @answer = [0,0]
      if !due_date.nil?
        @answer[0] = Secret.where(due_date: due_date).count
        @answer[1] = (Secret.where(due_date: due_date).count * 100 / Secret.count)
      end

      @answer
    end

    # Verifica quais usuários estão em débito
    # Desativa o usuário se estiver em atualização automática
    def self.verify

      Secret.all.each do |secret|
        if secret.automatic_update

          if secret.is_in_debt?

            secret.update(enabled: false)
          else

            secret.update(enabled: true)
          end
        end
      end
    end

    def close_last_open_bill(plan_id = self.plan_id)
      if self.active
        # busca todas as "bills" que ainda não tem data de fechamento e ordena de maneira descrescente de acordo com a data de vencimento
        @open_bills = self.bills.where(ref_end: nil).order(due_date: :desc)
        @open_bill = @open_bills.first

        if !@open_bill.nil? && @open_bills.length > 0 && @open_bill.ref_end.nil?
          @open_bills.first.close(plan_id)
        end

        if Date.today >= 6
          @due_date = Date.new((Date.today + 1.month).year, (Date.today + 1.month).month, self.due_date.to_i )
        else
          @due_date = Date.new((Date.today).year, (Date.today).month, self.due_date.to_i )
        end
        Bill.create(secret_id: self.id ,ref_start: Date.today, due_date: @due_date)

      end
    end

    # Método para bloquear ou desbloquear secret
    def enabled_change(status)
      if self.active
        self.update(enabled: status)
      else
        self.update(enabled: false)
      end
    end

  def self.mk_create_secret(name, password, service, profile)
  
    mk = Secret.connect_mikrotik
    @reply = mk.get_reply("/ppp/secret/add",
    "=name=#{name}",
    "=password=#{password}",
    "=profile=#{profile}",
    "=service=#{service}")

    return @reply[0]["message"] == nil
  end

  
  # Retorna boolean
  def self.mk_update_secret(id, name, password, service, profile)
    
    mk = Secret.connect_mikrotik
    @reply =  mk.get_reply("/ppp/secret/set",
    "=name=#{name}",
    "=password=#{password}",
    "=profile=#{profile}",
    "=service=#{service}",
    "=.id=#{id}")
    
    puts @reply
    return @reply[0]["message"] == nil
  end

  # Retorna boolean
  def self.mk_destroy_secret(id)

    mk = Secret.connect_mikrotik
    @reply =  mk.get_reply("/ppp/secret/remove",
    "=.id=#{id}")

    puts @reply
    return @reply[0]["message"] == nil
  end

  def mk_print_secret()

    mk = Secret.connect_mikrotik
    @reply = mk.get_reply("/ppp/secret/print", 
    "?name=#{self.secret}")
    
    puts @reply
    return @reply[0]
  end

  def mk_drop_connection
    
    mk = Secret.connect_mikrotik

    id = mk.get_reply("/ppp/active/print",
    "?name=#{self.secret}")[0][".id"]
    returned = mk.get_reply("/ppp/active/remove",
    "=.id=#{id}")
    return returned[0]["message"] == nil
  end
end
