# frozen_string_literal: true
class Pawn < Piece
  # rubocop:disable CyclomaticComplexity
  # rubocop:disable PerceivedComplexity
  # rubocop:disable AbcSize
  def valid_move?(destination_row, destination_col)
    if current_row_index == 1 || current_row_index == 6
      # Returns false if you try to move more then 2 spots when not in the pawn spawn rows
      return false if distance(destination_row, destination_col) > 2 || invalid_input?(destination_row, destination_col)
    elsif distance(destination_row, destination_col) > 1
      # Returns false if you try to move more then 1 spot
      return false
    end

    # Returns false if you try to move backwards
    if color == 'white'
      return false if destination_row < current_row_index
    elsif color == 'black'
      return false if destination_row > current_row_index
    end

    if vertical?(destination_row, destination_col) && !spot_taken?(destination_row, destination_col) || diagonal?(destination_row, destination_col) && spot_taken?(destination_row, destination_col) && !same_color?(destination_row, destination_col)
      true
    else
      false
    end

  end

  def en_passant?(current_row_index, current_column_index)
  # en passant pseudo-code:
  # move_count is stored in pieces db
  # and column of opponent pawn is now = current pawn column + or - 1 (i.e. is adjacent)

    if color == 'white' && current_row_index == 4
      #check the columns adjacent and on row 2 for pawns
    left_spot_piece = game.pieces.find_by_current_row_index_and_current_column_index(current_row_index + 1, current_column_index - 1) unless current_column_index == 0

    right_spot_piece = game.pieces.find_by_current_row_index_and_current_column_index(current_row_index + 1, current_column_index + 1) unless current_column_index == 7
      #If pawns are found check to make sure they got there in one move
      if (left_spot_piece.type == 'Pawn' && left_spot_piece.move_count == 1 && left_spot_piece.color == 'black') || (right_spot_piece.type == 'Pawn' && right_spot_piece.move_count == 1 && right_spot_piece.color == 'black')
        return true
      # else
      #   false
      end
    elsif color == 'black' && current_row_index == 3
      #check the columns adjacent and on row 2 for pawns
    left_spot_piece = game.pieces.find_by_current_row_index_and_current_column_index(current_row_index - 1, current_column_index - 1) unless current_column_index == 0

    right_spot_piece = game.pieces.find_by_current_row_index_and_current_column_index(current_row_index - 1, current_column_index + 1) unless current_column_index == 7
      #If pawns are found check to make sure they got there in one move
      if (left_spot_piece.type == 'Pawn' && left_spot_piece.move_count == 1 && left_spot_piece.color == 'white') || (right_spot_piece.type == 'Pawn' && right_spot_piece.move_count == 1 && right_spot_piece.color == 'white')
        return true
      # else
      #   false
      end
    # else
    #   false
    end
  end
  # and row of opponent = current pawn row
  # then current pawn moves to opponent pawn column, and - 1 row if current pawn is black or +1 row if current pawn is white
  # and opponent pawn gets captured (current_row_index: nil, current_column_index: nil, captured: true)

end




