class EditFinancialController < ApplicationController
  def edit_payment
    @payment = Payment.find(params[:id])
  end

  def confirm_payment
    @payment = params.require(:payment).permit(:date, :value, :payment_form_id, :note)

    @payment = Payment.find(params[:id])
    @payment.update(remove_mask_for_money(@payment, "value"))

    redirect_to @payment.secret
  end

  def edit_bill
  end

  def confirm_bill
  end

  def edit_install
  end

  def confirm_install
  end
end
