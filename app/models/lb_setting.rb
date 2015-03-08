# == Schema Information
#
# Table name: lb_settings
#
#  id         :integer          not null, primary key
#  var        :string(255)      not null
#  lb_value   :text
#  created_at :datetime
#  updated_at :datetime
#

class LbSetting < ActiveRecord::Base

  class << self
    def method_missing(var, *args)
      if var.intern =~ /=$/
        config = find_or_create_by(:var => var[0..-2])
        config.lb_value  = args[0]
        config.save
      else
        where(:var => var).first.try(:lb_value)
      end
    end
  end
end
