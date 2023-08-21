module Application
  module Helpers
    module I18n
      def translate(*args, **keywords) # *args, **keywords
        Application::Controller.i18n.t(*args, **keywords)
      end

      # TODO : Refacto => ouverture du fichier plusieurs fois
      def get_i18n_config(role:)
        current_langage = Application::Controller.i18n.locale.to_s
        YAML.load_file("config/locales/#{current_langage}.yml")[current_langage]['config_records'][role.to_s]
      end

      # TODO : Refacto => ouverture du fichier plusieurs fois
      def get_i18n_config_credentials
        current_langage = Application::Controller.i18n.locale.to_s
        YAML.load_file("config/locales/#{current_langage}.yml")[current_langage]['credentials']
      end
    end
  end
end
