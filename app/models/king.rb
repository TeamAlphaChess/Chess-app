# frozen_string_literal: true
class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
    # Check to see if the king is only moving exactly one space in any direction on the board
    !same_color?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
  end

  # Check to see if King can castle move to destination_row, destination_col
  def can_castle?(destination_row, destination_col)
    # Check to see if king and rook are in original positions
    return false if rook.has_moved?
    return false if has_moved?



    # Is the king in check?
    # check?()
  end

  def castle!(rook)
    # this is where we will update the database for the move.
    return false if !can_castle?

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

  def rook_king_side(destination_row, destination_col)
    return false if has_moved?
    return true if game.pieces.find_by(current_row_index: destination_row, current_column_index: 7, type: 'Rook')
  end



  # Locate rook in corner spot with when case logic 
  # Takes 'King' or 'Queen' as argument
  def rook_can_castle(side)
    case side
    when 'King'
      game.pieces.find_by(
        current_row_index: current_row_index,
        current_column_index: 7,
        type: 'Rook')

    when 'Queen'
      game.pieces.find_by(
        current_row_index: current_row_index,
        current_column_index: 0,
        type: 'Rook')

    else 
      return false
    end
  end

end


