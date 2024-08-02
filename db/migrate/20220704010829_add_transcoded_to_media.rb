class AddTranscodedToMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :transcoded, :boolean, default: false
  end
end
