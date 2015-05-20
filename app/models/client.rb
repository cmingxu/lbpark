class Client < ActiveRecord::Base
  has_many :client_users
  has_many :parks
  has_many :plugins
  has_many :client_members

  after_create :auto_install_default_plugins

  def auto_install_default_plugins
    PluginTpl.where(:default_to_all => true).each do |pt|
      self.plugins.create :plugin_tpl_id => pt.id, :begin_at => Time.now, :end_at => 10.years.from_now
    end
  end
end
