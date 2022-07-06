class User < ApplicationRecord
    after_initialize :ensure_session_token
    #Validations
    validates :email, :session_token, :password_digest, presence: true
    validates :email, :session_token, uniqueness: true
    validates :password, limit { minimum: 6, allow_nil: true}

    #Find By Credentials
    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)

        return nil if user.nil?

        user.is_password?(password) ? user : nil
    end

    #Passwords
    attr_reader :password

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    #Session Tokens
    def reset_session_token!
        self.session_token = SecureRandom.base64(64)
        self.save!
        self.session_token
    end

    #ensuring each user has a session token
    private
    
    def ensure_session_token
        #lazy initialization for session token
        self.session_token ||= SecureRandom.base64(64)
    end
end