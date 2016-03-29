require 'rails_helper'
RSpec.describe King, type: :model do
	describe 'valid_move?' do
		it 'should allow a vertical-up move' do
			game = FactoryGirl.create(:game)
      
		end


    it 'should not move an obstructed space' do
      expect(game.obstructed?).to eq false
	end

	end
end