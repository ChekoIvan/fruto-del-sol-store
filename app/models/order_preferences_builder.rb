class OrderPreferencesBuilder
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper
  include Spree::ProductsHelper
  
    def initialize(order, payment, callback_urls, payer_data = nil)
      @order         = order
      @payment       = payment
      @callback_urls = callback_urls[:callback]
      @notification_url = callback_urls[:notify]
      @payer_data    = get_user(order.user_id, order.email)
    end

    def preferences_hash
      {
        external_reference: @payment,
        auto_return: "approved",
        binary_mode: true,
        payment_methods: {excluded_payment_types: [{id: "ticket"},{id:"atm"}]},
        # notification_url: @notification_url,
        back_urls: @callback_urls,
        payer: @payer_data,
        items: generate_items
      }
    end

    private

    def generate_items
      items = []
      items += generate_items_from_line_items
      items += generate_items_from_adjustments
      items += generate_items_from_shipments

      items
    end

    def generate_items_from_shipments
      @order.shipments.collect do |shipment|
        {
          :title => shipment.shipping_method.name,
          :unit_price => shipment.cost.to_f + shipment.adjustment_total.to_f,
          :quantity => 1
          
        }
      end
    end

    def generate_items_from_line_items
      @order.line_items.collect do |line_item|
        {
          :title => line_item_description_text(line_item.variant.product.name),
          :unit_price => line_item.price.to_f,
          :quantity => line_item.quantity,
          :currency_id=> line_item.order.currency
        }
      end
    end

    def generate_items_from_adjustments
      @order.adjustments.eligible.collect do |adjustment|
        {
          title: line_item_description_text(adjustment.label),
          unit_price: adjustment.amount.to_f,
          quantity: 1
          
        }
      end
    end
    
    def get_user(user_id = nil, email)
      {
        email: email
      }
    end

end
