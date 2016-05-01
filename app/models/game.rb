# frozen_string_literal: true
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  belongs_to :winner, class_name: 'User'
  has_many :pieces, dependent: :destroy
  after_create :populate_board!

  def self.list_available_games(offset_count = 0, query_limit = 10)
    Game.where(black_player_id: nil).offset(offset_count).limit(query_limit)
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

  def checkmate?(color)
    piece_causing_check = in_check?(color)
    return false unless piece_causing_check
    # Determine if king can move out of check to escape
    checked_king = pieces.find_by_type_and_color(King, color)
    return false if checked_king.can_move_out_of_check?
    # here threatening piece is opposite color of checked king
    return false if piece_causing_check.can_be_captured?
    return false if piece_causing_check.can_be_blocked?(checked_king)
    true
  end

  def in_check?(color)
    king = pieces.find_by_type_and_color(King, color)
    opponent_pieces = opposite_remaining_pieces_of(color)
    opponent_pieces.each do |piece|
      if piece.valid_move?(king.current_row_index, king.current_column_index)
        piece_causing_check = piece
        return piece_causing_check
      end
    end
    nil
  end

  def pieces_remaining(*)
    pieces.where(captured: false).to_a
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

  def update_player_turn
    # if current_user.id == self.white_player_id
    #   self.update_attributes(current_player_turn_id: self.black_player_id)
    # else
    #   self.update_attributes(current_player_turn_id: self.white_player_id)
    # end
  end
end
