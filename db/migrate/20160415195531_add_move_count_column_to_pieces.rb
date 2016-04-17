class AddMoveCountColumnToPieces < ActiveRecord::Migration
  def change
    add_column :pieces, :move_count, :integer, :default => 0
  end
end
