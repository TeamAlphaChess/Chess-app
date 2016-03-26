class GamesController < ApplicationController
  #before_action :authenticate_user!, only: [:create]

  def new
    @game = Game.new
  end

  def index
    @games = Game.all
  end

  def create
    @game = Game.create(game_params)
    #@game.update_attribute(:black_player_id, current_user.id)
    redirect_to root_path
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(game_params)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
