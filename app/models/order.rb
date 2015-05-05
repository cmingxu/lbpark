# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  order_num        :string(255)
#  park_id          :integer
#  user_id          :integer
#  status           :string(255)
#  price            :integer
#  coupon_id        :integer
#  paid_at          :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  body             :string(255)
#  spbill_create_ip :string(255)
#  notify_url       :string(255)
#  bank_type        :string(255)
#  transaction_id   :string(255)
#  ip               :string(255)
#  prepay_id        :string(255)
#  quantity         :integer
#

class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :park
  belongs_to :coupon

  state_machine :status, :initial => :not_paid do
    event :pay do
      transition :from => :not_paid, :to => :paid
    end

    event :close do
      transition :from => [:paid], :to => :closed
    end
  end

  def prepay_params
    {
      body: "#{self.coupon.coupon_tpl.type_name_in_zh}X#{self.quantity}",
      out_trade_no: self.order_num,
      total_fee: self.price * 100, # after calculation when created
      spbill_create_ip: self.ip,
      notify_url: self.notify_url,
      trade_type: 'JSAPI',
      openid: self.user.openid
    }

  end

  def self.create_with_coupon(coupon, remote_ip)
    create do |o|
      o.order_num = "O_#{coupon.identifier}_#{SecureRandom.hex(4)}"
      o.park_id = coupon.park_id
      o.user_id = coupon.user_id
      o.price   = coupon.price * coupon.quantity
      o.coupon_id = coupon.id
      o.body = coupon.coupon_tpl.type_name_in_zh
      o.ip = remote_ip
      o.notify_url = Settings.site_domain + "/mobile_coupons/notify?order_num=#{o.order_num}"
      o.quantity = coupon.quantity
    end
  end
end
