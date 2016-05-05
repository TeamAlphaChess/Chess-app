# frozen_string_literal: true
class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
    # Check to see if the king is only moving exactly one space in any direction on the board
    !same_color?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
  end

  # Should determine if king can move out of check
  def can_move_out_of_check?
    start_row = current_row_index
    start_col = current_column_index
    success = true
    ((current_row_index - 1)..(current_row_index + 1)).each do |destination_row|
      ((current_column_index - 1)..(current_column_index + 1)).each do |destination_col|
        update_attributes(current_row_index: destination_row, current_column_index: destination_col) if valid_move?(destination_row, destination_col)
        # success is changed to true value unless the updated position still puts king in check
        success = false if game.in_check?(color)
        # Reset attributes since this method is only supposed to check to see if king can move not actually move it
        update_attributes(current_row_index: start_row, current_column_index: start_col)
      end
    end
    success
  end

  def castle!(destination_row, destination_col)
    @start_row_index = current_row_index
    @start_col_index = current_column_index

    # This is where we will update the database for the move.
    if destination_col > current_column_index
      move_to!(destination_row, 6)
      rook_move!(destination_row, 7)
    elsif destination_col < current_column_index
      move_to!(current_row_index, 2)
      rook_move!(destination_row, 0)
    end
    king_data
    rook_data(destination_row, destination_col)
  end

  def king_data
    { initial_Row: @start_row_index, initial_Column: @start_col_index, destination_Row: current_row_index, destination_Column: current_column_index }
  end

  def rook_data(destination_row, destination_col)
    if destination_col > current_column_index
      rook = game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 7)
      rook.piece_data
    elsif  destination_col < current_column_index
      rook = game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 0)
      rook.piece_data
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

  def rook_move!(destination_row, destination_col)
    if destination_col > current_column_index
      rook = game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 7)
      # parameters passed into method will be new position
      rook.update_rook_kingside(0, 7)
    elsif  destination_col < current_column_index
      rook = game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 0)
      # parameters passed into method will be new position
      rook.update_rook_queenside(0, 0)
    end
  end
end
