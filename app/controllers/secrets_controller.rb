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

    mt = connect_mikrotik
    puts mt.get_reply( "/ppp/secret/add",
                  "=name=#{secret_params["secret"]}",
                  "=password=#{secret_params["secret_password"]}",
                  "=profile=#{@secret.plan.profile_name}",
                  "=service=pppoe")

    respond_to do |format|
      if @secret.save
        format.html { redirect_to @secret, notice: 'Secret was successfully created.' }
        format.json { render :show, status: :created, location: @secret }
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

      mk = connect_mikrotik

      id = mk.get_reply("/ppp/secret/print", "?name=#{@secret.secret}")[0][".id"]
      puts mk.get_reply("/ppp/secret/print", "?name=#{@secret.secret}")

      if @secret.update(secret_params)

        result = mk.get_reply("/ppp/secret/set",
        "=name=#{secret_params["secret"]}",
        "=password=#{secret_params["secret_password"]}",
        "=profile=#{Plan.find(secret_params["plan_id"]).profile_name}",
        "=service=pppoe",
        "=.id=#{id}")[0]["message"]

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
    @secret.destroy
    respond_to do |format|
      format.html { redirect_to secrets_url, notice: 'Secret was successfully destroyed.' }
      format.json { head :no_content }
    end
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
