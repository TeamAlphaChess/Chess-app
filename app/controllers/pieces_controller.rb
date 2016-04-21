# frozen_string_literal: true
class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game

    if request.xhr?
      # if @game.current_player_turn_id == current_user.id
      # do stuff below. Else, @current_player message = 'Not your turn!'
      # and render status: 422, json: @response.to_json.
      # Perhaps put this functionality into a before_action when ready.

      @initial_row = @piece.current_row_index
      @initial_column = @piece.current_column_index
      @destination_row = request['destination_row'].to_i
      @destination_column = request['destination_column'].to_i

      initialize_response_object
      status_codes = []

      status_codes << chesspiece_normal_action!
      # status_codes << @game.detect_pawn_promotion
      status_codes << castling!
      status_codes << pawn_en_passant!

      if status_codes.include?(200)
        # When web socket implemented, send
        # this to both players
        render status: 200, json: @response.to_json
      else
        # When web socket implemented, only
        # send this to current player
        add_player_messages!('Invalid move', '')
        render status: 422, json: @response.to_json
      end
    end
  end

  # This method is for when the player selects a piece
  # from a form and submits it to replace the pawn.
  # Pawn promotion status checks will be done in
  # def check_game_status further down the page.
  # There is a dedicated route for pawn_promotion
  # which Ajax will send to on submission of the form.
  def pawn_promotion
    # @piece is the piece the user
    # selected to replace the pawn with
    @piece = Piece.find(params[:id])
    @game = @piece.game

    if request.xhr?

      initialize_response_object
      row = request['row'].to_i
      column = request['column'].to_i
      old_piece = Piece.find_by_current_row_index_and_current_column_index(request['row'].to_i, request['column'].to_i)

      # call methods here which will update the pieces in the backend after selecting
      # from the pawn promotion form.

      # if successful submission(200 response)
      # @game.update_player_turn
      # send to both players via websocket the instructions
      # and player messages. If 422, send back only to
      # current player the error messages using @current_player_message

      @response[:createPieces] = {
        createpiece1: {
          row: row,
          column: column,
          oldPiece: old_piece,
          newPiece: @piece,
          validSelection: true
        }
      }

      @response[:captures] = {
        capture1: {
          rowIndex: row,
          columnIndex: column
        }
      }
    end
  end

  private

  def pawn_en_passant!
    # Variables available:
    # - @piece
    # - @game
    # - @destination_row
    # - @destination_column

    # Run this code if valid
    # add_player_messages!('Other player\'s turn', 'Your turn')
    # check_game_status
    # @game.update_player_turn
    # return 200

    # else
    # return 422
  end

  def initialize_response_object
    @current_player_message = 'No Message'
    @other_player_message = 'No Message'

    @response = {
      actionStatus: {
        pawnPromotion: false,
        statusForPlayer: ''
      },
      captures: {},
      moves: {},
      createPieces: {},
      playerMessages: {
        white: '',
        black: ''
      }
    }
  end

  def add_player_messages!(current_player_message, other_player_message)
    if current_user.id == @game.white_player_id
      @response[:playerMessages][:white] = current_player_message
      @response[:playerMessages][:black] = other_player_message
    else
      @response[:playerMessages][:white] = other_player_message
      @response[:playerMessages][:black] = current_player_message
    end
  end

  def chesspiece_normal_action!
    if @piece.valid_move?(@destination_row, @destination_column)
      blocker_piece = @piece.move_to!(@destination_row, @destination_column)

      if blocker_piece.is_a? Piece
        @response[:captures] = {
          capture1: {
            rowIndex: @destination_row,
            columnIndex: @destination_column
          }
        }
      end

      @response[:moves] = {
        move1: {
          initialRow: @initial_row,
          initialColumn: @initial_column,
          destinationRow: @destination_row,
          destinationColumn: @destination_column
        }
      }

      add_player_messages!('Other player\'s turn', 'Your turn')
      check_game_status
      @game.update_player_turn
      200
    else
      422
    end
  end

  def castling!
    if @piece.type == 'King'
      if @piece.can_castle?(@destination_row, @destination_column)
        @piece.castle!(@destination_row, @destination_column)
        @response[:moves] = {
          move1: {
            initialRow: @initial_row,
            initialColumn: @initial_column,
            destinationRow: @destination_row,
            destinationColumn: @destination_column
          },
          move2: {
            initialRow: @destination_row,
            initialColumn: @destination_column,
            destinationRow: @initial_row,
            destinationColumn: @initial_column
          }
        }
        add_player_messages!('Other player\'s turn', 'Your turn')
        check_game_status
        @game.update_player_turn
        200
      else
        422
      end
    else
      422
    end
  end

  def check_game_status
    # call stuff here
    # @game is available to use

    # call add_player_messages! to
    # changes the player messages
    # depending on the game status
    # on the results from the calls.
    # Changes to these will overwrite
    # messages in previous methods.

    # Methods to call
    # Checkmate, lose or win
    # Check
    # Stalemate
    # Pawn Promotion
    # if pawn promotion is pending, make sure to set
    # @response[:actionStatus][:pawnPromotion] = true
  end
end

# ruby render json: {
#   errors: [
#     {name: 'can\'t be blank'},
#     {email: 'can\'t be blank'},
#     {password: 'can\'t be blank'}
#   ]
# }.to_json
