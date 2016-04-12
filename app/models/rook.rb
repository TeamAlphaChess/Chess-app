# frozen_string_literal: true
class Rook < Piece
  # rubocop:disable Metrics/CyclomaticComplexity
  def valid_move?(destination_row, destination_col)
    return false if diagonal?(destination_row, destination_col)
    return false if obstructed?(destination_row, destination_col)
    return false if same_color?(destination_row, destination_col)
    # rubocop:enable Metrics/CyclomaticComplexity

    return true if empty_or_diff_color?(destination_row, destination_col) && (horizontal?(destination_row, destination_col) || vertical?(destination_row, destination_col))
  end

  def is_kingside?
    current_row_index == 7
  end

  private

  def empty_or_diff_color?(destination_row, destination_col)
    return true if !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
  end
end
