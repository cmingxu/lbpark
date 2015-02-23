class LbSetting < ActiveRecord::Migration
  def change
    create_table :lb_settings, :force => true do |t|
      t.string :var, :null => false
      t.text   :lb_value, :null => true
      t.timestamps
    end
  end
end
