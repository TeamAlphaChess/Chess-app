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


  def castle!
    # this is where we will update the database for the move.
    # update king's position
    self.update_position(current_row_index, @updated_king_destination_col)
    # update rook's position
   # @rook_castle.update_position(current_row_index, @updated_rook_destination_col)
  end

  # Check to see if King can castle move to destination_row, destination_col
  def can_castle?(destination_row, destination_col)
    # Check to see if king and rook are in original positions
    #return false if @rook_castle.has_moved?
    return false if has_moved?



    # Is the king in check?
    # check?()
  end



  def valid_castle_move?(destination_row, destination_col)
    # check that king hasn't moved
    return false if !unmoved?

    # check that king moves not obstructed
    #return false if obstructed?(destination_row, destination_col)

    # check king moves two spaces
    return false unless distance(destination_row, destination_col) == 2
    # check that current_row_index is the same
    return false if current_row_index != destination_row
    # select rook from queenside or kingside
    if destination_col > current_column_index
      # castle on kingside
      # get the rook on kingside and save to variable 
      @rook_castle = rook_castle('King')
      @updated_king_destination_col = 6
      @updated_rook_destination_col = 5
      #castle_kingside

    else 
      # castle on queenside
      # get the rook on queenside and save to variable
      @rook_castle = rook_castle('Queen')
      @updated_king_destination_col = 2
      @updated_rook_destination_col = 3
      #castle_queenside
    end

    return false if @rook_castle.nil?

    return false unless @rook_castle.unmoved?

    true
  end

  def rook_castle(side)
    case side

    when 'King'
      # return kingside rook object to pass into next method
      return false unless rook_castle_kingside
      game.pieces.find_by(
        current_row_index: current_row_index, 
        current_column_index: 7, 
        type: 'Rook')

    when 'Queen'
      # return queenside rook object to pass into next method
      return false unless rook_castle_queenside
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
