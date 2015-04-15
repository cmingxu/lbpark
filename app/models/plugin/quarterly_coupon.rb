class Plugin::QuarterlyCoupon < Plugin::Base
  def initialize(client)
    super(client)

    @displayable_name = "包季券"
    @internal_identifier = "quarterly_coupon"
    @fa_icon = "moon-o"
    @link    = url_helpers.client_coupons_path(:coupon_type => :quarterly)
  end
end
