class WebhooksController < ApplicationController

  def verify
    render :text => Braintree::WebhookNotification.verify(params[:bt_challenge])
  end

  def notify
    notification = Braintree::WebhookNotification.parse(
      params[:bt_signature], params[:bt_payload]
    )
    bt_sub = notification.subscription
    subscription = Subscription.find_by_braintree_id(bt_sub.id)
    if notification.kind == "subscription_canceled"
      subscription.destroy if subscription
    elsif notification.kind == "subscription_charged_successfully"
      transaction = bt_sub.transactions.sort { |a, b| b.created_at <=> a.created_at } .first
      subscription.user.sync_transaction(transaction)
    else
      subscription.sync(bt_sub)
    end
    head 200
  end
end
