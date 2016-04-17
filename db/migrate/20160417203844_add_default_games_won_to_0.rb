class AddDefaultGamesWonTo0 < ActiveRecord::Migration
  def change
    change_column_default(:users, :games_won, 0)
  end
end
