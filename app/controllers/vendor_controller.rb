class VendorController < ApplicationController
  layout "vendor"
  #before_filter :current_vendor_required, :only => [:index, :lottory, :mine]

  def index
  end

  def lottory
  end

  def mine
  end

  def login
  end

  def current_vendor_required
    unless current_vendor
      redirect_to vendor_login_path, :notice => "请先登录"
      return
    end
  end

end
