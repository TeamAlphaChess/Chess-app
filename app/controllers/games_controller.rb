# frozen_string_literal: true
class GamesController < ApplicationController
  before_action :authenticate_user!

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
    @game = Game.find(params[:id])
    if @game.forfeit(current_user.id)
      render status: 200, json: {
        redirect: games_path,
        message: 'successful'
      }
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
