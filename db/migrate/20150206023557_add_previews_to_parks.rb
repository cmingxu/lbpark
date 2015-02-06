class AddPreviewsToParks < ActiveRecord::Migration
  def change
    add_column :parks, :previews, :text
  end
end
