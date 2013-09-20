class ChangeTeansactionToBelongToUser < ActiveRecord::Migration
  def change
    add_column :transactions, :user_id, :integer
    remove_column :transactions, :subscription_id, :integer
  end
end
