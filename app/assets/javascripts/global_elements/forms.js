$(document).ready(function() {

  /* ====================================
  Action Functions
  ======================================*/

  function openModal(modal) {
    $(modal).modal({
      keyboard: false,
      backdrop: 'static'
    }).css('display', 'flex')
  }

  function closeModal(modal, callback) {
    modal = $(modal);
    modal.modal('hide');
    modal.one('hidden.bs.modal', function (e) {
      resetForm(modal, true);
      if (callback && typeof callback === 'function') {
        callback();
      }
    });
  }

  function resetForm(modal, resetInputs, callback) {
    modal = $(modal);
    modal.find('.form-statuses li').fadeOut('slow', function() {
      $(this).remove();
    });
    modal.find('.form-footer-status').fadeOut('fast', function() {
      $(this).remove();
    });
    if (resetInputs === true) {
      modal.find('.form-inputs input').val('');
      modal.find('.form-footer-link').fadeIn('slow');
    }
    if (callback && typeof callback === 'function') {
      callback();
    }
  }

  // location of 'footer' must be sent in as a string
  // location of 'inputs' must be sent in as object
  // messageType is either 'failure' or 'success'
  function insertStatusMessages(message, messageType, modal, location) {
    modal = $(modal);
    var messageBox;

    if (location === 'inputs') {
      for (var key in message) {
        keyCapitalized = key[0].toUpperCase() + key.substring(1, key.length);
        messageBox = modal.find('[data-statusfor="' + key + '"]');
        messageBox.html('<li>' + keyCapitalized + ' ' + message[key] + '</li>');

        if (messageType === 'success') {
          messageBox.find('li').addClass('form-item-successful').fadeIn('slow');

        } else if (messageType === 'failure') {
          messageBox.find('li').addClass('form-item-error').fadeIn('slow');
        }
      }

    } else if (location === 'footer') {
      messageBox = modal.find('.form-footer-links-and-statuses')
      messageBox.find('.form-footer-link').fadeOut('slow', function() {
        messageBox.append('<div>' + message + '</div');
        if (messageType === 'success') {
          $('.' + messageBox.attr('class') + ' div').addClass('form-footer-status form-item-successful').fadeIn('slow');
        } else if (messageType === 'failure') {
          $('.' + messageBox.attr('class') + ' div').addClass('form-footer-status form-item-error').fadeIn('slow');
        }
      });
    }
  }

  function ajaxResponse(modal, form) {
    modal = $(modal);
    form = $(form);
    $(form).bind('ajax:complete', function(event, response) {

      // this part is not really working :$ so had to
      // manually add reroute to response.status == 201
      if (response.redirect) {
        window.location.replace(this);
      }

      if (response.status === 422) {
        insertStatusMessages(response.responseJSON.errors, 'failure', modal, 'inputs');

      } else if (response.status === 401) {
        insertStatusMessages('Email or password is invalid', 'failure', modal, 'footer');

      } else if (response.status === 201) {
        // If I click the back button after logging in, it goes back to the home screen
        // but need to make sure the user session is destroyed.
        // There's also issues if I logout, then click the back button. It messes up
        // the app a bit.
        insertStatusMessages('Submission is successful!', 'success', modal, 'footer');
        location.href="/games";
      }
    });
      // check line 128 - 134. not sure whether
      // to add this there or here.
      // form.off('ajax:complete');

      // issues with form.off as it's going too quickly. It runs before
      // the ajax response comes in so the code won't be able to catch it.
      // jquery.when().done() doesn't seem to be working.
  }


  /* ====================================
  General Event Listeners
  ======================================*/

  // Open Modal Event Listener
  $('.modal-trigger').on('click', function() {
    openModal($(this).data('modal-to-open'));
  });

  // Close Modal Event Listener
  $('.modal-close').on('click', function() {
    closeModal($(this).data('modal-to-close'));
  });

  // Switch Modals
  $('.change-open-modal').on('click', function() {
    var button = $(this);
    closeModal(button.data('modal-to-close'), function() {
      openModal(button.data('modal-to-open'));
    });
  });

  // Submit form
  // the ajaxResponse callback is going too quickly.
  // jQuery .when(resetForm()).done(ajaxResponse())
  $('form').on('submit', function() {
    var modal = $($(this).data('modalid'));
    var form = $(this);
    resetForm(modal, false, function() {
      ajaxResponse(modal, form);
    });
  });
});
