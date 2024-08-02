class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media, id: :uuid do |t|
      t.belongs_to :user, type: :uuid

      t.timestamps
    end
  end
end
