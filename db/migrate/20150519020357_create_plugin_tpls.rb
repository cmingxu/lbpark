class CreatePluginTpls < ActiveRecord::Migration
  def change
    create_table :plugin_tpls do |t|
      t.string :identifier
      t.string :name
      t.string :icon
      t.string :big_icon
      t.decimal :base_price
      t.text :desc

      t.timestamps
    end
  end
end
