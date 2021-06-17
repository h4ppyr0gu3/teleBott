class CreateErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :errors do |t|
      t.text :error
      t.text :bot_name

      t.timestamps
    end
  end
end
