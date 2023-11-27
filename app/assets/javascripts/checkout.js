$('#order_province_id').on('change', function(event) {
  event.stopPropagation();

  $(document).on('turbolinks:load', function() {
    $('#order_province_id').on('change', function() {
      var provinceId = $(this).val();
      $.ajax({
        url: '/calculate_taxes',
        type: 'GET',
        data: { province_id: provinceId },
        success: function(response) {
          // Update your form with response data
          $('#tax_amount').text(response.tax_amount);
          $('#total_price').text(response.total_price);
        }
      });
    });
  });

});