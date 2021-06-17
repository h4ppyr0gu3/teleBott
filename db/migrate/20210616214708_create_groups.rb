class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :group_id
      t.references :bot

      t.timestamps
    end
  end
end
