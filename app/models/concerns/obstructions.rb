# frozen_string_literal: true
module Obstructions

  # Here destination_row, destination_col is checked king color
  # Determine if location is already occupied by piece of same color
  # def path_obstructed?(destination_row, destination_col)
  #   checked_king = game.pieces.find_by(current_row_index: destination_row, current_destination_index: destination_col)
  #     remaining_protectors = pieces_remaining(checked_king.color)

  #     remaining_protectors.each do |piece|







  #   # If piece on square is same color as threatened king, then it is a path_obstruction
  
  # end



  # Create an array of square locations [destination_row, destination_col] that will be checked later for obstruction
  # Method checks for diagonal paths such as those used by Queen and Bishop
  def diagonal_obstructions(destination_col, destination_row)

    # Store current_row_index and current_column_index into local variables
    new_row_position = current_row_index
    new_column_position = current_column_index


    obstruction_array = []

    # Check non-diagonal moves
    return [nil] if new_row_position = destination_row
    return [nil] if new_column_position = destination_col

    # Determine horizontal and vertical increments
    row_increment = current_row_index < destination_row ? 1 : -1
    column_increment = current_column_index < destination_col ? 1 : -1

    

    # Make initial move of one towards destination
    new_row_position += row_increment
    new_column_position += column_increment
    # Loop through values until destination_row, destination_col is reached
    while (destination_row - new_row_position).abs > 0 && (destination_col - new_column_position).abs > 0
      # push each coordinate pair into obstruction array
      obstruction_array << [new_row_position, new_column_position]
      new_row_position += row_increment
      new_column_position += column_increment
    end
    # return obstruction array (values will be checked later )
    obstruction_array
  end

  # Create an array of square locations [destination_row, destination_col] that will be checked later for obstruction
  # Method checks for rectilinear paths such as those used by Queen, Rook
  def rectilinear_obstructions(destination_row, destination_col)
    # Store initial variables
    new_row_position = current_row_index
    new_column_position = current_column_index

    obstruction_array = []
    # Determine horizontalincrements
    if new_row_position == destination_row # protector piece is on same row with king 
      # begin moving across column positions
      column_increment = destination_col < new_column_position ? 1 : -1

      new_column_position += column_increment

      while (destination_col - new_column_position).abs > 0
        obstruction_array << [new_row_position, new_column_position]
        new_column_position += column_increment
      end

    elsif new_column_position == destination_col # protector piece is on same column with king
    # begin moving across row positions
      row_increment = destination_row > new_row_position ? 1 : -1

      new_row_position += row_increment

      while (destination_row - new_row_position).abs > 0
        obstruction_array << [new_row_position, new_column_position]
        new_row_position += row_increment
      end
      # return obstruction array (values will be checked later )
      obstruction_array
    end
  end








end