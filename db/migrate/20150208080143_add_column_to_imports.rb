class AddColumnToImports < ActiveRecord::Migration
  def change
    add_column :imports, :code_prefix, :string
    add_column :imports, :city, :string
    add_column :imports, :district, :string
    add_column :imports, :lb_staff, :string
    add_column :imports, :failed_reason, :string
  end
end
