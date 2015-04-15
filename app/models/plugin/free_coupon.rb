class Plugin::FreeCoupon < Plugin::Base
  def initialize(client)
    super(client)

    @displayable_name = "免费券"
    @internal_identifier = "free_coupon"
    @fa_icon = "gift"
    @link    = url_helpers.client_coupons_path(:coupon_type => :free)
  end
end

