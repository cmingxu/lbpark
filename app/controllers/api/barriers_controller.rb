class Api::BarriersController < Api::BaseController
  skip_before_filter :verify_authenticity_token

  def event
    BARRIER_LOGGER.debug params[:req]
    render :json => {:res => "OK", :op => "OPEN" }
  end

  def heartbeat
    BARRIER_LOGGER.debug params[:req]
    render :json => {:res => "OK"}
  end
end
