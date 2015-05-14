class Api::BarriersController < Api::BaseController
  skip_before_filter :verify_authenticity_token

  def event
    BARRIER_LOGGER.debug params
    render :json => {:res => "OK", :msg => "OPEN" }
    #render :json => {:res => "FAIL", :msg => "OPEN" }
  end

  def heartbeat
    BARRIER_LOGGER.debug params
    render :json => {:res => "OK",
                     :msg => "",
                     :msg_type => "",
                     :version => "000000001",
                     :time => Time.now.to_i
    }
  end
end
