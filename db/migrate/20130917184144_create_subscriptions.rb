class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :billing_day_of_month
      t.date :billing_period_end_date
      t.date :billing_period_start_date
      t.integer :failure_count
      t.date :first_billing_date
      t.boolean :never_expires
      t.date :next_billing_date
      t.integer :number_of_billing_cycles
      t.decimal :next_billing_period_amount
      t.date :paid_through_date
      t.decimal :balance
      t.integer :plan_id
      t.integer :user_id
      t.integer :credit_card_id
      t.decimal :price
      t.string :status
      t.integer :trial_duration
      t.string :trial_duration_unit
      t.boolean :trial_period

      t.timestamps
    end
  end
end
