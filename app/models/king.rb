class King < Piece

	# Should determine if the king piece can move to the designated spot
	def valid_move?(destination_row, destination_col)
		# Call obstructed method to see if there is already a piece in the
		# destination_row/destination_column
		!obstructed?(destination_row, destination_col) && distance(destination_row, destination_col) == 1
	end

  # Write abs method to evaluate distance from king

end
