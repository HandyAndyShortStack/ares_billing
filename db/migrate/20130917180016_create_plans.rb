class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :braintree_id
      t.integer :billing_frequency
      t.string :currency_iso_code
      t.text :description
      t.string :name
      t.integer :number_of_billing_cycles
      t.decimal :price
      t.integer :trial_duration
      t.string :trial_duration_unit
      t.boolean :trial_period

      t.timestamps
    end
  end
end
