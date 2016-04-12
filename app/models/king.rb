# frozen_string_literal: true
class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
    # Check to see if the king is only moving exactly one space in any direction on the board
    !same_color?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
  end

  def can_castle?(rook_position)
    # Is the path between king & rook obstructed?
    return false if rook_position.has_moved?
    return false if has_moved?

    # Is the king in check?
    check?()
  end

  def castle!(rook_position)
    # this is where we will update the database for the move.
    return unless can_castle?(rook_position)

  end

  def castle_kingside(rook_position)
    
  end

  def castle_queenside(rook_position)

  end

end
