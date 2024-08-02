class AddModifiedDurationToMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :modified_duration, :string
  end
end
