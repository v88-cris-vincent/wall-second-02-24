class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.belongs_to :message, null: false, foreign_key: true
      t.integer :user_id
      t.string :comment

      t.timestamps
    end
  end
end
