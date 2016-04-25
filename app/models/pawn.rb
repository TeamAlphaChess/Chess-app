# frozen_string_literal: true
class Pawn < Piece
  # rubocop:disable CyclomaticComplexity
  # rubocop:disable PerceivedComplexity
  def valid_move?(destination_row, destination_col)
    return false if backwards?(destination_row)

    if white_pawn_in_starting_row? || black_pawn_in_starting_row?
      # Returns false if you try to move more then 2 spots when not in the pawn spawn rows
      if move_distance(destination_row) > 2
        false
      end
    elsif move_distance(destination_row) > 1
      # Returns false if you try to move more then 1 spot
      return false
    end

    if can_move_forward?(destination_row, destination_col) || can_capture?(destination_row, destination_col) || en_passant?(destination_row, destination_col)
      true
    else
      false
    end
  end

  def en_passant?(row_index, column_index)
    if white? && on_fifth_rank?
      target_piece = find_piece_above_destination(row_index, column_index)
      capturable?(target_piece, 'black')
    elsif black? && on_fifth_rank?
      target_piece = find_piece_under_destination(row_index, column_index)
      capturable?(target_piece, 'white')
    else
      false
    end
  end

  def first_move?
    if white_pawn_in_starting_row? || black_pawn_in_starting_row?
      distance == 2
    end
  end

  def find_piece_under_destination(row, col)
    game.pieces.find_by_current_row_index_and_current_column_index(row + 1, col)
  end

  def find_piece_above_destination(row, col)
    game.pieces.find_by_current_row_index_and_current_column_index(row - 1, col)
  end

  def white_pawn_in_starting_row?
    current_row_index == 1
  end

  def black_pawn_in_starting_row?
    current_row_index == 6
  end


  private

  def on_fifth_rank?
    white? && current_row_index == 4 || black? && current_row_index == 3
  end

  def backwards?(new_row)
    if white? && new_row < current_row_index
      true
    elsif black? && new_row > current_row_index
      true
    elsif white? && new_row > current_row_index
      false
    elsif black? && new_row < current_row_index
      false
    end
  end

  def can_move_forward?(destination_row, destination_col)
    vertical?(destination_row, destination_col) && !spot_taken?(destination_row, destination_col)
  end

  def can_capture?(destination_row, destination_col)
    diagonal?(destination_row, destination_col) && spot_taken?(destination_row, destination_col) && !same_color?(destination_row, destination_col)
  end

  def capturable?(piece, color)
    # Find last move made in game
    last_updated = game.pieces.order('updated_at').last
    # If pawn is found in the capture_piece spot check to make sure it got there in one move and it is of the opposite color and it was the last move made
    if piece.type == 'Pawn' && piece.move_count == 1 && piece.color == color && piece == last_updated
      true
    else
      false
    end
  end

  def move_distance(destination_row)
    (destination_row - current_row_index).abs
  end
end
