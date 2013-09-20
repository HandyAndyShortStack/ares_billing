require "spec_helper"

describe WebhooksController do

  let(:subscription) { Subscription.new }

  before :each do
    Subscription.stub(:find_by_braintree_id).and_return(subscription)
  end
  
  it "provides a proper verification response" do
    get "verify", bt_challenge: "sample challenge"

    expect(response.body[0..15]).to eq("5t3rvbvhy8qtzqg5")
  end

  describe "#notify" do

    it "can tell subscriptions to update" do
      subscription.stub(:update_attributes)
      signature, payload = Braintree::WebhookTesting.sample_notification(
        Braintree::WebhookNotification::Kind::SubscriptionWentPastDue,
        "sample id"
      )
      post "notify", bt_signature: signature, bt_payload: payload

      expect(subscription).to have_received(:update_attributes)
    end

    it "deletes cancelled subscriptions, if they exist" do
      subscription.stub(:destroy)
      signature, payload = Braintree::WebhookTesting.sample_notification(
        Braintree::WebhookNotification::Kind::SubscriptionCanceled,
        "sample id"
      )
      post "notify", bt_signature: signature, bt_payload: payload
      
      expect(subscription).to have_received(:destroy)
    end
  end

  it "creates a new transactions when appropriate" do
    user = User.new
    subscription.stub(user: user)
    signature, payload = Braintree::WebhookTesting.sample_notification(
        Braintree::WebhookNotification::Kind::SubscriptionChargedSuccessfully,
        "sample id"
    )
    notification = Braintree::WebhookNotification.parse(signature, payload)
    transaction = double(id: "sample id", sync: nil)
    notification.subscription.transactions << transaction
    Braintree::WebhookNotification.stub(:parse).and_return(notification)
    user.stub(:create_transaction).and_return(transaction)
    post "notify", bt_signature: signature, bt_payload: payload

    expect(user).to have_received(:create_transaction)
  end
end
