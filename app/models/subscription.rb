class Subscription < ActiveRecord::Base
  attr_accessible :balance, :billing_day_of_month, :billing_period_end_date,
                  :billing_period_start_date, :credit_card_id, :failure_count,
                  :first_billing_date, :never_expires, :next_billing_date,
                  :next_billing_period_amount, :number_of_billing_cycles,
                  :paid_through_date, :plan_id, :price, :status,
                  :trial_duration, :trial_duration_unit, :trial_period,
                  :user_id, :braintree_id

  belongs_to :user
end
