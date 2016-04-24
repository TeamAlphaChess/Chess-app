# frozen_string_literal: true
class GamesController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def new
    @game = Game.new
  end

  def index
    @games = Game.list_available_games
  end

  def create
    @game = Game.create(game_params)
    @game.update_attribute(white_player_id: current_user.id)
    redirect_to root_path
  end

  def show
    @game = Game.find(params[:id])
  end

  def forfeit
    # Add a #forfeit method to `game`. This will end the game and set the other player as the winner.
    # Can add a button for this on `Games#Show` and add a `forfeit` action to the `games_controller`
    if request.xhr?
      @game = Game.find(params[:id])
      if current_user.id == @game.white_player_id
        @game.update_attributes(winner_id: @game.black_player_id)
        @other_user = @game.black_player_id
      else
        @game.update_attributes(winner_id: @game.white_player_id)
        @other_user = @game.white_player_id
      end
      # increment other player games_won by 1
      @other_user.update_attributes(games_won: games_won + 1)

      respond_to do |format|
        format.json do
          render json: {
            response: 'hello'
          }
        end
      end
      # # @game.destroy
    end
  end

  def destroy
    @game = Game.find(params[:id])
    return render_not_found if @game.blank?
    @game.destroy
    redirect_to root_path
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(black_player_id: current_user.id)
    redirect_to game_path(@game.id)
  end

  private

  def game_params
    params.require(:game).permit(:name, :black_player_id)
  end
end
