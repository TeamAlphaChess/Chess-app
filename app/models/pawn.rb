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

  def en_passant
  # en passant pseudo-code:

  # store last_move in database
  # if last_move = opponent pawn moved forward by 2 squares

  # and column of opponent pawn is now = current pawn column + or - 1 (i.e. is adjacent)

  # and row of opponent = current pawn row

  # then current pawn moves to opponent pawn column, and - 1 row if current pawn is black or +1 row if current pawn is white

  # and opponent pawn gets captured (current_row_index: nil, current_column_index: nil, captured: true)
  end
end
