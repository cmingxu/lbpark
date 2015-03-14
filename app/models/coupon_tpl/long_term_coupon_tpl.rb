# == Schema Information
#
# Table name: coupon_tpls
#
#  id           :integer          not null, primary key
#  park_id      :integer
#  priority     :integer
#  staff_id     :integer
#  type         :string(255)
#  identifier   :string(255)
#  name_cn      :string(255)
#  fit_for_date :date
#  end_at       :datetime
#  gcj_lat      :decimal(10, 6)
#  gcj_lng      :decimal(10, 6)
#  quantity     :integer
#  price        :integer
#  copy_from    :integer
#  status       :string(255)
#  published_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class CouponTpl::LongTermCouponTpl < CouponTpl
  scope :published, -> { where(["status = 'published' AND ? < end_at", Time.now]) }
end
