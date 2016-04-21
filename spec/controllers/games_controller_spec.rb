# frozen_string_literal: true
require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#show action' do
    it 'should successfully show the page if the game is found' do
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)

      get :show, id: game.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'games#forfeit action' do
    # it "should return require users to be logged in" do
    #   post :create, gram: { message: "Hello" }
    #   expect(response).to redirect_to new_user_session_path
    # end

    # it "should successfully create a new gram in our database" do
    #   user = FactoryGirl.create(:user)
    #   sign_in user

    #   post :create, gram: { message: 'Hello!'}
    #   expect(response).to redirect_to root_path

    #   gram = Gram.last
    #   expect(gram.message).to eq("Hello!")
    #   expect(gram.user).to eq(user)
    # end

    # it "should properly deal with validation errors" do
    #   user = FactoryGirl.create(:user)
    #   sign_in user

    #   gram_count = Gram.count
    #   post :create, gram: {message: '' }
    #   expect(response).to have_http_status(:unprocessable_entity)
    #   expect(gram_count).to eq Gram.count
    # end
  end
end
