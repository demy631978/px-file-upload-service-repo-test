class AddFileTypeToMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :file_type, :string
    add_index :media, :file_type
  end
end
