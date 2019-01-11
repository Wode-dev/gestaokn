# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  layout 'devise.html.erb'
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def save_users
    @params = params.permit(:id, :name, :email, :nick_name, :password, :password_confirmation, :manager, :manager_id)
    
    if User.find(@params[:manager_id]).manager
      @user = User.where(email: @params[:email]).first_or_initialize
      
      if @user.id.nil? && @params[:password] == @params[:password_confirmation]
        @user.name = @params[:name]
        @user.nick_name = @params[:nick_name]
        @user.password = @params[:password]
        @params[:manager].nil? ? @user.manager = false : @user.manager = @params[:manager]
      elsif @params[:password] == ''
        @user.name = @params[:name]
        @user.nick_name = @params[:nick_name]
        @params[:manager].nil? ? @user.manager = User.find(@params[:id]).manager : @user.manager = @params[:manager]
      elsif !@user.id.nil? && @params[:password] != ''
        @user.name = @params[:name]
        @user.nick_name = @params[:nick_name]
        @user.password = @params[:password]
        @params[:manager].nil? ? @user.manager = User.find(@params[:id]).manager : @user.manager = @params[:manager]
      end

      @user.save
    end

    puts @user.errors.messages

    redirect_to users_administration_path
  end
end
