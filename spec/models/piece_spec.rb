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
    end

    it 'returns true for invalid destination' do
      game = FactoryGirl.create(:game) # Would do this using FactoryGirl
      piece1 = FactoryGirl.create(:piece, game: game, current_row_index: 1, current_column_index: 1)
      FactoryGirl.create(:piece, game: game, current_row_index: 2, current_column_index: 2)

      expect(piece1.obstructed?(2, 2)).to eq true
      # expect(response).to have_http_status(:unproceessable_entity)
      # it raises an error because there is a piece in the destination.
    end
  end
end
