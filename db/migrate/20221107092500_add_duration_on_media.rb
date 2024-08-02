class AddDurationOnMedia < ActiveRecord::Migration[7.0]
  def change
    add_column :media, :duration, :string 
  end
end
