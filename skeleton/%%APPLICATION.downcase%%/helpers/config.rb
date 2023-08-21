module %%APPLICATION%%
    module Helpers
        module Config
            def get_config
                %%APPLICATION%%::Controller.configuration.settings
            end
        end
    end
end