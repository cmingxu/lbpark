class Api::BarriersController < Api::BaseController
  skip_before_filter :verify_authenticity_token
  before_filter do
    @gate = Gate.find_by!(:serial_num => params[:id])
    @client = @gate.client
  end

  def event
    BARRIER_LOGGER.debug params
    @client_member = @client.client_members.find_by(:paizhao => params[:paizhao])

    ge = @client.gate_events.create do |ge|
      ge.gate = @gate
      ge.park_id = @gate.park_id
      ge.paizhao = params[:paizhao]
      ge.delay = false
      ge.happen_at = Time.now
    end

    if @client_member.blank?
      render :json => {:res => "FAIL", :msg => "非包月用户" }
      ge.is_allowed = false
      ge.save
      return
    end
    if @client_member.membership_valid?
      ge.is_allowed = true
      ge.save
      render :json => {:res => "OK", :msg => "OPEN" }
    else
      ge.is_allowed = false
      ge.save
      render :json => {:res => "FAIL", :msg => "会员过期" }
    end
  end

  def heartbeat
    BARRIER_LOGGER.debug params

    res = {
      :res => "OK",
      :time => Time.now.to_i
    }

    @gate.update_column :last_heartbeat_seen_at, Time.now

    if params[:info_sync]
      params[:info_sync].each do |info|
        @client.gate_events.create do |ge|
          ge.gate = @gate
          ge.park_id = @gate.park_id
          ge.paizhao = info[:paizhao]
          ge.delay = true
          ge.happen_at = info[:time]
        end
      end

      client_latest_version = @client.latest_version
      if params[:version].to_i < client_latest_version.to_i
        res[:msg_type] = "info_sync"
        res[:msg] = { :version => client_latest_version, :latest_infos => JSON.parse(@client.latest_client_members) }
      end

      render :json => res
    end
  end
end
