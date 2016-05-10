# frozen_string_literal: true
class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
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
    # Store initial king position values
    castle_data = []
    start_row = current_row_index
    start_col = current_column_index
    king_data = { initialRow: start_row, initialColumn: start_col }
    # Update the database for the move
    if destination_col > current_column_index
      move_to!(destination_row, 6)
      king_data[:destinationRow] = current_row_index
      king_data[:destinationColumn] = current_column_index
      castle_data << rook_move!(destination_row, 7)
      castle_data.unshift(king_data)
    elsif destination_col < current_column_index
      move_to!(current_row_index, 2)
      king_data[:destinationRow] = current_row_index
      king_data[:destinationColumn] = current_column_index
      castle_data << rook_move!(destination_row, 0)
      castle_data.unshift(king_data)
    end
  end

  def can_castle?(destination_row, destination_col)
    # Check that king hasn't moved
    return false unless unmoved?
    # Check that king moves not obstructed
    return false if obstructed?(destination_row, destination_col)
    # Check that current_row_index is the same
    return false if current_row_index != destination_row
    # Select rook on correct side and check if it's moved
    if destination_col > current_column_index
      rook_kingside.unmoved?
    else
      rook_queenside.unmoved?
    end
  end

  def rook_kingside
    game.pieces.find_by(
      current_row_index: current_row_index,
      current_column_index: 7,
      type: 'Rook')
  end

  def rook_queenside
    game.pieces.find_by(
      current_row_index: current_row_index,
      current_column_index: 0,
      type: 'Rook')
  end

  def rook_move!(_destination_row, destination_col)
    rook_data_initial = []
    rook_data_final = []
    rook_data = []
    if destination_col > current_column_index
      # Locate kingside rook
      rook = rook_kingside
      # Store initial position attributes
      rook_data_initial << rook.rook_data_initial
      # Move castling kingside rook to new coordinates
      rook.update_rook_kingside(0, 7)
      # Store final position attributes
      rook_data_final << rook.rook_data_final
    elsif destination_col < current_column_index
      # Locate queenside rook
      rook = rook_queenside
      # Store initial position attributes
      rook_data_initial << rook.rook_data_initial
      # Move castling queenside rook to new coordinates
      rook.update_rook_queenside(0, 0)
      # Store final position attributes
      rook_data_final << rook.rook_data_final
    end
    rook_data << rook_data_initial
    rook_data << rook_data_final
    flat_rook_data = rook_data.flatten
    Hash[*flat_rook_data.map(&:to_a).flatten]
  end
end
