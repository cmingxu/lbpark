class AddPaizhaoToColumnNum < ActiveRecord::Migration
  def change
    add_column :coupons, :issued_paizhao, :string
  end
end
