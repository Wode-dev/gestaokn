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
    end

    after_create do

      self.update(mk_id: self.mk_print_secret[".id"])

    end

    # Soma todos os pagamentos e subtrai por todos os débtos
    def balance
      
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
          if @due_date > Date.today
            "Regular"
          elsif @due_date == Date.today
            "Vencimento hoje" 
          else
            puts @due_date - Date.today
            "Em Aberto"
          end
        else
          
          "Vazio"
        end
      end
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

    # Verifica se o cliente está em débito
    def is_in_debt?

      self.bills.where(payment_date: nil).each do |bill|

          return Date.today > bill.due_date + 5
      end

      return false
    end

  # Retorna boolean
  def self.mk_create_secret(name, password, service, profile)
  
    mk = Secret.connect_mikrotik
    @reply = mk.get_reply("/ppp/secret/add",
    "=name=#{name}",
    "=password=#{password}",
    "=profile=#{profile}",
    "=service=#{service}")

    puts @reply
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
