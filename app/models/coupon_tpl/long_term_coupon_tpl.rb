class CouponTpl::LongTermCouponTpl < CouponTpl
  scope :published, -> { where(["status = 'published' AND ? < end_at", Time.now]) }
end
