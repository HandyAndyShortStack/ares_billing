class Subscription < ActiveRecord::Base
  attr_accessible :balance, :billing_day_of_month, :billing_period_end_date,
                  :billing_period_start_date, :credit_card_id, :failure_count,
                  :first_billing_date, :never_expires, :next_billing_date,
                  :next_billing_period_amount, :number_of_billing_cycles,
                  :paid_through_date, :plan_id, :price, :status,
                  :trial_duration, :trial_duration_unit, :trial_period,
                  :user_id, :braintree_id

  belongs_to :user

  def sync *args
    if args[0]
      bt_sub = args[0]
    else
      bt_sub = Braintree::Subscription.find(braintree_id)
    end
    update_attributes({
      billing_day_of_month:       bt_sub.billing_day_of_month,
      billing_period_end_date:    bt_sub.billing_period_end_date,
      billing_period_start_date:  bt_sub.billing_period_start_date,
      failure_count:              bt_sub.failure_count,
      first_billing_date:         bt_sub.first_billing_date,
      never_expires:              bt_sub.never_expires?,
      next_billing_date:          bt_sub.next_billing_date,
      number_of_billing_cycles:   bt_sub.number_of_billing_cycles,
      next_billing_period_amount: bt_sub.next_billing_period_amount,
      paid_through_date:          bt_sub.paid_through_date,
      balance:                    bt_sub.balance,
      price:                      bt_sub.price,
      status:                     bt_sub.status,
      trial_duration:             bt_sub.trial_duration,
      trial_duration_unit:        bt_sub.trial_duration_unit,
      trial_period:               bt_sub.trial_period
    })
  end
end
