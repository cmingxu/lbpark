class CouponTpl::FreeCouponTpl < CouponTpl
  scope :published, -> { where(["status = 'published' AND fit_for_date = ? OR fit_for_date = ?", Date.today.to_s(:db), Date.today.tomorrow.to_s(:db)]) }

  def can_be_claimed_by?(user)
    user.coupons.exists?(["coupon_tpl_id = ? AND fit_for_date = ?", self.id, self.fit_for_date])
  end
end
