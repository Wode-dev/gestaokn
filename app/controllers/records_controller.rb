class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    # Produz array que levará a seguinte configuração
    # [[data,[instalações]], [data,instalações], ...]
    @records = []
    @dates = Record.all.order(:date).pluck(:date).uniq
    
    @dates.each do |date|
      @date_and_records = [date,[]]
      Record.where(date: date).order(:shift).each do |rec|
        @date_and_records[1] << rec
      end
      @records << @date_and_records
    end

    puts @records
  end

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm
    @rec = Record.find(params[:id])

    @secret = Secret.new(name: @rec.name, address: @rec.address, city: @rec.city, state: @rec.state, neighborhood: @rec.neighborhood, instalation: @rec.date)
  end

  # Cria o secret a partir da instalação, e deleta a instalação automaticamente
  def set_secret_and_instalation
    @secret_params = params.require(:secret).permit(:name, :address, :neighborhood, :doc_name, :doc_value, :secret, :secret_password, :wireless_ssid, :wireless_password, :plan_id, :due_date, :enabled, :instalation, :cable, :bail, :router, :other, :due_to, :id)

    @id = @secret_params.delete(:id).to_i

    @instalation = {}
    @instalation[:date] = @secret_params[:instalation]
    @instalation[:cable] = @secret_params.delete(:cable)
    @instalation[:bail] = @secret_params.delete(:bail)
    @instalation[:router] = @secret_params.delete(:router)
    @instalation[:other] = @secret_params.delete(:other)
    @instalation[:due_date] = @secret_params.delete(:due_to)

    puts @secret_params
    puts @instalation

    @secret = Secret.new(@secret_params)
    if @secret.mk_create_secret
      if @secret.save
        @instalation[:id] = @secret.id

        SecretsController::add_instalation_detail_method(@instalation)
      else
        @secret.mk_destroy_secret
      end
    end

    Record.find(@id).destroy

    redirect_to @secret
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:name, :address, :city, :state, :neighborhood, :phone, :notes, :date)
    end
end
