class SignUpsController < ApplicationController
  # Chỉ cho phép người chưa đăng nhập truy cập
  unauthenticated_access_only

  # Giới hạn số lần đăng ký để chống spam
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to sign_up_path, alert: "Bạn thao tác quá nhanh. Vui lòng thử lại sau." }

  def show
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)

    if @user.save
      start_new_session_for(@user)   # Tự động đăng nhập sau khi đăng ký
      redirect_to root_path, notice: "Đăng ký thành công! Chào mừng bạn."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end
end
