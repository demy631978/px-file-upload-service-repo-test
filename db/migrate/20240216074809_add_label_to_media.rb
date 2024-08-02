class AddLabelToMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :label, :string
  end
end
