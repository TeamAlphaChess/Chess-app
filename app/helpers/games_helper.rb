# frozen_string_literal: true
module GamesHelper
  def render_board(pieces, game)
    range = 0..7
    column_iteration = range.first.upto range.last

    row_iteration = if current_user.id == game.white_player_id
                      range.last.downto range.first
                    else
                      range.first.upto range.last
                    end

    data = "<table class='chessboard' id='chessBoard' data-game-id=#{game.id}><tbody>"
    row_iteration.each do |row_index|
      data << "<tr data-row-index='#{row_index}'>"
      column_iteration.each do |column_index|
        data << create_chess_square(row_index, column_index)
        data << create_chess_piece(row_index, column_index, game, pieces)
      end
      data << '</tr>'
    end

    data << '</tbody></table>'

    data.html_safe
  end

  def determine_player(game)
    if current_user.id == game.black_player_id
      return ['black', current_user.id, 'white', game.white_player_id]

    elsif current_user.id == game.white_player_id
      return ['white', current_user.id, 'black', game.black_player_id]

    else
      %w(none none none)
    end
  end

  ###############################################
  # For Assisting render_board
  ###############################################

  def create_chess_square(row_index, column_index)
    if row_index.odd? && column_index.odd? || row_index.even? && column_index.even?
      return "<td data-column-index='#{column_index}' class='chess-light-square'>"
    else
      return "<td data-column-index='#{column_index}' class='chess-dark-square'>"
    end
  end

  def create_chess_piece(row_index, column_index, game, pieces)
    chesspiece = pieces.find { |piece| piece.current_column_index == column_index && piece.current_row_index == row_index }
    data = ''
    unless chesspiece.nil?
      data << "<div class='#{define_chesspiece_class(chesspiece.type, chesspiece.color, game)}' data-piece-id='#{chesspiece.id}'
              data-piece-color=#{chesspiece.color}>#{chesspiece.type} #{chesspiece.color}</div>"
    end
    data << '</td>'
    data
  end

  def define_chesspiece_class(type, color, game)
    chesspiece_class = 'chess-piece text-hide '
    chesspieces = {
      'Bishop' => 'bishop',
      'King' => 'king',
      'Knight' => 'knight',
      'Pawn' => 'pawn',
      'Queen' => 'queen',
      'Rook' => 'rook'
    }

    raise ActiveRecord::InternalServerError unless chesspieces.key?(type)
    chesspiece_class << chesspieces[type]
    if color == 'black'
      chesspiece_class << '-black '
      if current_user.id == game.black_player_id
        chesspiece_class << 'chess-square-states'
      end
    else
      chesspiece_class << '-white '
      if current_user.id == game.white_player_id
        chesspiece_class << 'chess-square-states'
      end
    end
    chesspiece_class
  end

  ###############################################
end
