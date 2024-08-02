class AddFileDetailsToMedium < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :file_name, :string
    add_column :media, :file_size, :float
    add_column :media, :file_width, :float
    add_column :media, :file_height, :float
  end
end
