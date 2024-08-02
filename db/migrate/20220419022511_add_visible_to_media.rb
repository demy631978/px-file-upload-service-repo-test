class AddVisibleToMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :visible, :boolean, default: true
  end
end
