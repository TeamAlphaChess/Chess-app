# frozen_string_literal: true
class Queen < Piece
  def valid_move?(destination_row, destination_col)
    !same_color?(destination_row, destination_col) &&
      !invalid_input?(destination_row, destination_col) &&
      valid_direction?(destination_row, destination_col)
  end

  def valid_direction?(destination_row, destination_col)
    horizontal?(destination_row, destination_col) ||
      vertical?(destination_row, destination_col) ||
      diagonal?(destination_row, destination_col)
  end

  def obstructed_spots(destination_row, destination_col)
    rectilinear_obstruction_array(destination_row, destination_col).concat diagonal_obstruction_array(destination_row, destination_col)
  end
end
