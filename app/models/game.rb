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
  #   king = pieces.where(type: King, color: color)
  # end

  # def in_check?(color)
  #   king = pieces.find_by_type_and_color(King, color)
  #   if color == 'white'
  #     opposite_color_pieces = pieces.where(color: 'black', captured: false)
  #   else
  #     opposite_color_pieces = pieces.where(color: 'white', captured: false)
  #   end
  #   # Moves the found pieces active relation into the opponient_pieces array
  #   opponient_pieces = []
  #   opposite_color_pieces.each do |piece|
  #     opponient_pieces << pieces.find(piece.id)
  #   end
  #
  #   opponient_pieces.each do |piece|
  #     return true if piece.valid_move?(king.current_row_index, king.current_column_index)
  #   end
  #   false
  # end

  def in_check?(color)
    king = pieces.find_by_type_and_color(King, color)
    opposite_color_pieces = []
    if color == 'white'
      pieces.where(color: 'black', captured: false).each do |piece|
        opposite_color_pieces << piece
      end
    else
      pieces.where(color: 'white', captured: false).each do |piece|
        opposite_color_pieces << piece
      end
    end

    opposite_color_pieces.each do |piece|
      return true if piece.valid_move?(king.current_row_index, king.current_column_index)
    end
    false
  end

  private

end
