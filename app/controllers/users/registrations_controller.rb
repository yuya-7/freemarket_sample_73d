# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    unless params[:birthday]["date_of_birth(1i)"].present? && params[:birthday]["date_of_birth(2i)"].present? && params[:birthday]["date_of_birth(3i)"].present?
      flash.now[:alert] = "入力されていない項目があります"
      render :new and return
    end
    @user.date_of_birth = Date.new(params[:birthday]["date_of_birth(1i)"].to_i, params[:birthday]["date_of_birth(2i)"].to_i, params[:birthday]["date_of_birth(3i)"].to_i)
    unless @user.valid?
      render :new and return
    end
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    @address = @user.build_address
    render :new_address
  end

  def create_address
    @user = User.new(session["devise.regist_data"]["user"])
    @address = Address.new(address_params)
    unless @address.valid?
      flash.now[:alert] = @address.errors.full_messages
      render :new_address and return
    end
    @user.build_address(@address.attributes)
    @user.save
    session["devise.regist_data"]["user"].clear
    sign_in(:user, @user)
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # def destroy
  #   super
  # end

  def show
    @user = User.find_by(id: current_user.id)
    @address = Address.find_by(user_id: current_user.id)
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

protected

  def address_params
    params.require(:address).permit(:ship_last_name, :ship_first_name, :ship_last_name_kana, :ship_first_name_kana, :postcode, :prefecture, :city, :block, :building, :ship_phone_number)
  end

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
end
