# -*- encoding : utf-8 -*-
class OrderClearTask
  @queue = :order_clear_task

  def self.perform(id)
    c = Coupon.find id
    return if c.claimed?

    if c.status.to_s == 'ordered'
      c.issued_begin_date = nil
      c.issued_paizhao    = nil
      c.user_id           = nil
      c.status            = 'created'
      c.quantity          = nil

      c.save
    end
  end
end

