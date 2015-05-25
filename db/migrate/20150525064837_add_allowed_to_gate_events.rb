class AddAllowedToGateEvents < ActiveRecord::Migration
  def change
    add_column :gate_events, :is_allowed, :boolean
  end
end
