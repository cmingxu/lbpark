class AddImportedCsvToImports < ActiveRecord::Migration
  def change
    add_column :imports, :imported_csv, :string
  end
end
