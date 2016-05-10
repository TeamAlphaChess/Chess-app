# frozen_string_literal: true
class Rook < Piece
  def valid_move?(destination_row, destination_col)
    return false if diagonal?(destination_row, destination_col)
    return false if obstructed?(destination_row, destination_col)
    return false if same_color?(destination_row, destination_col)

    empty_or_diff_color?(destination_row, destination_col) && (horizontal?(destination_row, destination_col) || vertical?(destination_row, destination_col))
  end

  def obstructed_spots(destination_row, destination_col)
    rectilinear_obstruction_array(destination_row, destination_col)
  end

  def update_rook_kingside(*)
    update_attributes(current_row_index: current_row_index, current_column_index: 5)
  end

  def update_rook_queenside(*)
    update_attributes(current_row_index: current_row_index, current_column_index: 3)
  end

  def rook_data_initial
    [initialRow: current_row_index, initialColumn: current_column_index]
  end

  def rook_data_final
    [destinationRow: current_row_index, destinationColumn: current_column_index]
  end

  private

  def empty_or_diff_color?(destination_row, destination_col)
    !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
  end
end
