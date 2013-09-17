class AddBraintreeIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :braintree_id, :string
  end
end
