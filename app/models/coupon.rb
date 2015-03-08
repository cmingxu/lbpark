# == Schema Information
#
# Table name: coupons
#
#  id             :integer          not null, primary key
#  park_id        :integer
#  coupon_tpl_id  :integer
#  identifier     :string(255)
#  user_id        :integer
#  status         :string(255)
#  end_at         :datetime
#  price          :integer
#  issued_address :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Coupon < ActiveRecord::Base
  COUPON_STATUS = {
    :created => "已创建",
    :claimed => "已领取",
    :used    => "已试用",
    :expired => "已过期"
  }

  belongs_to :coupon_tpl
  belongs_to :park

  COUPON_STATUS.keys.each { |s| scope s, -> { where(:status => s) } }

  state_machine :status, :initial => :created do
    event :claim do
      transition :from => :created, :to => :claimed
    end

    event :use do
      transition :from => :claimed, :to => :used
    end

    event :expire do
      transition :from => [:created, :claimed], :to => :expired
    end
  end
end
