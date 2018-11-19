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
          bill.ref_start,
          "Instalação", 
          bill.due_date, 
          bill.value, 
          bill.note, 
          "#{bill.ref_start}"]
      else

        @finances << [
          bill.due_date,
          "Consumo", 
          bill.due_date, 
          bill.value, 
          bill.note, 
          "#{bill.ref_start} - #{bill.ref_end}"]
      end


    end

    @secret.payments.each do |payment|

      @finances << [
        payment.date,
        "Pagamento", 
        payment.date, 
        payment.value, 
        "#{payment.note}",
        "#{payment.payment_form.kind} - #{payment.payment_form.place}"
      ]
    end

    @finances = @finances.sort_by{|e| Date.today - e[0] }

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
      
      if Secret.mk_create_secret(@secret.secret, @secret.secret_password, "ppp", @secret.plan.profile_name)
        
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

      id = Secret.mk_print_secret(@secret.secret)[".id"]
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

    date = params[:date].split("/")

    Payment.create(
      secret_id: params[:id],
      date: Date.new(date[2].to_i, date[1].to_i, date[0].to_i),
      value: params[:value].to_f,
      payment_form_id: params[:payment_form_id],
      note: params[:note]
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
    
    installation_date = params[:date].split("/")
    due_date = params[:due_date].split("/")
    total = params[:cable].to_f + params[:bail].to_f + params[:router].to_f + params[:other].to_f

    note="#{!params[:bail].empty? ? "Fiança: " + params[:bail] : nil} \r\n #{!params[:cable].empty? ? "Cabo: " + params[:cable] : nil} \r\n #{!params[:router].empty? ? "Roteador: " + params[:router] : nil} \r\n #{!params[:other].empty? ? "Outros: " + params[:other] : nil}"

    Bill.create(
      installation: true,
      secret_id: params[:id],
      ref_start: Date.new(installation_date[2].to_i,installation_date[1].to_i, installation_date[0].to_i),
      due_date: Date.new(due_date[2].to_i,due_date[1].to_i, due_date[0].to_i),
      value: total,
      note: note
      )

    redirect_to params[:fallback]
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
