class Staff::BaseController < ApplicationController
  layout "staff"

  helper_method :current_staff, :current_user

  def current_staff
    @current_staff ||= Staff.find_by_id(session[:staff_id])
  end

  def current_user
    current_staff
  end

  def index
  end
end
