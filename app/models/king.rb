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
    # Create hash table for frontend logic
    rook_data = {
      :initialRow => destination_row, 
      :initialColumn => 7,
      :destinationRow => destination_row,
      :destinationColumn => 5}
    king_data = {
      :initialRow => destination_row, 
      :initialColumn => 4,
      :destinationRow => destination_row,
      :destinationColumn => 6}
    
    # This is where we will update the database for the move.
    if destination_col > current_column_index
      #update_rook_kingside(current_row_index, 7)
      move_to!(destination_row, 6)
      rook_move!(destination_row, 7)
  
    elsif destination_col < current_column_index
      #update_rook_queenside(current_row_index, 0)
      move_to!(current_row_index, 2)
      rook_move!(destination_row, 0)

    end

    # return_data = []
    # rook_data.destinationColumn
    # return_data << king_data
    # return_data << rook_data
  end

  def king_data 
    king_data = {
      :initialRow => current_row_index, 
      :initialColumn => current_column_index,
      :destinationRow => current_row_index,
      :destinationColumn => 3
      }
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
      game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 7)
      # parameters passed into method will be new position
      update_rook_kingside(destination_row, 5)
    elsif  destination_col < current_column_index
      game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 0)
      # parameters passed into method will be new position
      update_rook_queenside(destination_row, 3)
    end
  end
end
