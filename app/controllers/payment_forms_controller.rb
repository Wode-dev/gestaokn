class PaymentFormsController < ApplicationController
  def index
  end

  def update
    PaymentForm.find(params[:id]).update(params.slice(:kind, :place))
  
    redirect_to payment_forms_path
  end

  def create
    PaymentForm.create(params.slice(:kind, :place))

    redirect_to payment_forms_path
  end

  def destroy
    PaymentForm.find(params[:id]).destroy

    redirect_to payment_forms_path
  end
end
