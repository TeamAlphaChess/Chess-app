$(document).ready(function() {

    $('#signUpModalTrigger').on('click', function() {
      $('#signUpModal').modal('toggle');
      $('.modal').css({'display': 'flex', 'align-items': 'center', 'justify-content': 'center'});
    });
});
