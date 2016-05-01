$(document).ready(function() {

  // Making chessboard height equal to width
  var chessBoard = $('#chessBoard');
  chessBoard.height(chessBoard.width());

  $(window).resize(function() {
    chessBoard.height(chessBoard.width());
    $('.chess-piece').height( 0.125 * 0.98 * chessBoard.width());
  }); // End Making chessboard height equal to width


}); // document.ready end
