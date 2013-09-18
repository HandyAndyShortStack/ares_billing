class Plan < ActiveRecord::Base
  attr_accessible :billing_frequency, :braintree_id, :currency_iso_code,
                  :description, :name, :number_of_billing_cycles, :price,
                  :trial_duration, :trial_duration_unit, :trial_period

  has_many :subscriptions

  def sync *args
    if args[0]
      bt_plan = args[0]
    else
      bt_plan = Braintree::Plan.find(braintree_id)
    end
    update_attributes({
      billing_frequency:        bt_plan.billing_frequency,
      currency_iso_code:        bt_plan.currency_iso_code,
      description:              bt_plan.description,
      name:                     bt_plan.name,
      number_of_billing_cycles: bt_plan.number_of_billing_cycles,
      price:                    bt_plan.price,
      trial_duration:           bt_plan.trial_duration,
      trial_duration_unit:      bt_plan.trial_duration_unit,
      trial_period:             bt_plan.trial_period
    })
  end

  def self.sync
    Braintree::Plan.all.each do |bt_plan|
      plan = find_by_braintree_id(bt_plan.id)
      plan = create(braintree_id: bt_plan.id) unless plan
      plan.sync(bt_plan)
    end
  end
end
