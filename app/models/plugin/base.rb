class Plugin::Base
  delegate :url_helpers, to: 'Rails.application.routes' 

  attr_accessor :displayable_name, :internal_identifier, :client
  attr_accessor :fa_icon, :link

  def initialize(client)
    @client = client
  end
end

require 'plugin/free_coupon'
require 'plugin/monthly_coupon'
require 'plugin/quarterly_coupon'
require 'plugin/redeemable_coupon'

