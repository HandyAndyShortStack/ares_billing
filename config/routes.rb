AresBilling::Application.routes.draw do
  get "webhooks", to: "webhooks#verify"
  post "webhooks", to: "webhooks#notify"
end
