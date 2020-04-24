require 'mercadopago.rb'
class Spree::Gateway::MercadoPagoGateway < Spree::Gateway

  preference :login, :string
  preference :password, :string
  preference :signature, :string
  preference :server, :string, default: 'sandbox'
  

  def provider_class
    Spree::Gateway::MercadoPagoGateway
  end

  def provider
    $mp = MercadoPago.new(preferred_password)
  end
  
  def isSandbox
    env = preferred_server == 'sandbox' ?  "sandbox_init_point" : 'init_point'
  end
#   def payment_source_class
#     Spree::CreditCard
#   end

  def auto_capture?
    true
  end

  def method_type
    'mercado_pago'
  end

  def purchase(amount, transaction_details, options = {})
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end
end