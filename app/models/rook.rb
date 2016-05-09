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

  # def rook_data_initial_Row
  #   rook_data_initial_Row = current_row_index
  # end

  # def rook_data_initial_Column
  #   rook_data_initial_Column = current_column_index
  # end

  # def rook_data_final
  #   rook_data_final = { destination_Row: current_row_index, destination_Column: current_column_index 
  #   }
  # end

  # def rook_data
  #   rook_data_1 = []
  #   rook_data_1 << rook_data_final
  # end

  private

  def empty_or_diff_color?(destination_row, destination_col)
    !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
  end
end
