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

  # Check to see if King can castle move to destination_row, destination_col
  def can_castle?(destination_row, destination_col)
    # Check to see if king and rook are in original positions
    #return false if @rook_castle.has_moved?
    return false if has_moved?



    # Is the king in check?
    # check?()
  end

  def castle!(rook)
    # this is where we will update the database for the move.
    # return false if !can_castle?

    if rook.kingside?
      castle_kingside(rook_position)
    else
      castle_queenside(rook_position)
    end
  end

  def valid_castle_move?(destination_row, destination_col)
    # check that king hasn't moved

    # check that king moves exactly two spaces

    # check that current_row_index is the same
    #if current_row_index == destination_row
    # select rook from queenside or kingside
    if destination_col > current_column_index
      # castle on kingside
      @rook_castle = rook_castle('King')
      @update_king_destination_col = 6
      @update_rook_destination_col = 5
      #castle_kingside

    else 
      # castle on queenside
      @rook_castle = rook_castle('Queen')
      @update_king_destination_col = 2
      @update_rook_destination_col = 3
      #castle_queenside

    end
  end

  def rook_castle(side)
    case side
      # when case is King
    when 'King'
      # return kingside rook object
      game.pieces.find_by(
        current_row_index: destination_row, 
        current_column_index: 7, 
        type: 'Rook',
        updated_at: nil)

    when 'Queen'
      # return queenside rook object
      game.pieces.find_by(
        current_row_index: destination_row, 
        current_column_index: 0, 
        type: 'Rook', 
        updated_at: nil)

    else
      # return nil if there is no rook there so we pass it into valid_castle_move_method
      return nil
    end
  end


  # def castle_kingside(rook)
  #   # Rook will always end up in either row_index 3 or 5
  #    move_to!(destination_row, destination_col)
  #    rook.move_to!(0,5)
  #    rook.rook_position(0,7) || rook.rook_position(7,7)
  # end

  # def castle_queenside(rook)
  #   rook.rook_position(7,0) || rook.rook_position(0,0)
  # end

  def rook_castle_kingside(destination_row, destination_col)
    game.pieces.find_by(
      current_row_index: destination_row, 
      current_column_index: 7, 
      type: 'Rook').unmoved?
  end


  def rook_castle_queenside(destination_row, destination_col)
    game.pieces.find_by(
        current_row_index: current_row_index,
        current_column_index: destination_col,
        type: 'Rook', 
        updated_at: nil).unmoved?
  end

  
end
