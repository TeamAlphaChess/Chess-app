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
    #update_position(current_row_index, king_new_destination_col)
    # rook.update_position(current_row_index, update_rook_column)
  end

  def can_castle?(destination_row, destination_col)
    # check that king and rook hasn't moved
    return false if !unmoved?
    # check that king moves not obstructed
    return false if obstructed?(destination_row, destination_col)
    # check that current_row_index is the same
    return false if current_row_index != destination_row
    # select rook 

    # determine if rook is from queenside or kingside

    if destination_col > current_column_index
      # castle on kingside
      # get the rook on kingside and save to variable 
      return false unless rook_kingside_unmoved?
      rook = game.pieces.find_by(
        current_row_index: current_row_index, 
        current_column_index: 7, 
        type: 'Rook')
      rook.update_position(current_row_index, 3) 
      updated_king = self.update_position(current_row_index, 6)
      
    elsif destination_col < current_column_index
      # castle on queenside
      # get the rook on queenside and save to variable
      return false unless rook_queenside_unmoved?
      rook = game.pieces.find_by(
        current_row_index: current_row_index, 
        current_column_index: 0, 
        type: 'Rook')
      rook.update_position(current_row_index, 3) 
      updated_king = update_position(current_row_index, 2)
    else nil
    end
    
    return false if rook.nil?
    #return false unless (king_new_destination_col - current_column_index).abs == 2
    true
  end

  def king_new_destination_kingside
    update_position(current_row_index, 6)
  end

  def king_new_destination_queenside
    update_position(current_row_index, 2)
  end

  def rook_new_destination_kingside
    update_position(current_row_index, 5)
  end

  def rook_new_destination_queenside
    update_position(current_row_index, 3)
  end

  # def rook_castle(destination_row, destination_col)
  #   case side

  #   when 'King'
  #     # return kingside rook object to pass into next method
  #     return nil unless rook_kingside_unmoved?
  #     game.pieces.find_by(
  #       current_row_index: current_row_index, 
  #       current_column_index: 7, 
  #       type: 'Rook')

  #   when 'Queen'
  #     # return queenside rook object to pass into next method
  #     return nil unless rook_queenside_unmoved?
  #     game.pieces.find_by(
  #       current_row_index: current_row_index, 
  #       current_column_index: 0, 
  #       type: 'Rook')
      
  #   else
  #     # return nil if there is no rook there so we pass it into can_castle? method
  #     # otherwise throws error for false
  #     return nil
  #   end
  # end

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

  # def rook_kingside
  #   game.pieces.find_by(
  #     current_row_index: current_row_index, 
  #     current_column_index: 7, 
  #     type: 'Rook')
  # end

  # def rook_queenside
  #   game.pieces.find_by(
  #     current_row_index: current_row_index,
  #     current_column_index: 0,
  #     type: 'Rook')
  # end
end
