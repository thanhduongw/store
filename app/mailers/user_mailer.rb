class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email_address, subject: "Chào mừng bạn đến với Store!")
  end

  def order_confirmation(order)
    @order = order
    recipient = order.user&.email_address || order.email
    mail(to: recipient, subject: "Xác nhận đơn hàng ##{order.id} – Store")
  end
end
