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
    # Store initial king position values
    @start_row_index = current_row_index
    @start_col_index = current_column_index
    # Store castling rook's initial position values
    @rook = castling_rook(destination_row, destination_col)
    @rook_start_row_index = @rook.current_row_index
    @rook_start_column_index = @rook.current_column_index
    # This is where we will update the database for the move.
    if destination_col > current_column_index
      move_to!(destination_row, 6)
      rook_move!(destination_row, 7)
    elsif destination_col < current_column_index
      move_to!(current_row_index, 2)
      rook_move!(destination_row, 0)
    end
    king_data
    rook_data_returned
    data_object
  end

  def king_data
    { initialRow: @start_row_index, initialColumn: @start_col_index, destinationRow: current_row_index, destinationColumn: current_column_index }
  end

  def data_object
    data_object = []
    data_object << king_data
    data_object << rook_data_returned
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

  def castling_rook(destination_row, destination_col)
    if destination_col > current_column_index
      game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 7)
    elsif destination_col < current_column_index
      game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 0)
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
      @rook_moved = game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 7)
      @rook_data_initial = []
      @rook_data_initial << @rook_moved.rook_data_initial
      @rook_moved.update_rook_kingside(0, 7)
      @rook_data_final = []
      @rook_data_final << @rook_moved.rook_data_final
    elsif destination_col < current_column_index
      @rook_moved = game.pieces.find_by(type: 'Rook', current_row_index: destination_row, current_column_index: 0)
      @rook_data_initial = []
      @rook_data_initial << @rook_moved.rook_data_initial
      @rook_moved.update_rook_queenside(0, 0)
      @rook_data_final = []
      @rook_data_final << @rook_moved.rook_data_final
    end
  end

  def rook_data_returned
    returned_rook_data = []
    returned_rook_data << @rook_data_initial
    returned_rook_data << @rook_data_final
    flat_data = returned_rook_data.flatten
    Hash[*flat_data.map(&:to_a).flatten]
  end
end
