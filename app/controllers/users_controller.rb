class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end

  def login
    @user = User.find_by(username: user_params[:username])

    if @user && @user.password_digest === user_params[:password_digest]
      token = encode_token({user_id: @user.id})
      render json: {
        user: {
          id: @user.id, 
          username: @user.username, 
          age: @user.age,
          created_at: @user.created_at, 
          updated_at: @user.updated_at
        }, token: token
      }
    else
      render json: {error: "Invalid username or password"}
    end
  end

  def auto_login
    render json: {
      user: {
        id: @user.id, 
        username: @user.username, 
        age: @user.age,
        created_at: @user.created_at, 
        updated_at: @user.updated_at
      }, token: token
    }
  end

  def present_user
    token = request.headers['Authorization'].split(' ')[1]

    if token
      user_id = JWT.decode(token, ENV["jwt_secret"], true, algorithm: 'HS256')[0]['user_id']
      user = User.find(user_id)

      render json: {
        id: user.id, 
        username: user.username, 
        age: user.age, 
        created_at: user.created_at, 
        updated_at: user.updated_at
      }, token: token
    else
      render json: {message: "User not found"}, status: 404
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password_digest, :age)
  end
end
