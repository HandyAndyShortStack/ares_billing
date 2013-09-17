class Transaction < ActiveRecord::Base
  attr_accessible :amount, :avs_error_response_code, :avs_postal_code_response_code, :avs_street_address_response_code, :braintree_id, :credit_card_id, :currency_iso_code, :cvv_response_code, :gateway_rejection_reason, :subscription_id
end
