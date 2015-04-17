class AddPrepayIdForOrder < ActiveRecord::Migration
  def change
    add_column :orders, :prepay_id, :string
  end
end
