//= require spree/frontend

MercadoPago = {
  hidePaymentSaveAndContinueButton: function(paymentMethod) {
    if (MercadoPago.paymentMethodID && paymentMethod.val() == MercadoPago.paymentMethodID) {
      $("#checkout_form_payment [data-hook=buttons]").hide();
    } else {
      // $("#checkout_form_payment [data-hook=buttons]").show();
    }
  },
  showMercadoPagoButton: function (event) {
    if (MercadoPago.paymentMethodID && paymentMethod.val() == MercadoPago.paymentMethodID) {
      $('.payment-sources').show()
      $('#payment-methods').show()
      event.stopPropagation()
    }
  }
};

$(document).ready(function() {
  checkedPaymentMethod = $('div[data-hook="checkout_payment_step"] input[type="radio"]:checked');
  MercadoPago.hidePaymentSaveAndContinueButton(checkedPaymentMethod);
  paymentMethods = $('div[data-hook="checkout_payment_step"] input[type="radio"]').click(function (e) {
    MercadoPago.showMercadoPagoButton(e);
    MercadoPago.hidePaymentSaveAndContinueButton($(e.target));
  });

  // $('button.mercado_pago_button').click(function(event){
  //   $(event.target).prop("disabled",true);
  // });
});
