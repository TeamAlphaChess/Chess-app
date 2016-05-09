# frozen_string_literal: true
require 'rails_helper'
RSpec.describe PiecesController, type: :controller do
  describe 'castle!' do
    it 'should return the king and rook data object' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:rook, game: game, current_row_index: 0, current_column_index: 7, captured: false, color: 'white')
      white_king = FactoryGirl.create(:king, game: game, current_row_index: 0, current_column_index: 4, captured: false, color: 'white')
      expect(white_king.castle!(0, 7)).to eq [{ initialRow: 0, initialColumn: 4, destinationRow: 0, destinationColumn: 6 }, { initialRow: 0, initialColumn: 7, destinationRow: 0, destinationColumn: 5 }]
    end
  end
end
