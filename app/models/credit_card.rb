class CreditCard < ActiveRecord::Base
  attr_accessible :image_url, :last_4, :token, :user_id
  belongs_to :user
end
