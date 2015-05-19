class Plugin < ActiveRecord::Base
  belongs_to :client
  belongs_to :plugin_tpl
  before_create do
    self.enabled = true
  end

  scope :active, -> { where(:enabled => true).where("begin_at < ? AND ? < end_at", Time.now, Time.now)}

  delegate :name, :identifier, :fa_icon, :entry_url,  to: :plugin_tpl
end
