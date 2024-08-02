class AddModifiedMetadataToMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :modified_metadata, :json
  end
end
