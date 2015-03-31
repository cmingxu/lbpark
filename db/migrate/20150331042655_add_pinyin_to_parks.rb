class AddPinyinToParks < ActiveRecord::Migration
  def change
    add_column :parks, :pinyin, :string
  end
end
