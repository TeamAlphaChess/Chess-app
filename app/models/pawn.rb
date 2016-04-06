class Pawn < Piece
  def valid_move?(destination_row, destination_col)
    # Dont allow horizontal moves
    return false if horizontal?(destination_row, destination_col)
    # Returns false if you try to move forward and the spot is obstructed
    return false if vertical?(destination_row, destination_col) && spot_taken?(destination_row, destination_col)

    if current_row_index == 1 || current_row_index == 6
      # Returns false if you try to move more then 2 spots when not in the pawn spawn rows
      return false if distance(destination_row, destination_col) > 2
    else
      # Returns false if you try to move more then 1 spot
      return false if distance(destination_row, destination_col) > 1
    end

    # Returns false if you try to move backwards
    if color == 'white'
      return false if destination_row < current_row_index
    elsif color == 'black'
      return false if destination_row > current_row_index
    end

    if diagonal?(destination_row, destination_col) && !spot_taken?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
      # Returns false if trying to move diagonal and there is no piece there
      false
    elsif vertical?(destination_row, destination_col) && !spot_taken?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
      # Returns true if it can move forward one space
      true
    elsif vertical?(destination_row, destination_col) && !spot_taken?(destination_row, destination_col) && distance(destination_row, destination_col) == 2
      # Returns true if it can move forward two spaces
      true
    elsif diagonal?(destination_row, destination_col) && spot_taken?(destination_row, destination_col) && !same_color?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
      # Returns true if it can move diagonal to capture a piece
      true
    end
  end
end
