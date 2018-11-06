class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)

    respond_to do |format|
      if @plan.save

        if mk_create_plan(plan_params["name"], plan_params["rate_limit"])
          
          format.html { redirect_to @plan, notice: 'Plano foi criado com sucesso' }
          format.json { render :show, status: :created, location: @plan }
        else

          format.html { redirect_to plans_path, notice: 'Não foi possível criar o plano' }
        end
      else
        
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    mk = connect_mikrotik
    respond_to do |format|

      
      @plan_old = @plan.as_json # Guarda os parâmetros antigos do registro para retornar caso não consiga mudar no mikrotik
      
      id = mk_print_plan(@plan.profile_name)[0][".id"]
      puts "Id do registro a ser mudado"
      puts id

      if @plan.update(plan_params)
        
        result =  mk_update_plan(id, plan_params["profile_name"], plan_params["rate_limit"])

        @notice = 'Plan was successfully updated.'
        if result
          @notice = "It wasn't possible to update mikrotik"
          @plan.update(@plan_old)
        end

        format.html { redirect_to @plan, notice: @notice }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy

    id = mk_print_plan(@plan.profile_name)[0][".id"]
    if mk_destroy_plan(id)
      
      @plan.destroy
      @notice = "Plan was successfully destroyed."
    else
      @notice = "Plano não foi deletado no mikrotik"
    end

    respond_to do |format|
      format.html { redirect_to plans_url, notice: @notice }
      format.json { head :no_content }
    end
  end

  def check

    mk = connect_mikrotik
    all_plans = mk.get_reply("/ppp/profile/print")

    all_plans.each do |plan|
      Plan.where(profile_name: plan["name"]).length > 0 ? nil : Plan.create(profile_name: plan["name"], rate_limit: plan["rate_limit"])
    end

    redirect_to plans_path
  end

  # MK INTERFACE

  # Retorna boolean
  def mk_create_plan(name, rate_limit)
    
    mk = connect_mikrotik
    @reply = mk.get_reply("/ppp/profile/add",
    "=name=#{plan_params["profile_name"]}",
    "=rate-limit=#{plan_params["rate_limit"]}")

    puts @reply
    return @reply[0]["message"] == nil
  end

  
  # Retorna boolean
  def mk_update_plan(id, name, rate_limit)
    
    mk = connect_mikrotik
    @reply =  mk.get_reply("/ppp/profile/set",
    "=name=#{plan_params["profile_name"]}",
    "=rate-limit=#{plan_params["rate_limit"]}",
    "=.id=#{id}")
    
    puts @reply
    return @reply[0]["message"] == nil
  end

  # Retorna boolean
  def mk_destroy_plan(id)

    mk = connect_mikrotik
    @reply =  mk.get_reply("/ppp/profile/remove",
    "=.id=#{id}")

    puts @reply
    return @reply[0]["message"] == nil
  end

  def mk_print_plan(name)

    mk = connect_mikrotik
    @reply = mk.get_reply("/ppp/profile/print", 
    "?name=#{name}")
    
    puts @reply
    return @reply[0]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:rate_limit, :value, :profile_name)
    end
end
