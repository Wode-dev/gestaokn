class PaymentFormsController < ApplicationController
  def index
  end

  def update
    @params = params.permit(:id, :kind, :place)
    PaymentForm.find(@params[:id].to_i).update(@params.slice(:kind, :place))
  
    redirect_to payment_forms_path
  end

  def create
    @params = params.permit(:kind, :place)
    PaymentForm.create(@params.slice(:kind, :place))

    redirect_to payment_forms_path
  end

  def destroy
    @params = params.permit(:id)
    PaymentForm.find(@params[:id]).destroy

    redirect_to payment_forms_path
  end
end
