class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.connect_mikrotik
      return MTik::Connection.new(:host=>"192.168.25.250", :user=>"admin",:pass=>"ALCATRAZ")
  end
end
