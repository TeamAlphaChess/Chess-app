# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Piece, type: :model do
  describe 'obstructed?' do
    it 'returns true for horizontal-right obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 1)
      FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 2)

      expect(piece1.obstructed?(1, 3)).to eq true
      # it is obstructed because there is a piece in position row: 1, col: 2
    end

    it 'returns true for horizontal-left obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 3)
      FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 2)

      expect(piece1.obstructed?(1, 1)).to eq true
      # it is obstructed because there is a piece in position row: 1, col: 2
    end

    it 'returns false for pieces with no vertical inbetween' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)

      expect(piece.obstructed?(1, 0)).to eq false
    end

    it 'returns false for pieces with no diagnal inbetween' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)

      expect(piece.obstructed?(1, 1)).to eq false
    end

    it 'returns false for pieces with no horizontal inbetween' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)

      expect(piece.obstructed?(0, 1)).to eq false
    end

    it 'returns true for vertical-down obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 1)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 1)

      expect(piece1.obstructed?(3, 1)).to eq true
      # it is obstructed because there is a piece in position row: 2, col: 1
    end

    it 'returns true for vertical-up obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 3, current_column_index: 1)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 1)

      expect(piece1.obstructed?(1, 1)).to eq true
      # it is obstructed because there is a piece in position row: 2, col: 1
    end

    it 'returns true for diagonal-down-right obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 1)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 2)

      expect(piece1.obstructed?(3, 3)).to eq true
      # it is obstructed because there is a piece in position row: 2, col: 2
    end

    it 'returns true for diagonal-up-left obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 3, current_column_index: 3)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 2)

      expect(piece1.obstructed?(1, 1)).to eq true
      # it is obstructed because there is a piece in position row: 2, col: 2
    end

    it 'returns true for diagonal-down-left obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 3)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 2)

      expect(piece1.obstructed?(3, 1)).to eq true
      # it is obstructed because there is a piece in position row: 2, col: 2
    end

    it 'returns true for diagonal-up-right obstructions' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 3, current_column_index: 1)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 2)

      expect(piece1.obstructed?(1, 3)).to eq true
      # it is obstructed because there is a piece in position row: 2, col: 2
    end

    it 'returns true for invalid input' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 3, current_column_index: 1)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 2)

      expect(piece1.obstructed?(100, 300)).to eq true
      # it raises an error because there is an invalid input. There is no row: 100, col: 300
      expect(piece1.obstructed?(-100, -300)).to eq true
      # it raises an error because there is an invalid input. There is no row: -100, col: -300
    end
  end

  describe 'move_to!' do
    it 'should allow a move if the current-player-turn-id player tries to make a move' do
    end

    it 'should return false if any other player but the current-player-turn-id player tries to make a move' do
    end

    it 'should change the current-player-turn-id to the other player after a move' do
    end

    it 'moves the piece if the spot is empty' do
      game = FactoryGirl.create(:game)
      piece = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      piece.move_to!(2, 0)
      expect(piece.current_row_index).to eq 2
      expect(piece.current_column_index).to eq 0
    end

    it 'moves the piece if the spot is taken with an opposite color' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 0)
      # Move black pawn to be infront of the white pawn
      black_pawn.update_attributes(current_row_index: 2, current_column_index: 0)
      expect(white_pawn.obstructed?(2, 0)).to eq false # But getting true due to obstructed? method not being done correctly
      # Move the pawn to the spot the black pawn is currently in
      white_pawn.move_to!(2, 0)
      # Check to make sure the piece is in the right spot
      expect(white_pawn.current_row_index).to eq 2
      expect(white_pawn.current_column_index).to eq 0
    end

    it 'piece is captured' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      black_pawn = FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 1, captured: false, color: 'black')
      white_pawn.move_to!(2, 1)
      black_pawn.reload
      expect(black_pawn.captured).to eq true
    end

    it 'piece doesnt move when the color is the same' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      white_rook.move_to!(1, 0)
      expect(white_rook.current_row_index).to eq 0
      expect(white_rook.current_column_index).to eq 0
    end
  end

  describe 'spot_taken?' do
    it 'returns true if a spot is taken' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)

      expect(piece.spot_taken?(1, 1)).to eq true
      # it raises an error because there is a piece in the destination.
    end

    it 'returns false for an empty spot' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)

      expect(piece.spot_taken?(3, 0)).to eq false
      # it raises an error because there is a piece in the destination.
    end
  end
end
