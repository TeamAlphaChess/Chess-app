class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])

    if request.xhr?
      ##############################################################
      # DO NOT REFERENCE THIS FILE YET!!!!!
      # EVERYTHING BELOW WILL BE REFACTORED
      # WITH DIFFERENT DATA SOON
      ##############################################################

      # These are only for validation purposes.
      # selected_piece_id can be used to check if same as @piece.id.
      # initial_square index can be used to make sure front end index
      # is the same as back end for the piece.
      selected_piece_id = request['selected_piece_id'].to_i
      initial_square_row_index = request['initial_square_row_index'].to_i
      inital_square_column_index = request['initial_square_column_index'].to_i

      # Use these for move_to! method.
      # As well as @piece.
      final_square_row_index = request['final_square_row_index'].to_i
      final_square_column_index = request['final_square_column_index'].to_i

      # Create backend logic in models and call them here
      # with the incoming data as arguments

      # @piece.move_to!(final_square_row_index, final_square_column_index)
      # data to be returned. Will contain the return of
      # the model logic.
      # Piece_captured is so javascript can update the
      # captured pieces board.
      # Message would go in the game status board, so
      # stuff like 'your turn' or 'invalid move',
      # 'checkmate', etc. Different for each player.

      # Whos turn is next
      if @piece.color == 'white'
        # black players turn is next
        black_player_message = 'Your turn'
      else
        # white player turn is next
        white_player_message = 'Your turn'
      end

      valid_move = true
      piece_captured_type = 'cool'
      piece_captured_color = 'white'
      white_player_message = nil
      black_player_message = nil

      # feel free to add new data entries to the output
      respond_to do |format|
        format.json do
          render json: {
            validMove: true,
            pieceCapturedType: piece_captured_type,
            pieceCapturedColor: piece_captured_color,
            whitePlayerMessage: white_player_message,
            blackPlayerMessage: black_player_message
          }.to_json
        end
      end
    end
  end
end
