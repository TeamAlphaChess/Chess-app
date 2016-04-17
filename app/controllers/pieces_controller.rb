class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    raise ActiveRecord::InternalServerError if current_user.id != @game.black_player_id &&
                                               current_user.id != @game.white_player_id
    if request.xhr?

      capture_instructions = {}
      move_instructions = {}
      create_piece_instructions = {}
      action_status_instructions = {
        validMove: true,
        pawnPromotion: false,
        statusForPlayer: current_user.id
      }

      # This block runs when the user has selected a piece to replace
      # the pawn. The model logic may need to be separated into 2 parts.
      # The first part will be called in the if pawn_promotion? block,
      # where it will return whether there is a pawn promotion or not.
      # This will change pawnPromotion in the response object to true.
      # Javascript will detect this, open a form, and then the attributes
      # of the chesspiece the user selects will be sent to this block.
      # A method will be called in this block to update the pawn's status
      # to captured, and the new piece's status to not captured.
      if request['type'] == 'pawn_promotion'

          row = request['row'].to_i
          column = request['column'].to_i

          old_piece = Piece.find_by_current_row_index_and_current_column_index(request['row'].to_i, request['column'].to_i)

          # call methods here which will update the pieces in the backend. Returns true if valid, false if not.
          # if validSelection is false in the has below, javascript will render errors in the form.

          create_piece_instructions = {
            row: row,
            column: column,
            oldPiece: old_piece,
            newPiece: @piece,
            validSelection: true
          }

          capture_instructions = {
            rowIndex: row,
            columnIndex: column,
          }

      elsif request['type'] == 'standard_request'

        initial_row = @piece.current_row_index
        initial_column = @piece.current_column_index
        destination_row = request['destination_row'].to_i
        destination_column = request['destination_column'].to_i

        if @piece.valid_move?(destination_row, destination_column)

          if @piece.is_a?('King') && @piece.can_castle?(destination_row, destination_column)
            @piece.castle!(destination_row, destination_column)
            move_instructions = {
              1: {
                initialRow: @piece.current_row_index,
                initialColumn: @piece.current_column_index,
                destinationRow: destination_row,
                destinationColumn: destination_column
              },
              2: {
                initialRow: destination_row,
                initialColumn: destination_column,
                destinationRow: @piece.current_row_index,
                destinationColumn: @piece.current_column_index
              }
            }

          elsif @piece.can_en_passent?(destination_row, destination_column)

            # return [row_index, col_index]
            captured_piece = @piece.en_passent!(destination_row, destination_column)

            capture_instructions = {
              rowIndex: captured_piece[0],
              columnIndex: captured_piece[1]
            }

            move_instructions = {
              1: {
                initialRow: @piece.current_row_index,
                initialColumn: @piece.current_column_index,
                destinationRow: destination_row,
                destinationColumn: destination_column
              }
            }

          else
            blocker_piece = @piece.move_to!(destination_row, destination_column)
            if blocker_piece != nil
              capture_instructions = {
                rowIndex: destination_row,
                columnIndex: destination_column
              }
            end

            move_instructions = {
              1: {
                initialRow: @piece.current_row_index,
                initialColumn: @piece.current_column_index,
                destinationRow: destination_row,
                destinationColumn: destination_column
              }
            }

            # Detects if the valid move is eligible for a pawn
            # promotion. pawnPromotion = true tells javascript
            # to open a form modal for the user to select
            # a piece to replace the pawn. Upon submission
            # of the new piece, see 'if request['type'] == 'pawn_promotion''
            if pawn_promotion?(@piece)
              action_status_instructions['pawnPromotion'] = true
            end
          end

        else
          action_status_instructions[:valid_move] = false
        end

      else
        raise ActiveRecord::InternalServerError
      end

      respond_to do |format|
        format.json do
          render json: {
            actionStatus: action_status_instructions,
            captures: capture_instructions,
            moves: move_instructions,
            createPiece: create_piece_instructions
          }.to_json
        end
      end
    end
  end
end
