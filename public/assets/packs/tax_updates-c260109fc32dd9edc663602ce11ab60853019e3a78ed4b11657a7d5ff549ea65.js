$(document).on('turbolinks:load', function() {
  $('#province_selector').on('change', function() {

    $(document).on('turbolinks:load', function() {
      $('#province_selector').on('change', function() {
        var provinceId = $(this).val();
        // Assuming you have an endpoint that returns tax rates based on province id
        $.get('/tax_rates/' + provinceId, function(data) {
          $('#taxes').html(data);
          // Update your total cost display here
        });
      });
    });
  });
});
