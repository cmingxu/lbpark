class ResetRelationshipForClientAndUsers < ActiveRecord::Migration
  def change
    rename_table :clients, :client_users
    add_column :client_users, :client_id, :integer
    add_column :parks, :client_id, :integer
  end
end
