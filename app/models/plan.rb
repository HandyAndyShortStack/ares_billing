class Plan < ActiveRecord::Base
  attr_accessible :billing_frequency, :braintree_id, :currency_iso_code, :description, :name, :number_of_billing_cycles, :price, :trial_duration, :trial_duration_unit, :trial_period
end
