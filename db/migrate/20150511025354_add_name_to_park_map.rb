class AddNameToParkMap < ActiveRecord::Migration
  def change
    add_column :park_maps, :name, :string
  end
end
