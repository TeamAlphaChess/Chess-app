class King < Piece

	# Should determine if the king piece can move to the designated spot
	def valid_move?(destination_row, destination_col)
		# Call obstructed method to see if there is already a piece in the
		# destination_row/destination_column
    #if abs(current_row_index, destination_row, current_column_index, destination_col)
      return false unless abs(destination_row - current_row_index) <= 1 
      return false unless abs(destination_col - current_column_index) <= 1 
		  return false if obstructed?(destination_row, destination_col)

		# Write code to make the piece move.
    # Reset king current_column_index and current_row_index to destination_col and destination_row
    if true
      current_row_index = destination_row
      current_column_index = destination_col
    end
	end

  # Write abs method to evaluate distance from king

end
