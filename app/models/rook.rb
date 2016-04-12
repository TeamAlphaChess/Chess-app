class Rook < Piece
  def valid_move?(destination_row, destination_col)
    # enter code here
    return false if diagonal?(destination_row, destination_col)
    return false if obstructed?(destination_row, destination_col)
    return false if same_color?(destination_row, destination_col)

    return true if empty_or_diff_color?(destination_row, destination_col) && (horizontal?(destination_row, destination_col) || vertical?(destination_row, destination_col))
  end

  private

  def empty_or_diff_color?(destination_row, destination_col)
    return true if !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
  end
end
