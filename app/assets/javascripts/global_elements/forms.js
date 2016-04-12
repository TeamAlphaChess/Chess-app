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
        return callback();
      }
    });
  }

  function resetForm(modal, resetInputs, callback) {
    modal = $(modal);
    modal.find('.form-statuses li').remove();
    modal.find('.form-footer-status').empty().css('display', 'none');
    if (resetInputs === true) {
      modal.find('.form-inputs input').val('');
      modal.find('.form-footer-link').fadeIn('slow');
    }
    if (callback && typeof callback === 'function') {
      return callback();
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
        if (message.hasOwnProperty.call(message, key)) {
          keyCapitalized = key[0].toUpperCase() + key.substring(1, key.length);
          messageBox = modal.find('[data-status-for="' + key + '"]');
          messageBox.html('<li>' + keyCapitalized + ' ' + message[key] + '</li>');

          if (messageType === 'success') {
            messageBox.find('li').addClass('form-item-successful').fadeIn('slow');

          } else if (messageType === 'failure') {
            messageBox.find('li').addClass('form-item-error').fadeIn('slow');
          }
        }
      }

    } else if (location === 'footer') {
      messageBox = modal.find('.form-footer-links-and-statuses')
      messageBox.find('.form-footer-link').fadeOut('slow', function() {
        var formFooterStatus = messageBox.find('.form-footer-status');
        formFooterStatus.html(message);
        if (messageType === 'success') {
          $(formFooterStatus).addClass('form-item-successful').fadeIn('slow').css('display', 'flex');
        } else if (messageType === 'failure') {
          $(formFooterStatus).addClass('form-item-error').fadeIn('slow').css('display', 'flex');
        }
      });
    }
  }

  function ajaxResponse(modal, form) {
    modal = $(modal);
    form = $(form);
    $(form).bind('ajax:complete', function(event, response) {
      if (response.status === 422) {
        insertStatusMessages(response.responseJSON.errors, 'failure', modal, 'inputs');

      } else if (response.status === 401) {
        insertStatusMessages('Email or password is invalid', 'failure', modal, 'footer');

      } else if (response.status === 201) {
        insertStatusMessages('Submission is successful!', 'success', modal, 'footer');
        var redirectOnSuccess = form.data('redirect-on-success');
        if (redirectOnSuccess) {
          window.location.href = redirectOnSuccess;
        } else {
          window.setTimeout(function(){
            closeModal(modal);
          }, 1500);
        }
      }
    });
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
  $('form').on('submit', function(e) {
    var modal = $($(this).data('modal-id'));
    var form = $(this);
    resetForm(modal, false, function() {
      ajaxResponse(modal, form);
    });
  });
});
