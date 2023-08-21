module Application
    module Helpers
        module Config
            def log 
                Application::Controller.logger
            end
        end
    end
end