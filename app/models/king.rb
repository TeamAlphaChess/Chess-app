# frozen_string_literal: true
class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
    # Check to see if the king is only moving exactly one space in any direction on the board
    !same_color?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
  end

  def castle!(destination_row, destination_col)
    # this is where we will update the database for the move.
    can_castle?(destination_row, destination_col)
    if destination_col > current_column_index
      move_to!(current_row_index, 6)
      rook_move!(destination_row, destination_col)
    elsif destination_col < current_column_index
      move_to!(current_row_index, 2)
      rook_move!(destination_row, destination_col)
    end
  end

  def can_castle?(destination_row, destination_col)
    # check that king hasn't moved
    return false unless unmoved?
    # check that king moves not obstructed
    return false if obstructed?(destination_row, destination_col)
    # check that current_row_index is the same
    return false if current_row_index != destination_row
    # select rook on correct side and check if it's moved
    if destination_col > current_column_index
      rook_kingside_unmoved?
    else
      rook_queenside_unmoved?
    end
  end

  def rook_kingside_unmoved?
    game.pieces.find_by(
      current_row_index: current_row_index,
      current_column_index: 7,
      type: 'Rook').unmoved?
  end

  def rook_queenside_unmoved?
    game.pieces.find_by(
      current_row_index: current_row_index,
      current_column_index: 0,
      type: 'Rook').unmoved?
  end

  def rook_move!(_destination_row, destination_col)
    if destination_col > current_column_index
      rook = game.pieces.find_by(type: 'Rook', current_row_index: current_row_index, current_column_index: 7)
      rook.update_rook_kingside(0, 7)
    elsif  destination_col < current_column_index
      rook = game.pieces.find_by(type: 'Rook', current_row_index: current_row_index, current_column_index: 0)
      rook.update_rook_queenside(0, 0)
    end
  end
end
