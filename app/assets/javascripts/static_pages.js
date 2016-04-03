$(document).ready(function() {

    $('#signUpModalTrigger').on('click', function() {
      $('#signUpModal').modal('toggle');
      $('#signUpModal').addClass('modal-flexbox');
    });

    $('#loginModalTrigger').on('click', function() {
      $('#loginModal').modal('toggle');
      $('#loginModal').addClass('modal-flexbox');
    });
});
