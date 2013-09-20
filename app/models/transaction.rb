class Transaction < ActiveRecord::Base
  attr_accessible :amount, :avs_error_response_code,
                  :avs_postal_code_response_code,
                  :avs_street_address_response_code,
                  :braintree_id, :credit_card_id, :currency_iso_code,
                  :cvv_response_code, :gateway_rejection_reason, :user_id
  
  belongs_to :user

  def sync bt_trans
    attributes = {}
    [
      :amount, :avs_error_response_code, :avs_postal_code_response_code,
      :avs_street_address_response_code, :currency_iso_code,
      :cvv_response_code, :gateway_rejection_reason,
    ].each do |sym|
      attributes[sym] = bt_trans.send(sym) if bt_trans.respond_to?(sym)
    end
    attributes[:braintree_id] = bt_trans.id
    update_attributes attributes
  end
end
