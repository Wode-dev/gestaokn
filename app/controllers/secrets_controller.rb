class SecretsController < ApplicationController
  before_action :set_secret, only: [:show, :edit, :update, :destroy]

  # GET /secrets
  # GET /secrets.json
  def index
    @secrets = Secret.all
  end

  # GET /secrets/1
  # GET /secrets/1.json
  def show
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
      
      if mk_create_secret(@secret.secret, @secret.secret_password, "ppp", @secret.plan.profile_name)
        
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

      id = mk_print_secret(@secret.secret)[0][".id"]
      puts "O id é:" + id

      if @secret.update(secret_params)

        result = mk_update_secret(id, @secret.secret, @secret.secret_password, "ppp", @secret.plan.profile_name)

        puts result

        @notice = 'Secret was successfully updated.'
        if result != nil
          @notice = "It wasn't possible to update mikrotik"
          @secret.update(@secret_old)
        end

        format.html { redirect_to @secret, notice: 'Secret was successfully updated.' }
        format.json { render :show, status: :ok, location: @secret }
      else
        format.html { render :edit }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secrets/1
  # DELETE /secrets/1.json
  def destroy

    if mk_destroy_secret(mk_print_secret(@secret.secret)[".id"])

      @secret.destroy
   
      respond_to do |format|
        format.html { redirect_to secrets_url, notice: 'Secret was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # Retorna boolean
  def mk_create_secret(name, password, service, profile)
  
    mk = connect_mikrotik
    @reply = mk.get_reply("/ppp/secret/add",
    "=name=#{name}",
    "=password=#{password}",
    "=profile=#{profile}",
    "=service=#{service}")

    puts @reply
    return @reply[0]["message"] == nil
  end

  
  # Retorna boolean
  def mk_update_secret(id, name, password, service, profile)
    
    mk = connect_mikrotik
    @reply =  mk.get_reply("/ppp/secret/set",
    "=name=#{name}",
    "=password=#{password}",
    "=profile=#{profile}",
    "=service=#{service}",
    "=.id=#{id}")
    
    puts @reply
    return @reply[0]["message"] == nil
  end

  # Retorna boolean
  def mk_destroy_secret(id)

    mk = connect_mikrotik
    @reply =  mk.get_reply("/ppp/secret/remove",
    "=.id=#{id}")

    puts @reply
    return @reply[0]["message"] == nil
  end

  def mk_print_secret(name)

    mk = connect_mikrotik
    @reply = mk.get_reply("/ppp/secret/print", 
    "?name=#{name}")
    
    puts @reply
    return @reply[0]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secret
      @secret = Secret.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secret_params
      params.require(:secret).permit(:name, :address, :city, :state, :neighborhood, :doc_name, :doc_value, :secret, :secret_password, :wireless_ssid, :wireless_password, :due_date, :plan_id)
    end
end
