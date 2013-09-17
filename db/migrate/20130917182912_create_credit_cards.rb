class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :user_id
      t.string :image_url
      t.string :last_4
      t.string :token

      t.timestamps
    end
  end
end
