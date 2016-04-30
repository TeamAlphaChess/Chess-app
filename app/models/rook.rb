# frozen_string_literal: true
class Rook < Piece
  def valid_move?(destination_row, destination_col)
    return false if diagonal?(destination_row, destination_col)
    return false if obstructed?(destination_row, destination_col)
    return false if same_color?(destination_row, destination_col)

    empty_or_diff_color?(destination_row, destination_col) && (horizontal?(destination_row, destination_col) || vertical?(destination_row, destination_col))
  end

  private

  def empty_or_diff_color?(destination_row, destination_col)
    !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
  end

  def obstructed_spots?(destination_row, destination_col)
    rectilinear_obstructions(destination_row, destination_col)
  end
end
