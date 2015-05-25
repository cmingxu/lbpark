class AddNameToGates < ActiveRecord::Migration
  def change
    add_column :gates, :name, :string
  end
end
