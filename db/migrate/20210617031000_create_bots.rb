class CreateBots < ActiveRecord::Migration[6.1]
  def change
    create_table :bots do |t|
      t.text :token
      t.string :name
      t.text :message
      t.integer :update_id, default: 0
      t.timestamps
    end
  end
end
