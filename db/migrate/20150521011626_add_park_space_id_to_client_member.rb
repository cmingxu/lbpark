class AddParkSpaceIdToClientMember < ActiveRecord::Migration
  def change
    add_column :client_memberships, :park_space_id, :integer
  end
end
