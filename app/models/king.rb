# frozen_string_literal: true
class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
    # Check to see if the king is only moving exactly one space in any direction on the board
    !same_color?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
  end

  def can_castle?(rook)
    # Are king and rook in original positions?
    return false if rook.has_moved?
    return false if has_moved?

    # Is the king in check?
    check?()
  end

  def castle!(rook)
    # this is where we will update the database for the move.
    return if !can_castle?(rook_position)

    if rook.kingside?
      castle_kingside(rook_position)
    else
      castle_queenside(rook_position)
    end
  end

  def castle_kingside(rook)
    # Rook will always end up in either row_index 3 or 5
     move_to!(destination_row, destination_col)
     rook.move_to!(0,5)
     rook.rook_position(0,7) || rook.rook_position(7,7)
  end

  def castle_queenside(rook)
    rook.rook_position(7,0) || rook.rook_position(0,0)
  end

  def rook_king_side(rook)
    return false if rook.has_moved?
    return true if game.pieces.find_by(current_row_index: row, current_column_index: col, type: 'Rook')
  end

end
