class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
    # Check to see if the king is only moving exactly one space in any direction on the board
  !destination_with_piece_of_same_color?(destination_row, destination_col) && distance(destination_row, destination_col) == 1 
  end
end
