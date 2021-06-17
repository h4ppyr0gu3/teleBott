class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.text :message
      t.references :bot

      t.timestamps
    end
  end
end
