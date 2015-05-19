class AddColumnEntryUrlForPluginTpls < ActiveRecord::Migration
  def change
    add_column :plugin_tpls, :entry_url, :string
  end
end
