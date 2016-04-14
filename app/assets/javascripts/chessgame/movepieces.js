$(document).ready(function() {

  /* ******************************
  THIS FILE WILL BE REFACTORED
  AND DATA WILL BE DIFFERENT
  DO NOT REFERENCE YET!!!
  *********************************/

  // Move Chesspieces
  var isPieceSelected = false;
  var initialSquare;
  var initialSquareRowIndex;
  var initialSquareColumnIndex;
  var initialSquareColorBegin;
  var initialSelectedPiece;
  var initialSelectedPieceId;

  $('.chess-dark-square, .chess-light-square').on('click', function() {
    if (isPieceSelected === false) {
      if ($(this).children().length > 0) {

        initialSquare = $(this);
        initialSelectedPiece = initialSquare.children(':first');
        initialSquareColorBegin = initialSquare.css('background-color');
        initialSquareRowIndex = initialSquare.parent().data('row-index');
        initialSquareColumnIndex = initialSquare.data('column-index');
        initialSelectedPieceId = initialSelectedPiece.data('piece-id');

        initialSquare.css('background-color', 'rgb(248, 155, 56)');
        isPieceSelected = true;
      }
    } else {
      initialSquare.css('background-color', initialSquareColorBegin);
      var finalSquare = $(this);
      var finalSquareRowIndex = finalSquare.parent().data('row-index');
      var finalSquareColumnIndex = finalSquare.data('column-index');

      if ( finalSquare.children(':first').data('piece-id') != initialSelectedPieceId ) {
        var params = {
          initial_square_row_index: initialSquareRowIndex,
          initial_square_column_index: initialSquareColumnIndex,
          final_square_row_index: finalSquareRowIndex,
          final_square_column_index: finalSquareColumnIndex,
          selected_piece_id: initialSelectedPieceId
        }

        // Move piece ajax request begin
        $.ajax({
          method: 'patch',
          url: '/pieces/' + initialSelectedPieceId,
          data: params,
          success: function(data) {
            if (data.validMove === true) {
              // Wrap in if success 200 code
              if (finalSquare.children().length > 0) {
                // use ajax response to tell javascript the piece is captured
                // with that info, adjust the sidebar captured pieces in this
                // code block here.

                finalSquare.children().fadeOut('fast', function() {
                  finalSquare.empty();
                });
              }

              var finalSquarePosition = finalSquare.position();
              var initialSquarePosition = initialSquare.position();

              initialSelectedPiece.animate({
                top: finalSquarePosition.top - initialSquarePosition.top,
                left: finalSquarePosition.left - initialSquarePosition.left
              }, 'slow', function() {

                initialSelectedPiece.appendTo(finalSquare).css({'top': '0', 'left': '0'});
                initialSelectedPiece.height(finalSquare.height() * 0.98);

              });
            } // if validMove === true end
          } // ajax success function end
        }); // ajax request end
      } // if final square != initial square end

      isPieceSelected = false;

    } // if pieceSelected === false end
  }); // Move piece functionality end
});
