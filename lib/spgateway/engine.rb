module Spgateway
  class Engine < ::Rails::Engine
    isolate_namespace Spgateway

    config.to_prepare do
      ApplicationController.helper(Spgateway::Engine.helpers)
    end
  end
end
