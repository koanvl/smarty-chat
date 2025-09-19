class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :role
      t.string :status
      t.string :session_id

      t.timestamps
    end
  end
end
