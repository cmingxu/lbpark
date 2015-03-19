# -*- encoding : utf-8 -*-
class CouponGenerationJob
  @queue = :coupon_generation_job

  def self.perform(id)
    coupon_tpl  = CouponTpl.find(id)
    coupon_tpl.generate_all_new_coupon
  end
end

