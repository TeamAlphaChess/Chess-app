require 'rails_helper'
RSpec.describe Queen, type: :model do
  describe "valid_move?" do
    let :game { build :game }
    let :queen { create :queen, game: game }
    it "should allow a vertical-up move" do
      queen
      
      expect(queen.valid_move?(6,4)).to eq true
    end

    it "should allow a horizontal-right move" do
      queen

      expect(queen.valid_move?(4,6)).to eq true
    end

    it "should allow a diagonal down-right move" do
      queen

      expect(queen.valid_move?(6,6)).to eq true
    end

    it "does not allow an invalid move" do
      queen
      expect(queen.valid_move?(6,5)).to eq false
    end

end
end