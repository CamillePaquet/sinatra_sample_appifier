module Application
  module Models
    class Message
      include Mongoid::Document

      field :type, type: String
      field :title, type: String
      field :content, type: String

      validates 'type', presence: true
      validates 'content', presence: true

      belongs_to :user, class_name: "User", inverse_of: :messages, optional: true

    end
  end
end
