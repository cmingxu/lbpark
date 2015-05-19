class PluginTpl < ActiveRecord::Base
  validates :identifier, uniqueness: true

  mount_uploader :icon, PluginTplIconUploader
  mount_uploader :big_icon, PluginTplBigIconUploader

  def self.setup
    [
      { :identifier => "moonthly", :name => "发布包月券" },
      {:identifier => "time", :name => "发布包月券"},
      {:identifier => "free", :name => "发布限免券", :default_to_all => true},
      {:identifier => "deduct", :name => "满额抵减券"},
      {:identifier => "park_map", :name => "车场平面图"}
    ].each do |p|
      plugin_tpl = self.find_or_create_by(:identifier => p[:identifier])
      plugin_tpl.update_attributes p
      plugin_tpl.save
    end
  end
end
