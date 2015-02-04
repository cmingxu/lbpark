class Api::UsersController < Api::BaseController
  def create
    redirect_to vendor_index_path
  end
end
