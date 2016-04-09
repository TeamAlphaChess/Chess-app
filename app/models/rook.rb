class Rook < Piece
  def valid_move?(destination_row, destination_col)
    # enter code here
    return false unless horizontal?(destination_row, destination_col) || vertical?(destination_row, destination_col)
    return false if obstructed?(destination_row, destination_col)
    return false if same_color?(destination_row, destination_col)
    
    if !spot_taken?(destination_row, destination_col) || !same_color?(destination_row, destination_col)
      true
    end
  end
end
