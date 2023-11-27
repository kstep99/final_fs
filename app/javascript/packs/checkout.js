import $ from 'jquery';
import Turbolinks from 'turbolinks';
Turbolinks.start();

$(document).on('turbolinks:load', function() {
  const updateTaxInfo = () => {
    let provinceId = $('#order_province_id').val();

    $.ajax({
      url: '/calculate_taxes',
      type: 'GET',
      data: { province_id: provinceId },
      success: function(response) {
        $('#tax_amount').text(response.tax_amount);
        $('#total_price').text(response.total_price);
      },
      error: function(error) {
        console.error('Error fetching tax info:', error);
      }
    });
  };

  $('#order_province_id').on('change', updateTaxInfo);

  // Trigger the update on page load if a province is selected
  if ($('#order_province_id').val()) {
    updateTaxInfo();
  }
});