console.log('checkout.js loaded');

// Constants for shipping costs
const SHIPPING_COSTS = {
  purolator: 10.0, // Example cost
  canada_post: 8.0,
  dhl: 12.0
};

function updateTaxInfo() {
  let provinceId = $('#order_province_id').val();
  console.log('Province ID:', provinceId);

  let subtotalText = $('#subtotal').text();  // Ensure this element exists and contains the subtotal
  console.log('Subtotal text:', subtotalText);

  let subtotal = parseFloat(subtotalText.replace(/[^0-9.-]+/g,"")) || 0;
  console.log('Parsed subtotal:', subtotal);

  let ajaxUrl = '/calculate_taxes/' + provinceId;
  console.log('AJAX request URL:', ajaxUrl);

  $.ajax({
    url: ajaxUrl,
    type: 'GET',
    success: function(response) {
      console.log("Tax Response:", response);

      let totalTax = parseFloat(response.tax_amount) || 0;
      let shippingCost = $('input[name="shipping_option"]:checked').val() ? SHIPPING_COSTS[$('input[name="shipping_option"]:checked').val()] : 0;
      let total = subtotal + totalTax + shippingCost;

      console.log('Total Tax:', totalTax, 'Shipping Cost:', shippingCost, 'Total:', total);

      $('#tax_amount').text(`$${totalTax.toFixed(2)}`);
      $('#shipping_cost').text(`$${shippingCost.toFixed(2)}`);
      $('#total_price').text(`$${total.toFixed(2)}`);
    },
    error: function(error) {
      console.error('Error fetching tax info:', error);
    }
  });
}

// Add event listeners for shipping option changes
$('input[name="shipping_option"]').on('change', function() {
  console.log('Shipping option changed');
  updateTaxInfo();
});

$(document).on('change', '#order_province_id', function() {
  console.log('Province dropdown changed');
  updateTaxInfo();
});

$(document).ready(function() {
  console.log('Document ready');
  if ($('#order_province_id').val()) {
    console.log('Province dropdown has a default value');
    updateTaxInfo();
  } else {
    console.log('Province dropdown does not have a default value');
  }
});
