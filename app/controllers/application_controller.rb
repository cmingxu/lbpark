class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_vendor

  def current_vendor
    #@vendor_user = @vendor_user || User.vendors.find_by_id(session[:vendor_id])
    @vendor_user = User.first
  end
end
