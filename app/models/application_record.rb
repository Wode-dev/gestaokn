class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.connect_mikrotik
      return MTik::Connection.new(:host=>"177.136.34.190", :user=>"admin",:pass=>"ALCATRAZ")
  end
end
