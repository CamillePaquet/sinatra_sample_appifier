module Application
    module Helpers
        module Config
            def get_config
                Application::Controller.configuration.settings
            end
        end
    end
end