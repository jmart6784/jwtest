class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :destroy]
  before_action :authorized

  # GET /notes
  def index
    @notes = Note.all

    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.user_id = note_user[:id].to_i

    if @note.save
      render json: @note, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:message, :user_id)
    end

    def note_user
      token = request.headers['Authorization'].split(' ')[1]

      if token
        user_id = JWT.decode(token, ENV["jwt_secret"], true, algorithm: 'HS256')[0]['user_id']
        user = User.find(user_id)

        return {
          id: user.id, 
          username: user.username, 
          age: user.age, 
          created_at: user.created_at, 
          updated_at: user.updated_at
        }
      end
    end
end
