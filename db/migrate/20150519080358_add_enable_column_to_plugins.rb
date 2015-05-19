class AddEnableColumnToPlugins < ActiveRecord::Migration
  def change
    add_column :plugins, :enabled, :boolean
  end
end
