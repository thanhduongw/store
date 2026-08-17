class SignUpsController < ApplicationController
  # Nếu trong Authentication concern bạn có method `unauthenticated_access_only` thì giữ nguyên.
  # Nếu KHÔNG có, hãy thay bằng 2 dòng sau:
  # allow_unauthenticated_access
  # before_action :redirect_if_authenticated, if: :authenticated?

  unauthenticated_access_only

  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to sign_up_path, alert: "Bạn thao tác quá nhanh. Vui lòng thử lại sau." }

  def show
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)

    if @user.save
      start_new_session_for(@user)
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
