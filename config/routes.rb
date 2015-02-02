Rails.application.routes.draw do
  root to: 'visitors#index'

  get "assets/campaign/:id", to: "assets#campaign"
  get "assets/email/:id", to: "assets#email"
  get "assets/form/:id", to: "assets#form"
  get "assets/landingpage/:id", to: "assets#landing_page"
  get "assets/segment/:id", to: "assets#contact_segment"

  post "eloqua/install", to: "eloqua#install"
  get "eloqua/status", to: "eloqua#status"
  get "eloqua/callback/(:id)", to: "eloqua#callback"

  post "integrate/actions/create", to: "integrate#create_action"
  get "integrate/actions/configure", to: "integrate#configure_action"
  post "integrate/actions/notify", to: "integrate#notify_action"
  get "integrate/menu", to: "integrate#menu"
end
