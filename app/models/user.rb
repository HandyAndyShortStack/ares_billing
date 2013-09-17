class User < ActiveRecord::Base
  attr_accessible :name
  has_one :subscription
  has_one :credit_card

  def subscribe plan
    return false unless credit_card
    options = {
      payment_method_token: credit_card.token,
      plan_id: plan.braintree_id
    }
    if subscription
      options[:options] = { prorate_charges: true }
      result = Braintree::Subscription.update(subscription.braintree_id, options)
    else
      result = Braintree::Subscription.create(options)
    end
    return false unless result.success?
    create_subscription unless subscription
    bt_sub = result[:subscription]
    subscription.update_attributes({
      billing_day_of_month:       bt_sub[:billing_day_of_month],
      billing_period_end_date:    bt_sub[:billing_period_end_date],
      billing_period_start_date:  bt_sub[:billing_period_start_date],
      failure_count:              bt_sub[:failure_count],
      first_billing_date:         bt_sub[:first_billing_date],
      never_expires:              bt_sub[:never_expires],
      next_billing_date:          bt_sub[:next_billing_date],
      number_of_billing_cycles:   bt_sub[:number_of_billing_cycles],
      next_billing_period_amount: bt_sub[:next_billing_period_amount],
      paid_through_date:          bt_sub[:paid_through_date],
      balance:                    bt_sub[:balance],
      price:                      bt_sub[:price],
      status:                     bt_sub[:status],
      trial_duration:             bt_sub[:trial_duration],
      trial_duration_unit:        bt_sub[:trial_duration_unit],
      trial_period:               bt_sub[:trial_period],
      plan_id:                    plan.id
    })
    return true
  end
end
