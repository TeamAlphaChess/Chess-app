$(document).ready(function() {

    $('#signUpModalTrigger').on('click', function() {
      $('#signUpModal').modal('toggle');
      $('#signUpModal').addClass('modal-flexbox');
    });

    $('#loginModalTrigger').on('click', function() {
      $('#loginModal').modal('toggle');
      $('#loginModal').addClass('modal-flexbox');
    });


    $( 'form' ).submit(function( event ) {
      var targetElement = event.target;

      $.ajax({
        method: targetElement.method,
        url: targetElement.action,
        data: $(targetElement).serializeArray(),
        complete: function(response, status) {
          targetElement.innerHTML = response.responseText;
          debugger;
        }
      });
      event.preventDefault();
    });

});
