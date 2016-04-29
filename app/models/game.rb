# frozen_string_literal: true
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  belongs_to :winner, class_name: 'User'
  has_many :pieces, dependent: :destroy
  after_create :populate_board!

  # Ready to get set up for Ajax Requests
  # Need to add json renderer here
  # In Ajax, make sure on success, the offset count is
  # incremented by 10
  def self.list_available_games(offset_count = 0)
    Game.where(black_player_id: nil).offset(offset_count).limit(20)
  end

  def populate_board! # rubocop:disable Metrics/AbcSize
    (0..7).each do |i|
      pieces.create(color: 'white', type: 'Pawn', current_row_index: 1,
                    current_column_index: i)
    end

    pieces.create(color: 'white', type: 'Rook', current_row_index: 0, current_column_index: 0)
    pieces.create(color: 'white', type: 'Rook', current_row_index: 0, current_column_index: 7)

    pieces.create(color: 'white', type: 'Knight', current_row_index: 0, current_column_index: 1)
    pieces.create(color: 'white', type: 'Knight', current_row_index: 0, current_column_index: 6)

    pieces.create(color: 'white', type: 'Bishop', current_row_index: 0, current_column_index: 2)
    pieces.create(color: 'white', type: 'Bishop', current_row_index: 0, current_column_index: 5)

    pieces.create(color: 'white', type: 'Queen', current_row_index: 0, current_column_index: 3)

    pieces.create(color: 'white', type: 'King', current_row_index: 0, current_column_index: 4)

    (0..7).each do |i|
      pieces.create(color: 'black', type: 'Pawn', current_row_index: 6,
                    current_column_index: i)
    end

    pieces.create(color: 'black', type: 'Rook', current_row_index: 7, current_column_index: 0)
    pieces.create(color: 'black', type: 'Rook', current_row_index: 7, current_column_index: 7)

    pieces.create(color: 'black', type: 'Knight', current_row_index: 7, current_column_index: 1)
    pieces.create(color: 'black', type: 'Knight', current_row_index: 7, current_column_index: 6)

    pieces.create(color: 'black', type: 'Bishop', current_row_index: 7, current_column_index: 2)
    pieces.create(color: 'black', type: 'Bishop', current_row_index: 7, current_column_index: 5)

    pieces.create(color: 'black', type: 'Queen', current_row_index: 7, current_column_index: 3)

    pieces.create(color: 'black', type: 'King', current_row_index: 7, current_column_index: 4)
  end

  # def stalemate?(color)
  #   #king = pieces.find_by_type_and_color(King, color)
  #
  #   check_these_pieces = remaining_pieces_of(color)
  #   check_these_coords = all_coords
  #   pieces_that_cause_check = []
  #   pieces_that_can_be_moved_without_causing_check = []
  #   valid_moves = []
  #
  #   # Determine if the game is in the state of a stalemate.
  #   # A stalemate happens when a player cannot make a legal move without
  #   # moving themself into check.
  #
  #   check_these_pieces.each do |our_piece|
  #     check_these_coords.each do |x,y|
  #       # Check to see if the piece will can move to that coord
  #       if our_piece.valid_move?(x,y)
  #         # A piece on the board CAN be moved to the coord
  #
  #         valid_moves << [x,y]
  #         # # If a enemy piece is in a spot that is a valid move, this acts like it takes the piece temp
  #         # old_piece = pieces.find_by_current_row_index_and_current_column_index(x,y)
  #         # if !old_piece.nil?
  #         #   old_piece.current_row_index = nil
  #         #   old_piece.current_column_index = nil
  #         # end
  #         #
  #         # our_piece.current_row_index = x
  #         # our_piece.current_column_index = y
  #
  #         #return our_piece
  #
  #         # # If it causes check
  #         # if temp_move_piece_and_then_check(color, our_piece, x, y)
  #         #   pieces_that_cause_check << our_piece
  #         # else
  #         #   # Does not cause check so the move is good
  #         #   pieces_that_can_be_moved_without_causing_check << our_piece
  #         # end
  #
  #         # if in_check_for_stalemate?(color, piece, x, y)
  #         #   # Moving this piece will cause us to be in check, if all the pieces cause this
  #         #   # to happen its a stalemate
  #         #   #true
  #         #
  #         # else
  #         #   # Moving this piece does not put us in check, so not a stalemate
  #         #    #return piece
  #         # end
  #
  #       end
  #     end
  #     return valid_moves
  #   end
  # end

  def stalemate?(color)
    check_these_pieces = remaining_pieces_of(color)
    check_these_coords = all_coords

    check_these_pieces.each do |our_piece|
      check_these_coords.each do |x,y|
        if our_piece.valid_move?(x,y)
          # Check to see if moving the piece to the coords causes check
          if temp_move_piece_and_then_check(color, our_piece, x, y)
            # Check next piece
          else
            # Moving the piece does not cause check so theres no stalemate
            return false
          end
        end
      end
    end
  end

  def temp_move_piece_and_then_check(color, move_piece, x, y)
    king = pieces.find_by_type_and_color(King, color)
    opponent_pieces = opposite_remaining_pieces_of(color)

    # Check for an old piece in the coords and then remove it from the checked set since were simulating a capture
    old_piece = pieces.find_by_current_row_index_and_current_column_index(x,y)
    if !old_piece.nil?
      opponent_pieces.delete(old_piece)
    end

    # Remember the pieces original spot
    old_x_position_of_piece_to_move = move_piece.current_row_index
    old_y_position_of_piece_to_move = move_piece.current_column_index

    # Change the row and column of the piece we are moving
    move_piece.update_attributes(current_row_index: x)
    move_piece.update_attributes(current_column_index: y)

    # Check to see if in check?
    opponent_pieces.each do |piece|
      if piece.valid_move?(king.current_row_index, king.current_column_index)
        move_piece.update_attributes(current_row_index: old_x_position_of_piece_to_move)
        move_piece.update_attributes(current_column_index: old_y_position_of_piece_to_move)
        return true
      end
    end
    move_piece.update_attributes(current_row_index: old_x_position_of_piece_to_move)
    move_piece.update_attributes(current_column_index: old_y_position_of_piece_to_move)
    false
  end

  def in_check?(color)
    king = pieces.find_by_type_and_color(King, color)
    opponent_pieces = opposite_remaining_pieces_of(color)

    opponent_pieces.each do |piece|
      return true if piece.valid_move?(king.current_row_index, king.current_column_index)
    end
    false
  end

  def opposite_remaining_pieces_of(color)
    remaining_pieces = []

    if color == 'white'
      pieces.where(color: 'black', captured: false).each do |piece|
        remaining_pieces << piece
      end
    else
      pieces.where(color: 'white', captured: false).each do |piece|
        remaining_pieces << piece
      end
    end
    return remaining_pieces
  end

  def remaining_pieces_of(color)
    the_pieces = []

    pieces.where(color: color, captured: false).each do |piece|
      the_pieces << piece
    end

    return the_pieces
  end

  def empty_spots
    spots = [[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
             [1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],
             [2,0],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],
             [3,0],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],
             [4,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],
             [5,0],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],
             [6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],
             [7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7]]

    taken_spots = []

    spots.each do |x,y|
      if pieces.find_by_current_row_index_and_current_column_index(x, y)
        taken_spots << [x,y]
      end
    end

    empty_spots = spots - taken_spots
    return empty_spots
  end

  def all_coords
    coords = [[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
             [1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],
             [2,0],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],
             [3,0],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],
             [4,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],
             [5,0],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],
             [6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],
             [7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7]]
    return coords
  end


end
