require "spec_helper"

describe User do

  let(:user) { User.new }
  
  describe "#subscribe" do

    let(:plan) { Plan.new(id: 1, braintree_id: "plan id") }

    context "The user has a credit card on file" do

      let(:credit_card) { CreditCard.new }
      let(:braintree_response) { double("braintree_response").as_null_object }

      before :each do
        user.stub(credit_card: credit_card)
      end

      context "and already has a subscription" do

        let(:subscription) { Subscription.new(braintree_id: "subscription id") }

        before :each do
          user.stub(subscription: subscription)
        end

        it "updates the subscription if the transaction succeeds" do
          braintree_response.stub(success?: true)
          Braintree::Subscription.stub(:update).and_return(braintree_response)
          subscription.stub(:update_attributes)
          user.subscribe(plan)

          expect(subscription).to have_received(:update_attributes).with({
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
            plan_id:                    plan.id
          })
        end

        it "maintains the old subscription if the transaction fails"
      end

      context "and has no current subscription" do

        it "creates a new subscription if the transaction succeeds"

        it "does nothing if the transaction fails"
      end
    end

    it "does nothing if the user has no credit card on file"
  end
end
