# == Schema Information
#
# Table name: plugins
#
#  id            :integer          not null, primary key
#  client_id     :integer
#  plugin_tpl_id :integer
#  begin_at      :datetime
#  end_at        :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  enabled       :boolean
#

class Plugin < ActiveRecord::Base
  belongs_to :client
  belongs_to :plugin_tpl
  before_create do
    self.enabled = true
  end

  scope :active, -> { where(:enabled => true).where("begin_at < ? AND ? < end_at", Time.now, Time.now)}

  delegate :name, :identifier, :fa_icon, :entry_url, :icon, :big_icon,  to: :plugin_tpl
end
