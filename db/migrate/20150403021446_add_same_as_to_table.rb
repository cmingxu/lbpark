class AddSameAsToTable < ActiveRecord::Migration
  
  def change
    add_column :parks, :same_as, :string
    add_column :park_imports, :same_as, :string
  end
end
