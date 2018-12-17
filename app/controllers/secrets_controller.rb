class SecretsController < ApplicationController
  before_action :set_secret, only: [:show, :edit, :update, :destroy]

  # GET /secrets
  # GET /secrets.json
  def index
    @secrets = Secret.all
  end

  # GET /secrets/1
  # GET /secrets/1.json
  # Dentro do método show é passado um objeto com os dados pra serem atualizados na aba do financeiro
  def show

    # Financeiro_legenda = [
    #   [
    #   "Tipo de entrada (Instalação, Consumo, Pagamento, Bloqueio)"
    #   "Data de vencimento, Data de pagamento",
    #   "Valor",
    #   "Notas",
    #   "data de consumo ou forma de pagamento"
    #   ]
    # ]

    @finances = []

    @secret.bills.each do |bill|
      
      if bill.installation

        
        @finances << [
          bill.ref_start.strftime("%d/%m/%Y"),
          "Instalação", 
          bill.due_date.strftime("%d/%m/%Y"), 
          bill.value, 
          bill.note, 
          "#{bill.ref_start.strftime("%d/%m/%Y")}",
          edit_install_path(id: bill.id)
        ]
      else

        @finances << [
          bill.due_date.strftime("%d/%m/%Y"),
          "Consumo", 
          bill.due_date.strftime("%d/%m/%Y"), 
          bill.value, 
          bill.note, 
          "#{!bill.ref_start.nil? ? bill.ref_start.strftime("%d/%m/%Y") : nil} - #{!bill.ref_end.nil? ? bill.ref_end.strftime("%d/%m/%Y") : nil}",
          edit_bill_path(id: bill.id)
        ]
      end


    end

    @secret.payments.each do |payment|

      @finances << [
        payment.date.strftime("%d/%m/%Y"),
        "Pagamento", 
        payment.date.strftime("%d/%m/%Y"), 
        payment.value, 
        "#{payment.note}",
        "#{payment.payment_form.kind} - #{payment.payment_form.place}",
        edit_payment_path(id: payment.id)
      ]
    end

    @finances = @finances.sort_by{|e| Date.today - Date.strptime(e[0],"%d/%m/%Y") }

    @classes = Hash.new
    @classes["Instalação"] = "text-primary"
    @classes["Consumo"] = "text-warning"
    @classes["Pagamento"]= "text-success"
  end

  # GET /secrets/new
  def new
    @secret = Secret.new
  end

  # GET /secrets/1/edit
  def edit
  end

  # POST /secrets
  # POST /secrets.json
  def create
    @secret = Secret.new(secret_params)

    respond_to do |format|
      
      if @secret.mk_create_secret
        
        if @secret.save

          format.html { redirect_to @secret, notice: 'Secret was successfully created.' }
          format.json { render :show, status: :created, location: @secret }

        end
      else

        format.html { render :new }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secrets/1
  # PATCH/PUT /secrets/1.json
  def update

    @secret_old = @secret.as_json

    respond_to do |format|

      id = @secret.mk_print_secret[".id"]
      puts "O id é:" + id

      if Secret.mk_update_secret(id, @secret.secret, @secret.secret_password, "ppp", @secret.plan.profile_name)

        if @secret.update(secret_params)
        
          format.html { redirect_to @secret, notice: 'Secret was successfully updated.' }
          format.json { render :show, status: :ok, location: @secret }
        else

          format.html { render :edit }
          format.json { render json: @secret.errors, status: :unprocessable_entity }
        end


      else
        format.html { render :edit }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secrets/1
  # DELETE /secrets/1.json
  def destroy

    if Secret.mk_destroy_secret(@secret.mk_id)

      @secret.destroy
   
      respond_to do |format|
        format.html { redirect_to secrets_url, notice: 'Secret was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  #Registra um pagamento para um determinado cliente
  def payment

    Payment.create(
      secret_id: params[:id],
      date: Date.strptime(params[:date], "%d/%m/%Y"),
      value: params[:value].gsub(".", "").gsub(",",".").to_f,
      payment_form_id: params[:payment_form_id],
      note: params[:note]
      )

      redirect_to params[:fallback]
  end

  def bill
    Bill.create(
      secret_id: params[:id],
      ref_start: Date.strptime(params[:ref_start], "%d/%m/%Y"),
      ref_end: Date.strptime(params[:ref_end], "%d/%m/%Y"),
      value: params[:value].gsub(".", "").gsub(",",".").to_f,
      note: params[:note],
      due_date: Date.strptime(params[:due_date], "%d/%m/%Y")
    )

    redirect_to params[:fallback]
  end
  

  # Inverte o estado do usuário entre bloqueado e desbloqueado
  def switch_secret
    
    parameter = params.permit(:secret_id, :state)

    @user = Secret.find(parameter[:secret_id])
    if @user.update(enabled: parameter[:state])

      
        #head :accepted 
        render json: {state: parameter[:state]}
    else

        #head :not_acceptable
        render json: {state: @user.enabled}
    end
  end

  # Adiciona informações da instalação para aqueles que ainda não estão cadastrados
  def add_instalation_detail
    
    SecretsController::add_instalation_detail_method params

    redirect_to params[:fallback]
  end

  # Método que não é rota para manter o padrão de adição de informações de instalação nos secrets e no record (instalação)
  def self.add_instalation_detail_method(params = {})
    total = params[:cable].to_f + params[:bail].to_f + params[:router].to_f + params[:other].to_f

    note="#{!params[:bail].empty? ? "Fiança: " + ActionController::Base.helpers.number_to_currency(params[:bail], unit:"R$") : nil} \r\n #{!params[:cable].empty? ? "Cabo: " + ActionController::Base.helpers.number_to_currency(params[:cable], unit:"R$") : nil} \r\n #{!params[:router].empty? ? "Roteador: " + ActionController::Base.helpers.number_to_currency(params[:router], unit:"R$") : nil} \r\n #{!params[:other].empty? ? "Outros: " + ActionController::Base.helpers.number_to_currency(params[:other], unit:"R$") : nil}"

    return Bill.create(
      installation: true,
      secret_id: params[:id],
      ref_start: Date.strptime(params[:date], "%d/%m/%Y"),
      ref_end: Date.strptime(params[:date], "%d/%m/%Y"),
      due_date: Date.strptime(params[:due_date], "%d/%m/%Y"),
      value: total,
      note: note
      )
  end
  

  def commit_note
    @data = params.permit(:id, :r_id, :description)

    if @data[:r_id].nil?
      Relationship.create(secret_id: @data[:id], description: @data[:description])
    else
      Relationship.find(@data[:r_id]).update(description: @data[:description])
    end

    redirect_to secret_path(Secret.find(@data[:id]))
  end

  def edit_note
    @relationship = Relationship.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secret
      @secret = Secret.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secret_params
      params.require(:secret).permit(:name, :address, :city, :state, :neighborhood, :doc_name, :doc_value, :secret, :secret_password, :wireless_ssid, :wireless_password, :due_date, :plan_id, :enabled)
    end
end
