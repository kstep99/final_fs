console.log('checkout.js loaded');

// Constants for shipping costs
const SHIPPING_COSTS = {
  purolator: 10.0,
  canada_post: 8.0,
  dhl: 12.0
};

function updateTotalCosts() {
  let provinceId = $('#order_province_id').val();
  console.log('Province ID:', provinceId);

  let subtotalText = $('#subtotal').text();  // Ensure this element exists and contains the subtotal
  console.log('Subtotal text:', subtotalText);

  let shippingOption = $('input[name="shipping_option"]:checked').val();
  let shippingCost = shippingOption ? SHIPPING_COSTS[shippingOption] : 0;
  console.log('Selected shipping cost:', shippingCost);

  let ajaxUrl = '/calculate_taxes/' + provinceId;
  console.log('AJAX request URL:', ajaxUrl);

  $.ajax({
    url: ajaxUrl,
    type: 'GET',
    success: function(response) {
      console.log("Tax Response:", response);

      let totalTax = parseFloat(response.tax_amount) || 0;
      let backendTotal = parseFloat(response.total_price) || 0;
      let total = backendTotal + shippingCost;

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

// Ensure the script is executed after the DOM is fully loaded
$(document).ready(function() {
  console.log('Document ready');

  // Check if the full_name element exists before trying to access its value
  let fullNameElement = document.querySelector('[name="full_name"]');
  if (fullNameElement) {
    console.log("Full Name:", fullNameElement.value);
  }

  // Event listeners for shipping option changes
  $('input[name="shipping_option"]').on('change', function() {
    console.log('Shipping option changed:', $(this).val());
    updateTotalCosts(); // Update the total costs whenever a shipping option changes
  });

  // Event listener for province dropdown changes
  $('#order_province_id').on('change', function() {
    console.log('Province dropdown changed');
    updateTotalCosts(); // Update the total costs whenever the province changes
  });

  // Update costs on initial load if a province is already selected
  if ($('#order_province_id').val()) {
    console.log('Province dropdown has a default value');
    updateTotalCosts();
  } else {
    console.log('Province dropdown does not have a default value');
  }
});
