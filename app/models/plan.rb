class Plan < ApplicationRecord

  has_many :secrets
  # MK INTERFACE

  after_create do
    
    self.update(mk_id: Plan.mk_print_plan(self.profile_name)[".id"])

  end

  # Retorna boolean
  def self.mk_create_plan(name, rate_limit)
    
    mk = connect_mikrotik
    @reply = mk.get_reply("/ppp/profile/add",
    "=name=#{name}",
    "=rate-limit=#{rate_limit}")

    puts @reply
    return @reply[0]["message"] == nil
  end

  
  # Retorna boolean
  def self.mk_update_plan(id, name, rate_limit)
    
    mk = connect_mikrotik
    @reply =  mk.get_reply("/ppp/profile/set",
    "=name=#{name}",
    "=rate-limit=#{rate_limit}",
    "=.id=#{id}")
    
    puts @reply
    return @reply[0]["message"] == nil
  end

  # Retorna boolean
  def self.mk_destroy_plan(id)

    mk = connect_mikrotik
    @reply =  mk.get_reply("/ppp/profile/remove",
    "=.id=#{id}")

    puts @reply
    return @reply[0]["message"] == nil
  end

  def self.mk_print_plan(name)

    mk = connect_mikrotik
    @reply = mk.get_reply("/ppp/profile/print", 
    "?name=#{name}")
    
    puts @reply
    return @reply[0]
  end
end
