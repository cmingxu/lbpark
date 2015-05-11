class AddUuidToParkMapEle < ActiveRecord::Migration
  def change
    add_column :park_map_eles, :uuid, :string
  end
end
