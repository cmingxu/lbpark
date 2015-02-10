class AddChosenToParkStatus < ActiveRecord::Migration
  def change
    add_column :park_statuses, :chosen, :boolean
  end
end
