class AddPhoneAndLoginToClients < ActiveRecord::Migration
  def change
    add_column :clients, :phone, :string
    add_column :clients, :login, :string
  end
end
