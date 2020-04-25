Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  Spree::Core::Engine.add_routes do
    post '/mercado_pago/checkout', to: "mercado_pago_gateway#checkout", as: :mercado_pago_checkout
    get  '/mercado_pago/success', to: "mercado_pago_gateway#success", as: :mercado_pago_success
    get  '/mercado_pago/pending', to: "mercado_pago_gateway#pending", as: :mercado_pago_pending
    get  '/mercado_pago/failure', to: "mercado_pago_gateway#failure", as: :mercado_pago_failure
    post '/mercado_pago/ipn', to: "mercado_pago_gateway#ipn", as: :mercado_pago_ipn
  end
  
end
