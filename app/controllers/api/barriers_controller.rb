class Api::BarriersController < Api::BaseController
  skip_before_filter :verify_authenticity_token

  def event
    BARRIER_LOGGER.debug params
    if rand(10) < 4
      render :json => {:res => "OK", :msg => "OPEN" }
    else
      render :json => {:res => "FAIL", :msg => "非包月用户" }
    end
  end

  def heartbeat
    BARRIER_LOGGER.debug params
    if rand(10) < 3
      render :json => {
        :res => "OK",
        :msg => "",
        :msg_type => "",
        :time => Time.now.to_i
      }
    else
      render :json => {
        :res => "OK",
        :msg => {"version" => 0001, "latest_infos" => [{"paizhao" => "京A00012", "begin_at" => Time.now.to_i , "end_at" => Time.now.to_i + 1000},
                                                        {"paizhao" => "京CA00012", "begin_at" => Time.now.to_i + 1000, "end_at" => Time.now.to_i + 20000} ]},
        :msg_type => "info_sync",
        :time => Time.now.to_i
      }
    end
  end
end
