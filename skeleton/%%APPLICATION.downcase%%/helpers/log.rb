module %%APPLICATION%%
    module Helpers
        module Config
            def log 
                %%APPLICATION%%::Controller.logger
            end
        end
    end
end