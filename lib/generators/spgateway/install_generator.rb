require 'rails/generators/base'

module Spgateway
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates the Spgateway initializer and mounts Spgateway::Rails::Engine."

      def copy_initializer_file
        template "spgateway_initializer.rb", ::Rails.root.join('config', 'initializers', 'spgateway.rb')
      end

      def mount_engine
        route "mount Spgateway::Engine => '/spgateway'"
      end
    end
  end
end
