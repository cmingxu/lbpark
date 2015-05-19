class AddFaIconToPluginTpls < ActiveRecord::Migration
  def change
    add_column :plugin_tpls, :fa_icon, :string
  end
end
