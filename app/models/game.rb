# frozen_string_literal: true
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  belongs_to :winner, class_name: 'User'
  has_many :pieces #, dependent: :destroy
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


  def checkmate?(destination_row, destination_col)
  # Determine if king is in check and if king can move out of check
  # checked_king = pieces.find_by(type: 'King', current_row_index: destination_row, current_column_index: destination_col)
  return false if can_move_out_of_check?
  #return false unless @checked_king.obstructed_king?(destination_row, destination_col)
    # pieces.each do |piece|
    #   if game.piece.obstructed?(king.current_row_index, king.current_column_index) == false
    #     @piece_causes_check = piece
    #   end
    # end


  # Here obstructed is a piece class method so its not recognized (seen as nil class) and tests fail
  return false unless check?(destination_row, destination_col)
    true
  end


  # Pass in king's coordinates
  def check?(destination_row, destination_col)
    # placeholder for check method
    # returns true with no other logic in order to create tests for checkmate? in game_spec.rb
    # king = pieces.find_by(type: 'King', current_row_index: destination_row, current_column_index: destination_col)

    # if piece.valid_move?(king.current_row_index, king.current_column_index)
    #     @piece_causes_check = piece
    #     return true
    # end
    # false
    #true
    #king = pieces.find_by(type: 'King', current_row_index: destination_row, current_column_index: destination_col)

    pieces.each do |piece|
    # king's coordinates are the same as any pieces destination coordinates to try to take the king
      return false unless piece.can_capture_king?(destination_row, destination_col) 
      #   king_threats = []
      #   @piece_causing_check = piece
      #   king_threats << @piece_causing_check
      # return true if king_threats.count > 0
    end
  end

  # def not_opponent(color)
  #   pieces.find_by(captured: false, color: color).to_a
  # end 
end
