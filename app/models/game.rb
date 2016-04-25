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

  def stalemate?(color)
    #king = pieces.find_by_type_and_color(King, color)
    # Can any piece on the board be moved (check different co-ords)
    check_these_pieces = opposite_remaining_pieces_of(color)
    open_spots = empty_spots

    check_these_pieces.each do |piece|
      open_spots.each do |x,y|
        if piece.valid_move?(x,y) && !in_check?(color)
          # a piece can be moved so not a stalemate
          false
        else
          true
        end
      end
    end

    # For king - if can be moved. Does that move put itself into check?
  end

  def in_check?(color)
    king = pieces.find_by_type_and_color(King, color)
    opponent_pieces = remaining_pieces_of(color)

    opponent_pieces.each do |piece|
      return true if piece.valid_move?(king.current_row_index, king.current_column_index)
    end
    false
  end

  private

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

    spots.each do |x,y|
      pieces.each do |piece|
        if piece.find_by_current_row_index_and_current_column_index(x,y) != nil
          spots.delete([x,y])
        end
      end
    end
    return spots
  end


end
