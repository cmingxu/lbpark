class Plugin::MonthlyCoupon < Plugin::Base
  def initialize(client)
    super(client)

    @displayable_name = "包月券"
    @internal_identifier = "monthly_coupon"
    @fa_icon = "calendar"
    @link    = url_helpers.client_coupons_path(:coupon_type => :monthly)
  end
end
