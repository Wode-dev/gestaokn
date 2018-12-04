class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.connect_mikrotik
      return MTik::Connection.new(:host=>Setting.get(:mk_ip), :user=>Setting.get(:mk_user),:pass=>Setting.get(:mk_password))
  end
end
