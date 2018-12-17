class EditFinancialController < ApplicationController
  def edit_payment
    @payment = Payment.find(params[:id])
  end

  def confirm_payment
    @payment_form = params.require(:payment).permit(:date, :value, :payment_form_id, :note)

    @payment = Payment.find(params[:id])
    @payment.update(remove_mask_for_money(@payment_form, "value"))

    redirect_to @payment.secret
  end

  def edit_bill
    @bill = Bill.find(params[:id])
  end

  def confirm_bill
    @bill_form = params.require(:bill).permit(:due_date, :ref_start, :ref_end, :value, :note)

    @bill = Bill.find(params[:id])
    @bill.update(remove_mask_for_money(@bill_form, "value"))

    redirect_to @bill.secret
  end

  def edit_install
  end

  def confirm_install
  end
end
