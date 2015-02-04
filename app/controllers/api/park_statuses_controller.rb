class Api::ParkStatusesController < Api::BaseController
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    @park_status = current_vendor.park_statuses.build
    @park_status.status = params[:status]
    @park_status.park = current_vendor.park

    respond_to do |format|
      format.js do
        if @park_status.save
          head :ok
        else
          rendor :nothing, :status => 402
        end
      end
    end
  end
end
