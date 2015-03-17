class AddColumnToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :issued_begin_date, :date
  end
end
