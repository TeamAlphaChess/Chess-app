require 'rails_helper'
RSpec.describe King, type: :model do
	describe 'valid_move?' do
    it 'should allow a vertical-up move' do
  	  game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(6, 5)).to eq true
  	end

    it 'should allow a vertical-down move' do
  		game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(6, 5)).to eq true
  	end

  	it 'should allow a horizonal-left move' do
  		game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(5, 4)).to eq true
  	end

  	it 'should allow a horizonal-right move' do
  		game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(5, 6)).to eq true
  	end

    it 'should allow a diagonal-up-right move' do
  		game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(4, 6)).to eq true
  	end

    it 'should allow a diagonal-up-left move' do
  		game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(5, 6)).to eq true
  	end

    it 'should allow a diagonal-down-right move' do
  		game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(6, 6)).to eq true
  	end

    it 'should allow a diagonal-down-left move' do
  		game = FactoryGirl.create(:game)
  		king = King.new(game: game, current_row_index: 5, current_column_index: 5)
  		expect(king.valid_move?(6, 4)).to eq true
  	end

    it 'should allow a move to a space if piece is opposite color' do
      game = FactoryGirl.create(:game)
      black_king = FactoryGirl.create(:king, game: game, current_row_index: 5, current_column_index: 5, color: 'black')
      white_pawn = FactoryGirl.create(:pawn, game: game, current_row_index: 4, current_column_index: 5, color: 'white')
      expect(black_king.valid_move?(4,5)).to eq true
    end

    it 'should not allow a move to a space if piece is same color' do
      game = FactoryGirl.create(:game)
      black_king = FactoryGirl.create(:king, game: game, current_row_index: 5, current_column_index: 5, color: 'black')
      black_pawn = FactoryGirl.create(:pawn, game: game, current_row_index: 4, current_column_index: 5, color: 'black')
      expect(black_king.valid_move?(4,5)).to eq false
    end

  end
end
