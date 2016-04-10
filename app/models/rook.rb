class Rook < Piece
  def valid_move?(destination_row, destination_col)
    # enter code here
    return false if obstructed?(destination_row, destination_col)
    return false if same_color?(destination_row, destination_col)
    
    if horizontal?(destination_row, destination_col) && (!spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col))
      true
    elsif vertical?(destination_row, destination_col) && (!spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col))
      true
    end
  end
end


