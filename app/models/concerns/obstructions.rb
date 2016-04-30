# frozen_string_literal: true
module Obstructions

  # Determine if a given destination_row, destination_col location is already occupied by piece of same color
  def path_obstructed?(destination_row, destination_col)



    # If piece on square is same color as threatened king, then it is a path_obstruction
  
  end



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
  # Method checks for rectilinear paths such as those used by Queen, Rook, King, Pawn
  def rectilinear_obstructions(destination_row, destination_col)
    # Store initial variables
    new_row_position = current_row_index
    new_column_position = current_column_index

    obstruction_array = []

    if new_row_position = destination_row
      row_increment = destination_row > new_row_position ? 1 : -1
      column_increment = destination_col < new_column_position ? 1 : -1


  end








end