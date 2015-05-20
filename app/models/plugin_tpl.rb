class PluginTpl < ActiveRecord::Base
  validates :identifier, uniqueness: true

  mount_uploader :icon, PluginTplIconUploader
  mount_uploader :big_icon, PluginTplBigIconUploader

  def self.setup
    [
      { :fa_icon => "plus", :identifier => "monthly",  :name => "发布包月券", :entry_url => "/client/coupons?coupon_type=monthly" },
      { :fa_icon => "plus", :identifier => "time",     :name => "发布计次券", :entry_url => "/client/coupons?coupon_type=time"},
      { :fa_icon => "plus", :identifier => "free",     :name => "发布限免券", :default_to_all => true, :entry_url => "/client/coupons?coupon_type=free"},
      { :fa_icon => "plus", :identifier => "deduct",   :name => "满额抵减券", :entry_url => "/client/coupons?coupon_type=deduct"},
      { :fa_icon => "plus", :identifier => "park_map", :name => "长租车位管理", :entry_url => "/client/park_maps"}
    ].each do |p|
      plugin_tpl = self.find_or_create_by(:identifier => p[:identifier])
      plugin_tpl.update_attributes p
      plugin_tpl.save
    end
  end
end
