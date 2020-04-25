module Spree
  class MercadoPagoGatewayController < StoreController
    # protect_from_forgery except: :ipn
    # skip_before_action :set_current_order, only: :ipn

    def checkout
      current_order.state_name == :payment || raise(ActiveRecord::RecordNotFound)
      payment_method = Spree::Gateway::MercadoPagoGateway.find(params[:payment_method_id])
      
      additional_adjustments = current_order.all_adjustments.additional
      tax_adjustments = additional_adjustments.tax
      shipping_adjustments = additional_adjustments.shipping

      # payment = current_order.payments.create!({amount: current_order.total, source: Spree::PaypalExpressCheckout, payment_method: payment_method})
      # payment.started_processing!

      preferences = ::OrderPreferencesBuilder.
      new(current_order, payment_method.id , callback_urls ).preferences_hash

      provider = payment_method.provider 

      preference = provider.create_preference(preferences)

      sandbox = payment_method.isSandbox
      redirect_to preference["response"][sandbox]
    end

    # Success/pending callbacks are currently aliases, this may change
    # if required.
    def success
      # payment.order.next
      order = current_order || raise(ActiveRecord::RecordNotFound)
      order.payments.create!({      
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
    end
    
    def pending
      byebug
      order = current_order || raise(ActiveRecord::RecordNotFound)
      order.payments.create!({
        amount: order.total.to_f,
        payment_method: Spree::Gateway::MercadoPagoGateway.find(params[:external_reference])
      }).pend!
      
      flash.notice = Spree.t(:order_processed_successfully)
      flash[:order_completed] = false
      session[:order_id] = nil
      redirect_to completion_route(order)

    end

    def failure
      # payment.failure!
      
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
        callback:{
          success: mercado_pago_success_url,
          pending: mercado_pago_pending_url,
          failure: mercado_pago_failure_url
        },
        notify: mercado_pago_ipn_url
      }
    end
  end
end
