class IssuedParkSpaceCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :issued_park_space, :string
  end
end
