class AddDefaultToAllToPluginsToAll < ActiveRecord::Migration
  def change
    add_column :plugin_tpls, :default_to_all, :boolean
  end
end
