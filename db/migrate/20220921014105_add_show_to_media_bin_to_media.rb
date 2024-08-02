class AddShowToMediaBinToMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :media_bin, :boolean, default: false
  end
end
