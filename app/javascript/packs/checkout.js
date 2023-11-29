console.log('checkout.js loaded');

const SHIPPING_COSTS = {
  purolator: 10.0,
  canada_post: 8.0,
  dhl: 12.0
};

function updateTotalCosts() {
  const provinceId = $('#order_province_id').val();
  const subtotalText = $('#subtotal').text();
  const shippingOption = $('input[name="shipping_option"]:checked').val();
  const shippingCost = SHIPPING_COSTS[shippingOption] || 0;

  console.log('Selected shipping option:', shippingOption);
  console.log('Shipping cost based on option:', shippingCost);

  const ajaxUrl = '/calculate_taxes/' + provinceId;

  $.ajax({
    url: ajaxUrl,
    type: 'GET',
    success: function(response) {
      const totalTax = parseFloat(response.tax_amount) || 0;
      const total = parseFloat(subtotalText.replace(/[^0-9.-]+/g, "")) + totalTax + shippingCost;

      console.log('Response from calculate_taxes:', response);
      console.log('Calculated Total:', total);

      $('#tax_amount').text(`$${totalTax.toFixed(2)}`);
      $('#shipping_cost').text(`$${shippingCost.toFixed(2)}`);
      $('#total_price').text(`$${total.toFixed(2)}`);
    },
    error: function(error) {
      console.error('Error fetching tax info:', error);
    }
  });
}

$(document).ready(function() {
  $('input[name="shipping_option"]').on('change', function() {
    console.log('Shipping option changed to:', $(this).val());
    updateTotalCosts();
  });

  $('#order_province_id').on('change', function() {
    console.log('Province dropdown changed to:', $(this).val());
    updateTotalCosts();
  });

  if ($('#order_province_id').val()) {
    updateTotalCosts();
  }

  const fields = ['full_name', 'address', 'city', 'postal_code', 'province_id'];
  let formData = {};
  fields.forEach(fieldName => {
    let element = document.querySelector(`[name="${fieldName}"]`);
    if (element) {
      formData[fieldName] = element.value;
      console.log(`${fieldName}:`, element.value);
    } else {
      console.log(`${fieldName} element not found.`);
    }
  });

  console.log("Form Data:", formData);
});
