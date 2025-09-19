class CreateDialogs < ActiveRecord::Migration[7.2]
  def change
    create_table :dialogs do |t|
      t.string :title
      t.string :session_id, null: false
      t.timestamps
    end
    add_index :dialogs, :session_id

    change_table :messages do |t|
      t.references :dialog, foreign_key: true
    end
  end
end
