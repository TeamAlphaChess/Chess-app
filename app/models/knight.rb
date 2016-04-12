# frozen_string_literal: true
class Knight < Piece
  def valid_move?(destination_row, destination_col)
    return false unless valid_coordinates?(destination_row, destination_col)
    return false if same_color?(destination_row, destination_col)

    # Move passes if spot is empty or has a piece of different color
    return true if !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
    false
  end

  private

  def valid_coordinates?(destination_row, destination_col)
    return true if (current_column_index - destination_col).abs == 1 && (current_row_index - destination_row).abs == 2
    return true if (current_column_index - destination_col).abs == 2 && (current_row_index - destination_row).abs == 1
    false
  end
end
