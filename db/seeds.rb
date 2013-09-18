# populate the plans table from braintree data
Braintree::Plan.all.each do |bt_plan|
  plan = Plan.find_by_braintree_id(bt_plan.id)
  plan = Plan.create(braintree_id: bt_plan.id) unless plan
  plan.sync(bt_plan)
end
