class ProfilesController < ApplicationController
  def show
    @user = Current.user
    @recent_orders = @user.orders.order(created_at: :desc).limit(5)
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if params[:user][:password].blank?
      profile_params_without_password = profile_params.except(:password, :password_confirmation)
      success = @user.update(profile_params_without_password)
    else
      success = @user.update(profile_params)
    end

    if success
      redirect_to profile_path, notice: "Thông tin cá nhân đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end
end
