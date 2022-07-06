class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    def current_user
        #the current user will be the current user logged in or the one we find by the session token in sessions hash
        @user ||= User.find_by(session_token: session[:session_token])
    end

    def login(user)
        session[:session_token] = user.reset_session_token!
    end

    def logged_in?
        !!current_user
    end

    def logout!
        current_user.reset_session_token! if logged_in!?
        session[:session_token] = nil
        @current_user = nil
    end
end
