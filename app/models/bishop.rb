# frozen_string_literal: true
class Bishop < Piece
  def valid_move?(destination_row, destination_col)
    return false unless diagonal?(destination_row, destination_col)
    return false if obstructed?(destination_row, destination_col)
    if same_color?(destination_row, destination_col)
      # Move fails
      false
    elsif !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
      # Move passes
      true
    end
  end

  def bishop_can_capture_king?(destination_row, destination_col)
    valid_move?(destination_row, destination_col)
  end
end
