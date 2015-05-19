class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
      t.integer :park_id
      t.integer :plugin_tpl_id
      t.datetime :begin_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
