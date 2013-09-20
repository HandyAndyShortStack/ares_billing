require "spec_helper"

describe User do

  let(:user) { User.new }
  let(:subscription) { Subscription.new(braintree_id: "subscription id") }
  let(:braintree_response) { double("braintree_response").as_null_object }
  
  describe "#subscribe" do

    let(:plan) { Plan.new(id: 1, braintree_id: "plan id") }

    context "The user has a credit card on file" do

      let(:credit_card) { CreditCard.new }
      let(:subscription_attributes) do
        {
          billing_day_of_month:       braintree_response,
          billing_period_end_date:    braintree_response,
          billing_period_start_date:  braintree_response,
          failure_count:              braintree_response,
          first_billing_date:         braintree_response,
          never_expires:              braintree_response,
          next_billing_date:          braintree_response,
          number_of_billing_cycles:   braintree_response,
          next_billing_period_amount: braintree_response,
          paid_through_date:          braintree_response,
          balance:                    braintree_response,
          price:                      braintree_response,
          status:                     braintree_response,
          trial_duration:             braintree_response,
          trial_duration_unit:        braintree_response,
          trial_period:               braintree_response,
        }
      end

      before :each do
        user.stub(credit_card: credit_card)
      end

      context "and already has a subscription" do

        before :each do
          user.stub(subscription: subscription)
          Braintree::Subscription.stub(:update).and_return(braintree_response)
          subscription.stub(:update_attributes)
        end

        it "updates the subscription if the transaction succeeds" do
          braintree_response.stub(success?: true)
          user.subscribe(plan)

          expect(subscription).to have_received(:update_attributes).with(subscription_attributes)
        end

        it "maintains the old subscription if the transaction fails" do
          braintree_response.stub(success?: false)
          user.subscribe(plan)

          expect(subscription).not_to have_received(:update_attributes)
        end
      end

      context "and has no current subscription" do

        before :each do
          Braintree::Subscription.stub(:create).and_return(braintree_response)
          subscription.stub(:update_attributes)
          user.stub(:create_subscription) { user.stub(subscription: subscription) }
        end

        it "creates a new subscription if the transaction succeeds" do
          braintree_response.stub(success?: true)
          user.subscribe(plan)

          expect(subscription).to have_received(:update_attributes).with(subscription_attributes)
        end

        it "does nothing if the transaction fails" do
          braintree_response.stub(success?: false)
          user.subscribe(plan)

          expect(user).not_to have_received(:create_subscription)
        end
      end
    end

    it "does nothing if the user has no credit card on file" do
      expect(user.subscribe(plan)).to eq(false)
    end
  end

  describe "#unsubscribe" do

    context "The user is subscribed to a plan" do

      before :each do
        user.stub(subscription: subscription)
        Braintree::Subscription.stub(:cancel).and_return(braintree_response)
      end

      it "deletes the subscription in the database if the transaction succeeds" do
        braintree_response.stub(success?: true)
        subscription.stub(:destroy)
        user.unsubscribe

        expect(subscription).to have_received(:destroy)
      end

      it "does nothing if the transaction fails" do
        braintree_response.stub(success?: false)

        expect(user.unsubscribe).to eq(false)
      end
    end

    it "does nothing if the user has no subscription" do
      expect(user.unsubscribe).to eq(true)
    end
  end

  describe "#apply_discount" do

    let(:options) do
      {
        amount: 100.00,
        inherited_from_id: "sample name",
        number_of_billing_cycles: 1
      }
    end

    it "applies a discount to the user's subscription if it exists" do
      user.stub(subscription: subscription)
      braintree_response.stub(success?: true)
      subscription.stub(:update_attributes)
      Braintree::Subscription.stub(:update) do |id, hsh|
        expect(hsh).to eq({
          discounts: { add: [options] }
        })
        braintree_response
      end
      user.apply_discount(options)

      expect(Braintree::Subscription).to have_received(:update)
    end

    it "does nothing if the user has no subscription" do
      expect(user.apply_discount(options)).to eq(false)
    end
  end

  describe "#remove_discount" do

    it "removes the specified discount if the user has a subscription" do
      user.stub(subscription: subscription)
      braintree_response.stub(success?: true)
      subscription.stub(:update_attributes)
      Braintree::Subscription.stub(:update) do |id, hsh|
        expect(hsh).to eq({
          discounts: { remove: ["discount id"] }
        })
        braintree_response
      end
      user.remove_discount "discount id"

      expect(Braintree::Subscription).to have_received(:update)
    end

    it "does nothing if the user has no subscription" do
      expect(user.remove_discount("discount id")).to eq(false)
    end
  end
end
