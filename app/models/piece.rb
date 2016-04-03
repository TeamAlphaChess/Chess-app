class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :user, class_name: 'User'

  def obstructed?(destination_row, destination_col)
    invalid_input?(destination_row, destination_col) ||
    invalid_horizontal_move?(destination_row, destination_col) ||
    invalid_vertical_move?(destination_row, destination_col) ||
    invalid_diagonal_move?(destination_row, destination_col) ||
    invalid_destination?(destination_row, destination_col)
  end

  def horizontal?(destination_row, destination_col)
    # Is the row the same, but the column different?
    (current_row_index == destination_row) && (current_column_index != destination_col)
  end

  def vertical?(destination_row, destination_col)
    # Is the column the same, but the row different?
    (current_column_index == destination_col) && (current_row_index != destination_row)
  end

  def diagonal?(destination_row, destination_col)
    # Are the row and column the same?
    (current_row_index - destination_row).abs == (current_column_index - destination_col).abs
  end

  def invalid_horizontal_move?(destination_row, destination_col)
    return false unless horizontal?(destination_row, destination_col)
    delta_col = current_column_index < destination_col ? 1 : -1
    current_col_position = current_column_index + delta_col
    spaces = []

    while current_col_position != destination_col
      spaces << [destination_row, current_col_position]
      current_col_position += delta_col
    end
    piece_present?(spaces)
  end

  def invalid_vertical_move?(destination_row, destination_col)
    return false unless vertical?(destination_row, destination_col)
    delta_row = current_row_index < destination_row ? 1 : -1
    current_row_position = current_row_index + delta_row
    spaces = []

    while current_row_position != destination_row
      spaces << [current_row_position, destination_col]
      current_row_position += delta_row
    end
    piece_present?(spaces)
  end

  def invalid_diagonal_move?(destination_row, destination_col)
    return false unless diagonal?(destination_row, destination_col)
    delta_row = current_row_index < destination_row ? 1 : -1
    delta_col = current_column_index < destination_col ? 1 : -1
    spaces = []

    current_row_position = current_row_index + delta_row
    current_col_position = current_column_index + delta_col

    while current_row_position != destination_row
      spaces << [current_row_position, current_col_position]
      current_row_position += delta_row
      current_col_position += delta_col
    end
    piece_present?(spaces)
  end

  def piece_present?(array)
    return false if array.empty?
    array.map do |row, col|
      game.pieces.where(current_row_index: row, current_column_index: col)
    end.inject(&:or).count > 0
  end

  def invalid_input?(destination_row, destination_col)
    # Check if destination row or column is outside board bounds
    destination_row > 7 || destination_col > 7 || destination_row < 0 || destination_col < 0 
  end

  def invalid_destination?(destination_row, destination_col)
    # This has a piece in the destination, but not in between the pieces.
    game.pieces.where(current_row_index: destination_row, current_column_index: destination_col, color: color).count > 0
  end

  def same_color?(color)
    game.pieces.where(color: color)
  end

  def distance(destination_row, destination_col)
    if vertical?(destination_row, destination_col)
      return (destination_row - current_row_index).abs
    elsif horizontal?(destination_row, destination_col)
      return (destination_col - current_column_index).abs
    elsif diagonal?(destination_row, destination_col)
      # We're taking advantage of the fact that our diagonal? method
      # checks for a true diagonal (Equal up/down and left/right) distance
      # Because of this we can only return one number instead of two, and
      # can be sure that the other is equal.
      return (destination_col - current_column_index).abs
    else
      raise 'Not Allowed' # Raise error message instead
    end
  end
end
