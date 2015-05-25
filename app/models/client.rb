# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  contact    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Client < ActiveRecord::Base
  has_many :client_users
  has_many :parks
  has_many :plugins
  has_many :client_members
  has_many :gates

  after_create :auto_install_default_plugins

  def auto_install_default_plugins
    PluginTpl.where(:default_to_all => true).each do |pt|
      self.plugins.create :plugin_tpl_id => pt.id, :begin_at => Time.now, :end_at => 10.years.from_now
    end
  end

  def hash_key
    "client_#{self.id}_client_members"
  end

  def latest_version
    $redis.hget hash_key, "version"
  end

  def latest_client_members
    $redis.hget hash_key, "client_members"
  end

  def update_client_member_version
    $redis.hset hash_key, "version", Time.now.to_i
    $redis.hset hash_key, "client_members", self.client_members.select{|cm| cm.membership_valid? }.map(&:valid_membership_json).to_json
  end
end
