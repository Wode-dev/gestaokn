class MainController < ApplicationController
  def home
    # Cria array com os 6 ultimos meses, depois pega todos os pagamentos recebidos nesse período e coloca no gráfico
    @receipts = []
    @receipts << [Date.today.year, Date.today.month]
    @receipts << [1.month.ago.year, 1.month.ago.month]
    @receipts << [2.month.ago.year, 2.month.ago.month]
    @receipts << [3.month.ago.year, 3.month.ago.month]
    @receipts << [4.month.ago.year, 4.month.ago.month]
    @receipts << [5.month.ago.year, 5.month.ago.month]

    @receipts.each do |receipt|
      #receipt << Payment.where('extract(year from date) = ?', receipt[0]).where('extract(month from date) = ?', receipt[1]).pluck(:value).inject(0){|sum,x| sum + x }
      receipt << Payment.where('cast(strftime(\'%Y\', date) as int) = ?', receipt[0]).where('cast(strftime(\'%m\', date) as int) = ?', receipt[1]).pluck(:value).inject(0){|sum,x| sum + x }
    end
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
