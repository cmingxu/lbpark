class CouponTpl::FreeCouponTpl < CouponTpl
  scope :published, -> { where(["status = 'published' AND fit_for_date = ? OR fit_for_date = ?", Date.today.to_s(:db), Date.today.tomorrow.to_s(:db)]) }
end
