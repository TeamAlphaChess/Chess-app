# frozen_string_literal: true
require 'rails_helper'
RSpec.describe PiecesController, type: :controller do
  describe 'castle!' do
    it 'should return the king and rook data object for white king and kingside rook' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:rook, game: game, current_row_index: 0, current_column_index: 7, captured: false, color: 'white')
      white_king = FactoryGirl.create(:king, game: game, current_row_index: 0, current_column_index: 4, captured: false, color: 'white')
      expect(white_king.castle!(0, 7)).to eq [{ initialRow: 0, initialColumn: 4, destinationRow: 0, destinationColumn: 6 }, { initialRow: 0, initialColumn: 7, destinationRow: 0, destinationColumn: 5 }]
    end

    it 'should return the king and rook data object for white king and queenside rook' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:rook, game: game, current_row_index: 0, current_column_index: 0, captured: false, color: 'white')
      white_king = FactoryGirl.create(:king, game: game, current_row_index: 0, current_column_index: 4, captured: false, color: 'white')
      expect(white_king.castle!(0, 0)).to eq [{ initialRow: 0, initialColumn: 4, destinationRow: 0, destinationColumn: 2 }, { initialRow: 0, initialColumn: 0, destinationRow: 0, destinationColumn: 3 }]
    end

    it 'should return the king and rook data object for black king and kingside rook' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:rook, game: game, current_row_index: 7, current_column_index: 7, captured: false, color: 'black')
      black_king = FactoryGirl.create(:king, game: game, current_row_index: 7, current_column_index: 4, captured: false, color: 'black')
      expect(black_king.castle!(7, 7)).to eq [{ initialRow: 7, initialColumn: 4, destinationRow: 7, destinationColumn: 6 }, { initialRow: 7, initialColumn: 7, destinationRow: 7, destinationColumn: 5 }]
    end

    it 'should return the king and rook data object for black king and queenside rook' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:rook, game: game, current_row_index: 7, current_column_index: 0, captured: false, color: 'black')
      black_king = FactoryGirl.create(:king, game: game, current_row_index: 7, current_column_index: 4, captured: false, color: 'black')
      expect(black_king.castle!(7, 0)).to eq [{ initialRow: 7, initialColumn: 4, destinationRow: 7, destinationColumn: 2 }, { initialRow: 7, initialColumn: 0, destinationRow: 7, destinationColumn: 3 }]
    end
  end
end
