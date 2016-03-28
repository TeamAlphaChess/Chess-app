class King < Piece

	# Should determine if the king piece can move to the designated spot
	def valid_move?(destination_row, destination_col)
		# Call obstructed method to see if there is already a piece in the
		# destination_row/destination_column
		return false if obstructed?(destination_row, destination_col)

		# Write code to make the piece move.

	end

end
