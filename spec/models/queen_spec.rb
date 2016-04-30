# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Queen, type: :model do
  describe 'valid_move?' do
    let(:game) { build :game }
    let(:queen) { create :queen, color: 'white', game: game }
    it 'should allow a vertical-up move' do
      queen

      expect(queen.valid_move?(2, 4)).to eq true
    end

    it 'should allow a horizontal-right move' do
      queen

      expect(queen.valid_move?(4, 6)).to eq true
    end

    it 'should allow a diagonal down-right move' do
      queen

      expect(queen.valid_move?(6, 6)).to eq true
    end

    it 'does not allow an invalid move' do
      queen
      expect(queen.valid_move?(6, 5)).to eq false
    end
  end

  describe 'obstructed_spots' do
    it 'returns pieces of threatening piece\'s path to checked king' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      black_queen = FactoryGirl.create(:queen, game: game, current_row_index: 4, current_column_index: 4, captured: false, color: 'black')
      FactoryGirl.create(:king, game: game, current_row_index: 0, current_column_index: 4, captured: false, color: 'white')
      expect(black_queen.obstructed_spots(0, 4)).to eq [[3, 4], [2, 4], [1, 4]]
    end

    it 'returns pieces of threatening piece\'s path to checked king' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      black_queen = FactoryGirl.create(:queen, game: game, current_row_index: 2, current_column_index: 2, captured: false, color: 'black')
      FactoryGirl.create(:king, game: game, current_row_index: 0, current_column_index: 4, captured: false, color: 'white')
      expect(black_queen.obstructed_spots(0, 4)).to eq [[1, 3]]
    end
  end
end
