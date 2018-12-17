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
    @install = Bill.find(params[:id])
  end

  def confirm_install
    @install = Bill.find(params[:id])
    @secret = @install.secret
    @install_form = params.slice(:cable, :bail, :router, :other, :date, :due_date)
    # O "id" do secret precisa ir na hash para o método seguinte funcionar
    @install_form[:id] = @secret.id

    @created = !SecretsController::add_instalation_detail_method(@install_form).errors.any?

    if @created
      @install.destroy
      redirect_to @secret
    end
  end

  def destroy_payment
    @secret = Payment.find(params[:id]).secret
    Payment.find(params[:id]).destroy

    redirect_to @secret
  end

  def destroy_bill
    @secret = Bill.find(params[:id]).secret
    Bill.find(params[:id]).destroy

    redirect_to @secret
  end
  
  
end
