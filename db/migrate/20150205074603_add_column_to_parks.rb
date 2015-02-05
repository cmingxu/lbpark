class AddColumnToParks < ActiveRecord::Migration
  def change
    add_column :parks, :pic_num, :string
    add_column :parks, :originate_from, :string
    add_column :parks, :property_owner, :string
  end
end
