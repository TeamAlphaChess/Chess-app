# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Bishop, type: :model do
  describe 'valid_move?' do
    it 'should return false for obstructed move with an empty destination spot' do
      game = FactoryGirl.create(:game)
      # Select white bishop from the board
      white_bishop = game.pieces.find_by_current_row_index_and_current_column_index(0, 2)
      expect(white_bishop.valid_move?(2, 4)).to eq false
    end

    it 'should return true for an unobstructed move with an empty destination' do
      game = FactoryGirl.create(:game)
      # Select white bishop from the board
      white_bishop = game.pieces.find_by_current_row_index_and_current_column_index(0, 2)
      # Select pawn in bishops way
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 3)
      # Move pawn out of the way
      white_pawn.update_attributes(current_row_index: nil, current_column_index: nil)

      expect(white_bishop.valid_move?(2, 4)).to eq true
    end

    it 'should return true for an unobstructed move with a destination spot taken with an opposite color' do
      game = FactoryGirl.create(:game)
      # Select white bishop from the board
      white_bishop = game.pieces.find_by_current_row_index_and_current_column_index(0, 2)
      # Select pawn in bishops way
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 3)
      # Move pawn out of the way
      white_pawn.update_attributes(current_row_index: nil, current_column_index: nil)
      # Select black color piece
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      # Move black pawn into the spot bishop will be testing
      black_pawn.update_attributes(current_row_index: 2, current_column_index: 4)

      expect(white_bishop.valid_move?(2, 4)).to eq true
    end

    it 'should return false if you try to move non diagnal' do
      game = FactoryGirl.create(:game)
      # Select white bishop from the board
      white_bishop = game.pieces.find_by_current_row_index_and_current_column_index(0, 2)
      # Select pawn in bishops way
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 2)
      # move pawn out of the way
      white_pawn.update_attributes(current_row_index: 3, current_column_index: 5)

      expect(white_bishop.valid_move?(1, 2)).to eq false
    end
  end

  describe 'obstructed_spots' do
    it 'returns pieces of threatening piece\'s path to checked king' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      black_bishop = FactoryGirl.create(:bishop, game: game, current_row_index: 3, current_column_index: 7, captured: false, color: 'black')
      FactoryGirl.create(:king, game: game, current_row_index: 0, current_column_index: 4, captured: false, color: 'white')
      expect(black_bishop.obstructed_spots(0, 4)).to eq [[2, 6], [1, 5]]
    end
  end
end
