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
      if Plan.mk_create_plan(@plan.profile_name, @plan.rate_limit)

        if @plan.save

          #@plan.update(mk_id: Plan.mk_print_plan(@plan.profile_name)[".id"])
          
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
    mk = ApplicationRecord.connect_mikrotik
    respond_to do |format|

      
      @plan_old = @plan.as_json # Guarda os parâmetros antigos do registro para retornar caso não consiga mudar no mikrotik
      
      id = Plan.mk_print_plan(@plan.profile_name)[".id"]
      puts "Id do registro a ser mudado"
      puts id

      if @plan.update(plan_params)
        
        result =  Plan.mk_update_plan(id, plan_params["profile_name"], plan_params["rate_limit"])

        
        if result
          @notice = 'Plan was successfully updated.'
        else
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

    id = Plan.mk_print_plan(@plan.profile_name)[".id"]
    if Plan.mk_destroy_plan(id)
      
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

    mk = ApplicationRecord.connect_mikrotik
    all_plans = mk.get_reply("/ppp/profile/print")

    all_plans.each do |plan|
      Plan.where(profile_name: plan["name"]).length > 0 ? nil : Plan.create(profile_name: plan["name"], rate_limit: plan["rate_limit"])
    end

    redirect_to plans_path
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
