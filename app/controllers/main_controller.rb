class MainController < ApplicationController
  def home
  end

  def settings
    
  end

  def save_settings
    @settings = params.permit(:mk_ip, :mk_user, :mk_password)

    Setting.insert(:mk_ip, @settings[:mk_ip])
    Setting.insert(:mk_user, @settings[:mk_user])
    Setting.insert(:mk_password, @settings[:mk_password])

    redirect_to settings_path
  end

  def test_mikrotik_connection
    @connection = true
    begin
      puts MTik::Connection.new(:host=>params[:ip], :user=>params[:user],:pass=>params[:password])
    rescue Errno::ETIMEDOUT, Errno::ENETUNREACH, Errno::EHOSTUNREACH => e
      @connection = false
    end
    

    render json: {connection: @connection}
  end
  
  
  
end
