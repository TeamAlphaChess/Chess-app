class Knight < Piece

  def valid_move?(destination_row, destination_col)
    if same_color?(destination_row, destination_col)
      # Move fails
      false
    elsif valid_coordinates(current_column_index, current_row_index, destination_col, destination_row)
      # Move passes
      true
    else
      false
    end

    # def valid_coordinates(x1, y1, x2, y2)
    #   true if (x1-x2).abs == 1 && (y1 - y2).abs == 2
    #   true if (x1-x2).abs == 2 && (y1 - y2).abs == 1
    #   false
    # end
  end
end
