class Plugin::RedeemableCoupon < Plugin::Base
  def initialize(client)
    super(client)

    @displayable_name = "代金券"
    @internal_identifier = "redeemable_coupon"
    @fa_icon = "cny"
    @link    = url_helpers.client_coupons_path(:coupon_type => :redeemable)
  end
end

