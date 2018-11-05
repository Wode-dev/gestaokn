class ApplicationController < ActionController::Base


    def connect_mikrotik
        return MTik::Connection.new(:host=>"177.136.34.190", :user=>"admin",:pass=>"ALCATRAZ")
    end

end
