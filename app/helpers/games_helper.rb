# frozen_string_literal: true
module GamesHelper

  def define_chesspiece_class(type, color)

    chesspiece_class = 'chess-piece text-hide '

    chesspieces = {
      'Bishop' => 'bishop',
      'King' => 'king',
      'Knight' => 'knight',
      'Pawn' => 'pawn',
      'Queen' => 'queen',
      'Rook' => 'rook'
    }

    if chesspieces.has_key?(type)
      chesspiece_class << chesspieces[type]
      if color == 'black'
        chesspiece_class << '-black'
      else
        chesspiece_class << '-white'
      end
    else
      raise ActiveRecord::InternalServerError
    end

    return chesspiece_class
  end

  def render_board(pieces, game)
    range = 0..7
    column_iteration = (range.first).upto(range.last)

    if current_user == game.white_player_id
      row_iteration = (range.last).downto(range.first)
    else
      row_iteration = (range.first).upto(range.last)
    end
    data = '<tbody>'
    row_iteration.each do |row_index|
      data << "<tr data-row-index='#{row_index}'>"
      column_iteration.each do |column_index|
        if row_index.odd? && column_index.odd? || row_index.even? && column_index.even?
          data << "<td data-column-index='#{column_index}' class='chess-light-square'>"
        else
          data << "<td data-column-index='#{column_index}' class='chess-dark-square'>"
        end

        chesspiece = pieces.find { |piece| piece.current_column_index == column_index && piece.current_row_index == row_index }
        if chesspiece != nil
          data << "<div class='#{define_chesspiece_class(chesspiece.type, chesspiece.color)}' data-piece-id='#{chesspiece.id}'>#{chesspiece.type} #{chesspiece.color}</div>"
        end
        data << "</td>"
      end
      data << "</tr>"
    end
    data << '</tbody>'

    return data.html_safe
  end
end
