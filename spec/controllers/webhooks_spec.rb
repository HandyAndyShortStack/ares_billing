require "spec_helper"

describe WebhooksController do
  
  it "provides a proper verification response" do
    get "verify", bt_challenge: "sample challenge"

    expect(response.body[0..15]).to eq("5t3rvbvhy8qtzqg5")
  end
end
