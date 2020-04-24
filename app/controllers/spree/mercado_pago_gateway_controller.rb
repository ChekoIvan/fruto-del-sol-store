module Spree
  class MercadoPagoGatewayController < StoreController
    # protect_from_forgery except: :ipn
    # skip_before_action :current_order, only: :ipn

    def checkout
      current_order.state_name == :payment || raise(ActiveRecord::RecordNotFound)
      payment_method = Spree::Gateway::MercadoPagoGateway.find(params[:payment_method_id])
      items = current_order.line_items.map(&method(:line_item))
      
      additional_adjustments = current_order.all_adjustments.additional
      tax_adjustments = additional_adjustments.tax
      shipping_adjustments = additional_adjustments.shipping
     
      # payment = current_order.payments.create!({amount: current_order.total, source: Spree::PaypalExpressCheckout, payment_method: payment_method})
      # payment.started_processing!
      
      
      # preferences = ::MercadoPago::OrderPreferencesBuilder.
      #   new(current_order, payment, callback_urls).
      #   preferences_hash
      

      provider = payment_method.provider
      preference_data = {
        "items": items,
        "back_urls": callback_urls,
        "external_reference": payment_method.id
      }
      preference = provider.create_preference(preference_data)
      sandbox = payment_method.isSandbox
      redirect_to preference["response"][sandbox]
    end

    # Success/pending callbacks are currently aliases, this may change
    # if required.
    def success
      # payment.order.next
      order = current_order || raise(ActiveRecord::RecordNotFound)
      order.payments.create!({
        source: Spree::PaypalExpressCheckout.create({
          token: params[:collection_id],
          payer_id: params[:merchant_order_id]
        }),
        amount: order.total.to_f,
        payment_method: Spree::Gateway::MercadoPagoGateway.find(params[:external_reference])
      })
      order.next
      if order.complete?
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:order_completed] = true
        session[:order_id] = nil
        redirect_to completion_route(order)
      else
        redirect_to checkout_state_path(order.state)
      end

      # flash.notice = Spree.t(:order_processed_successfully)
      # flash['order_completed'] = true
      # redirect_to spree.order_path(payment.order)
    end

    def failure
      payment.failure!
      flash.notice = Spree.t(:payment_processing_failed)
      flash['order_completed'] = true
      redirect_to spree.checkout_state_path(state: :payment)
    end

    def ipn
      # notification = MercadoPago::Notification.
      #   new(operation_id: params[:id], topic: params[:topic])

      # if notification.save
      #   MercadoPago::HandleReceivedNotification.new(notification).process!
      #   status = :ok
      # else
      #   status = :bad_request
      # end

      # render nothing: true, status: status
    end

    private

    def line_item(item)
      {
          title: item.product.name,
          # Number: item.variant.sku,
          quantity: item.quantity,
          unit_price: item.price.to_f,
          currency_id: item.order.currency
          # ItemCategory: "Physical"
      }
    end

    # def payment
    #   @payment ||= Spree::Payment.where(number: params[:external_reference]).
    #     first
    # end
    # def provider
    #   payment_method.provider
    # end
    def completion_route(order)
      order_path(order)
    end

    def callback_urls
      @callback_urls ||= {
        success: mercado_pago_success_url,
        pending: mercado_pago_success_url,
        failure: mercado_pago_failure_url
      }
    end
  end
end
