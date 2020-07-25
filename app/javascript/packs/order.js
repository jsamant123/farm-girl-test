$(document).ready(function(){
  $('.datepicker').datepicker();
  $('.datepicker-inline').hide();
  $('#search_order').on('click', function(){
    $('.datepicker-inline').toggle();
  });

  $('.datepicker-days tbody').on('click', function(){
    $('.datepicker-inline').hide();
  });

  $('#search_order').on('change', function(){
    const date = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/orders',
      dataType: "script",
      data: { date: date }
    });
  });
});
