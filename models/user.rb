module %%APPLICATION%%
  module Models
    class User
      include Mongoid::Document
      include BCrypt

      field :username, type: String
      field :token, type: String
      field :profiles, type: Array
      field :fullname, type: String
      field :email, type: String
      field :temporary_password, type: Boolean
      field :api_user, type: Boolean

      has_many :messages, class_name: "Message", inverse_of: :user

      def password=(id)
        write_attribute(:password, Password.create(id))
      end

      def password
        Password.new(read_attribute(:password))
      end

      validates 'username', presence: true
      validates 'password', presence: true
      validates 'profiles', presence: true
      validates 'token', presence: true
      validates 'fullname', presence: true
      validates 'email', presence: true

      index({ username: 1 }, { unique: true })
    end
  end
end
