class AlterPluginParkIdToClientId < ActiveRecord::Migration
  def change
    rename_column :plugins, :park_id, :client_id
  end
end
