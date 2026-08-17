
class Admin::BaseController < ApplicationController
  before_action :require_admin
  layout "admin"
  private

  def require_admin
    unless authenticated? && Current.user.admin?
      redirect_to root_path, alert: "Bạn không có quyền truy cập trang quản trị."
    end
  end
end
