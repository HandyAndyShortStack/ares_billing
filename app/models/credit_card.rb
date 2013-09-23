class CreditCard < ActiveRecord::Base
  attr_accessible :image_url, :last_4, :token, :user_id
  belongs_to :user

  def sync bt_cc
    options = { last_4: bt_cc.last_4, token: bt_cc.token }
    options[:image_url] = bt_cc.image_url if bt_cc.respond_to? :image_url
    update_attributes(options)
  end
end
