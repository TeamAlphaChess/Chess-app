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

  def stalemate?(which_color)
    check_these_pieces = remaining_pieces_of(which_color)
    check_these_coords = all_coords

    check_these_pieces.each do |our_piece|
      check_these_coords.each do |x, y|
        if our_piece.valid_move?(x, y) && !move_puts_king_in_check?(which_color, our_piece, x, y)
          return false
        end
      end
    end
    true
  end

  def in_check?(color)
    king = pieces.find_by_type_and_color(King, color)
    opponent_pieces = opposite_remaining_pieces_of(color)

    opponent_pieces.each do |piece|
      return true if piece.valid_move?(king.current_row_index, king.current_column_index)
    end
    false
  end

  def move_puts_king_in_check?(color, piece, x, y)
    check_state = false

    ActiveRecord::Base.transaction do
      piece.move_to!(x, y)
      check_state = in_check?(color)
      raise ActiveRecord::Rollback
    end

    piece.reload
    reload
    check_state
  end

  def opposite_remaining_pieces_of(color)
    remaining_pieces = []

    if color == 'white'
      pieces.where(color: 'black', captured: false).find_each do |piece|
        remaining_pieces << piece
      end
    else
      pieces.where(color: 'white', captured: false).find_each do |piece|
        remaining_pieces << piece
      end
    end
    remaining_pieces
  end

  def remaining_pieces_of(color)
    the_pieces = []

    pieces.where(color: color, captured: false).find_each do |piece|
      the_pieces << piece
    end

    the_pieces
  end

  def all_coords
    coords = []
    0.upto(7).each do |x|
      0.upto(7).each do |y|
        coords << [x, y]
      end
    end
    coords
  end

  def empty_spots
    spots = all_coords

    taken_spots = []

    spots.each do |x, y|
      if pieces.find_by_current_row_index_and_current_column_index(x, y)
        taken_spots << [x, y]
      end
    end

    empty_spots = spots - taken_spots
    empty_spots
  end
end
