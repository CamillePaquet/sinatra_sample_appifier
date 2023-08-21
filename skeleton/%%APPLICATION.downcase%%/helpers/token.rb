module %%APPLICATION%%
  module Helpers
    module Token
      def generate_token!
        SecureRandom.urlsafe_base64(64)
      end
    end
  end
end
