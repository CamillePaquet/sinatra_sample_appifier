module %%APPLICATION%%
  class MenuManager
    def initialize(user_id:, menu: :general, wanted: :home)
      @user = %%APPLICATION%%::Models::User.find(user_id) if user_id
      @menu = get_config.menus[menu]
      @wanted = wanted
      @allowed = [:anonymous]
      @allowed.concat @user.profiles if @user
    end

    def negociate
      @menu.select do |item|
        @allowed.include?(item[:access]) || item[:access].nil?
      end
    end
  end
end
