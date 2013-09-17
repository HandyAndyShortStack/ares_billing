class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :braintree_id
      t.string :avs_error_response_code
      t.string :avs_postal_code_response_code
      t.string :avs_street_address_response_code
      t.decimal :amount
      t.integer :subscription_id
      t.integer :credit_card_id
      t.string :currency_iso_code
      t.string :cvv_response_code
      t.string :gateway_rejection_reason

      t.timestamps
    end
  end
end
