class User < ActiveRecord::Base
  attr_accessible :name
  has_one :subscription
  has_one :credit_card
  has_many :transactions

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
    bt_sub = result.subscription
    subscription.sync(bt_sub)
    subscription.update_attributes(plan_id: plan.id)
    return true
  end

  def unsubscribe
    return true unless subscription
    result = Braintree::Subscription.cancel(subscription.braintree_id)
    return false unless result.success?
    subscription.destroy
    return true
  end

  def sync_transaction bt_trans
    transaction = Transaction.find_by_braintree_id(bt_trans.id)
    transaction = create_transaction unless transaction
    transaction.sync(bt_trans)
  end
end
