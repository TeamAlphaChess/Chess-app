# frozen_string_literal: true
class Pawn < Piece
  # rubocop:disable CyclomaticComplexity
  # rubocop:disable PerceivedComplexity
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

    if vertical?(destination_row, destination_col) && !spot_taken?(destination_row, destination_col) || diagonal?(destination_row, destination_col) && spot_taken?(destination_row, destination_col) && !same_color?(destination_row, destination_col) || en_passant?(destination_row, destination_col)
      true
    else
      false
    end
  end

  def en_passant?(row_index, column_index)
    if color == 'white' && current_row_index == 4
      # check for the pawn that is to be captured(it is behind the spot you are moving too)
      capture_piece = game.pieces.find_by_current_row_index_and_current_column_index(row_index - 1, column_index)
      capturable?(capture_piece, 'black')
    elsif color == 'black' && current_row_index == 3
      # check for the pawn that is to be captured(it is behind the spot you are moving too)
      capture_piece = game.pieces.find_by_current_row_index_and_current_column_index(row_index + 1, column_index)
      capturable?(capture_piece, 'white')
    else
      false
    end
  end

  private

  def capturable?(piece, color)
    # If pawn is found in the capture_piece spot check to make sure it got there in one move
    if piece.type == 'Pawn' && piece.move_count == 1 && piece.color == color
      true
    else
      false
    end
  end
end
