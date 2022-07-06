class UsersController < ApplicationController
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(users_params)

        if @user.save
            login(@user)
        else
            render json: @user.errors.full_messages, status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(params[:id])
        render :show
    end

    private

    def users_params
        params.require[:user].permit[:email, :password]
    end
end