# frozen_string_literal: true
class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :user, class_name: 'User'

  # Include Obstructions conern for can_be_blocked? methods
  include Obstructions

  def obstructed?(destination_row, destination_col)
    invalid_input?(destination_row, destination_col) ||
      invalid_horizontal_move?(destination_row, destination_col) ||
      invalid_vertical_move?(destination_row, destination_col) ||
      invalid_diagonal_move?(destination_row, destination_col)
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
    return false if (current_row_index - destination_row).abs == 1
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
    array.each do |row, col|
      return true if game.pieces.where(current_row_index: row, current_column_index: col).exists?
    end
    false
  end

  def invalid_input?(destination_row, destination_col)
    destination_row > 7 || destination_col > 7 || destination_row < 0 || destination_col < 0
  end

  def same_color?(destination_row, destination_col)
    # method describes that we are assessing color of destination location piece
    game.pieces.where(current_row_index: destination_row, current_column_index: destination_col, color: color).count > 0
  end

  def distance(destination_row, destination_col)
    if vertical?(destination_row, destination_col)
      return (destination_row - current_row_index).abs
    end
    if horizontal?(destination_row, destination_col)
      return (destination_col - current_column_index).abs
    end
    if diagonal?(destination_row, destination_col)
      # We're taking advantage of the fact that our diagonal? method
      # checks for a true diagonal (Equal up/down and left/right) distance
      # Because of this we can only return one number instead of two, and
      # can be sure that the other is equal.
      return (destination_col - current_column_index).abs
    end
  end

  def spot_taken?(destination_row, destination_col)
    game.pieces.where(current_row_index: destination_row, current_column_index: destination_col).exists?
  end

  def move_to!(destination_row, destination_col)
    # First check to see if there is a piece in the location its moving to
    if spot_taken?(destination_row, destination_col)
      blocker_piece = game.pieces.find_by_current_row_index_and_current_column_index(destination_row, destination_col)
      # If the piece here is of Opposite color and not obstructed, remove the piece else the move should fail
      if color != blocker_piece.color && obstructed?(destination_row, destination_col) == false
        # Remove the old piece
        blocker_piece.update_attributes(current_row_index: nil, current_column_index: nil, captured: true)
        # Place piece in the removed pieces location

        update_attributes(current_row_index: destination_row, current_column_index: destination_col, move_count: move_count + 1)

        return blocker_piece
      end
      # There is not a piece in the spot so check the obstructions next
    elsif obstructed?(destination_row, destination_col) == false
      # move the piece to the location
      update_attributes(current_row_index: destination_row, current_column_index: destination_col, move_count: move_count + 1)
    end
  end

  # Here destination_row and destination_col is checked_king's position
  def can_be_blocked?(king)
    # Indentify all spots that could obtruct path from threatening piece to checked_king
    obstruction_array = obstructed_spots(king.current_row_index, king.current_column_index)
    # Here opponents are the same color as king
    opponents = game.opposite_remaining_pieces_of(color)
    # Loop thru opponent array
    opponents.each do |opponent|
      # Skip value if it's king
      next if opponent.type == 'King'
      # Call valid move on each of the obstruction array values
      obstruction_array.each do |spot|
        return true if opponent.valid_move?(spot[0], spot[1])
      end
    end
    false
  end

  def can_be_captured?
    # Here color should refer to color of the threatening piece
    opponents = game.opposite_remaining_pieces_of(color)
    success = false
    opponents.each do |opponent|
      # Determine if any opponent piece (same color as checked king) can capture threatening piece
      # Here current_row_index and current_column_index should refer to the threatening piece
      success = true if opponent.valid_move?(current_row_index, current_column_index)
    end
    # Success must be returned outside of each-do loop
    success
  end

  def unmoved?
    updated_at == created_at
  end

  def white?
    color == 'white'
  end

  def black?
    !white?
  end

  def piece_data
    { initial_Row: current_row_index, initial_Column: current_column_index, destination_Row: current_row_index, destination_Column: current_column_index }
  end

  def update_rook_kingside(*)
    update_attributes(current_row_index: current_row_index, current_column_index: 5)
  end

  def update_rook_queenside(*)
    update_attributes(current_row_index: current_row_index, current_column_index: 3)
  end

  def rook_data_initial
    [initialRow: current_row_index, initialColumn: current_column_index]
  end

  def rook_data_final
    [destinationRow: current_row_index, destinationColumn: current_column_index]
  end
end
