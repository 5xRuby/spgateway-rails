module Spgateway
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Spgateway::Rails
    end
  end
end
