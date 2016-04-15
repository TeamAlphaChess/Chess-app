# frozen_string_literal: true
class King < Piece
  # Should determine if the king piece can move to the designated spot
  def valid_move?(destination_row, destination_col)
    # Evaluate piece with invalid_destination to make sure there is not already a piece in the
    # destination_row/destination_column of the same color
    # Check to see if the king is only moving exactly one space in any direction on the board
    !same_color?(destination_row, destination_col) && 
    distance(destination_row, destination_col) == 1
  end

  def castle!(destination_row, destination_col)
    # this is where we will update the database for the move.
    can_castle?(destination_row, destination_col)
    
    update_position(current_row_index, @updated_king_destination_col)
    @rook_castle.update_position(current_row_index, @updated_rook_destination_col)
  end

  def can_castle?(destination_row, destination_col)
    # check that king hasn't moved
    return false if !unmoved?
    # check that king moves not obstructed
    return false if obstructed?(destination_row, destination_col)
    # check that current_row_index is the same
    return false if current_row_index != destination_row
    # check distance is 2 spaces
    return false unless (destination_col - current_column_index).abs 
    # select rook from queenside or kingside
    if destination_col > current_column_index
      # castle on kingside
      # get the rook on kingside and save to variable 
      @rook_castle = rook_castle('King')
      @updated_king_destination_col = 6
      @updated_rook_destination_col = 5

    else 
      # castle on queenside
      # get the rook on queenside and save to variable
      @rook_castle = rook_castle('Queen')
      @updated_king_destination_col = 2
      @updated_rook_destination_col = 3
    end
    return false if @rook_castle.nil?
    return false unless (@updated_king_destination_col - current_column_index).abs == 2
    return false unless @rook_castle.unmoved?
    true
  end

  def rook_castle(side)
    case side

    when 'King'
      # return kingside rook object to pass into next method
      return nil unless rook_castle_kingside
      game.pieces.find_by(
        current_row_index: current_row_index, 
        current_column_index: 7, 
        type: 'Rook')

    when 'Queen'
      # return queenside rook object to pass into next method
      return nil unless rook_castle_queenside
      game.pieces.find_by(
        current_row_index: current_row_index, 
        current_column_index: 0, 
        type: 'Rook')
      
    else
      # return nil if there is no rook there so we pass it into valid_castle_move_method
      return nil
    end
  end

  def rook_castle_kingside
    game.pieces.find_by(
      current_row_index: current_row_index, 
      current_column_index: 7, 
      type: 'Rook').unmoved?
  end

  def rook_castle_queenside
    game.pieces.find_by(
      current_row_index: current_row_index,
      current_column_index: 0,
      type: 'Rook').unmoved?
  end
end
