class EditFinancialController < ApplicationController
  def edit_payment
    @payment = Payment.find(params[:id])
  end

  def confirm_payment
    @payment = params.require(:payment)

    Payment.find(params[:id]).update(remove_mask_for_money())
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
