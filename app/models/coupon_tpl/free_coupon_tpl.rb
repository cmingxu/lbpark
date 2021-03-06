# == Schema Information
#
# Table name: coupon_tpls
#
#  id                        :integer          not null, primary key
#  park_id                   :integer
#  priority                  :integer
#  staff_id                  :integer
#  type                      :string(255)
#  identifier                :string(255)
#  name_cn                   :string(255)
#  fit_for_date              :date
#  end_at                    :datetime
#  gcj_lat                   :decimal(10, 6)
#  gcj_lng                   :decimal(10, 6)
#  quantity                  :integer
#  price                     :integer
#  copy_from                 :integer
#  status                    :string(255)
#  published_at              :datetime
#  created_at                :datetime
#  updated_at                :datetime
#  banner                    :string(255)
#  notice                    :string(255)
#  coupon_value              :integer
#  valid_hour_begin          :integer
#  valid_hour_end            :integer
#  lower_limit_for_deduct    :integer
#  valid_dates               :string(255)
#  park_space_choose_enabled :boolean
#

class CouponTpl::FreeCouponTpl < CouponTpl
  scope :published, -> { where(["status = 'published' AND fit_for_date = ? OR fit_for_date = ?", Date.today.to_s(:db), Date.today.tomorrow.to_s(:db)]) }

  def free?
    true
  end

  def type_name_in_zh
    "免费停车"
  end

  def time_span
    "0:00-24:00"
  end

  #def can_be_claimed_by?(user)
    #!user.coupons.exists?(["coupon_tpl_id = ?", self.id])
  #end
end
