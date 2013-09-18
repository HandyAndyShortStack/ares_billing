class WebhooksController < ApplicationController

  def verify
    render :text => Braintree::WebhookNotification.verify(params[:bt_challenge])
  end
end
