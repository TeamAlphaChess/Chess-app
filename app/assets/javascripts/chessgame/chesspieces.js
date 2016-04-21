$(document).ready(function() {

  /* ====================================
  Action Functions
  ======================================*/

  // Make sure to detach all pieces before moving them
  // Select the first piece in each square
  // when doing castling, append the piece such that when the next
  // move is done, it selects the first piece.
  var currentPlayerColor = $('#gameBarBottom').data('current-player-color')
  var isPieceSelected = false;
  var allSquares = $('td');
  var initialSquare;
  var initialRow;
  var initialColumn;
  var selectedPiece;
  var selectedPieceId;

  function resetSquares(destinationSquare) {
    allSquares.removeClass('chess-square-states');
    initialSquare.removeClass('chess-selected-square');

    initialSquare = '';
    initialRow = '';
    initialColumn = '';
    selectedPiece = '';
    selectedPieceId = '';
  }

  function renderGameBarMessage(messages) {
    var currentPlayerMessage = messages[$('#gameBarBottom').data('current-player-color')];
    // add message to gamebar.
  }

  function capturePieces(instructions, callback) {
    var piece;
    if (!jQuery.isEmptyObject(instructions)) {
      for (var instruction in instructions) {
        piece = $('tbody').find('tr[data-row-index="' + instructions[instruction].rowIndex + '"]').find('td[data-column-index="' + instructions[instruction].columnIndex + '"]').children(':first');
        piece.fadeOut('fast', function() {
          // Add piece to the game sidebar
          piece.remove();
        });
      }
    }

    if (callback && typeof callback === 'function') {
      return callback();
    }
  }

  function movePieces(instructions, destinationSquare, callback) {
    if (!jQuery.isEmptyObject(instructions)) {

      var processedInstructions = [];
      var attributes;

      for (var instruction in instructions) {

        // [initialSquare, pieceToMove, intialSquarePosition, destinationSquare, destinationSquarePosition]
        attributes = []

        // initialSquare
        attributes.push($('tbody').find('tr[data-row-index="' + instructions[instruction].initialRow + '"]').find('td[data-column-index="' + instructions[instruction].initialColumn + '"]'));

        // pieceToMove
        attributes.push(attributes[0].children(':first'));

        // initialSquarePosition
        attributes.push(attributes[0].position());

        // destinationSquare
        attributes.push($('tbody').find('tr[data-row-index="' + instructions[instruction].destinationRow + '"]').find('td[data-column-index="' + instructions[instruction].destinationColumn + '"]'));

        // destinationSquarePosition
        attributes.push(attributes[3].position());

        // processedInstructions becomes a 2D array
        processedInstructions.push(attributes);

      }

      // for (i = 0; i < processedInstructions.length; i++) {
      //   processedInstructions[0][1].animate({
      //     top: processedInstructions[0][4].top - processedInstructions[0][2].top,
      //     left: processedInstructions[0][4].left - processedInstructions[0][2].left
      //   }, 'slow').appendTo(processedInstructions[0][3]).height(processedInstructions[0][3].height());
      // }
      processedInstructions[0][1].animate({
        left: '50px'
      });
    }

    if (callback && typeof callback === 'function') {
      return callback();
    }
  }

  function createPieces(instructions, callback) {
    if (!jQuery.isEmptyObject(instructions)) {
      // For pawn promotion
    }

    if (callback && typeof callback === 'function') {
      return callback();
    }
  }

  // This will also be used for the pawn promotion form
  function chessPieceAjaxRequest(method, url, data, destinationSquare) {
    $.ajax({
      method: method,
      url: url,
      data: data,
      complete: function(response) {

        var status = response.status;
        response = response.responseJSON;

        if (status === 200) {

          if (response.actionStatus.pawnPromotion == true) {
            alert('pawn promotion works. Implement form to select piece to promote');

          } else {

            // capturePieces(response.captures, function(){
            movePieces(response.moves, destinationSquare, function() {
              // renderGameBarMessage(response.playerMessages);
            });
            // });

          }
        } else {
          // 'Invalid Move etc'
          renderGameBarMessage(response.playerMessages);
        }
      }
    });
  }

  /* ====================================
  Event Listeners
  ======================================*/

  allSquares.on('click', function() {
    if (isPieceSelected === false && $(this).children().length > 0) {
      if ($(this).children(':first').data('piece-color') === currentPlayerColor) {

        initialSquare = $(this);
        initialRow = initialSquare.parent().data('row-index');
        initialColumn = initialSquare.data('column-index');
        selectedPiece = initialSquare.children(':first');
        selectedPieceId = selectedPiece.data('piece-id');
        initialSquare.addClass('chess-selected-square');
        allSquares.addClass('chess-square-states');
        isPieceSelected = true;
      }

    } else {

      var destinationSquare = $(this);
      var destinationRow = destinationSquare.parent().data('row-index');
      var destinationColumn = destinationSquare.data('column-index');

      if (initialRow !== destinationRow || initialColumn !== destinationColumn) {
        var params = {
          destination_row: destinationRow,
          destination_column: destinationColumn
        };

        chessPieceAjaxRequest('PATCH', '/pieces/' + selectedPieceId, params, destinationSquare);
      }

      resetSquares(destinationSquare);
      isPieceSelected = false;
    }
  });
});
