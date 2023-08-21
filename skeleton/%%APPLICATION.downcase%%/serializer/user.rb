module %%APPLICATION%%
  module Serializer
    class UserSerializer
      def initialize(model:, type: :lazy)
        @user = model
        @type = type
      end

      def as_json(*)
        data = {
          id: @user.id.to_s,
          username: @user.username,
          profiles: @user.profiles,
          fullname: @user.fullname,
          password: @user.password.to_s,
          email: @user.email,
          token: @user.token,
          api_user: @user.api_user?
        }

        data[:errors] = @user.errors if @user.errors.any?
        data
      end
    end
  end
end
