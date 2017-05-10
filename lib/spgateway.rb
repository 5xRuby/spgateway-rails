require "spgateway/version"
require "spgateway/config"
require "spgateway/engine"

module Spgateway
  def self.configure
    yield config
  end

  def self.config
    @config ||= Config.new
  end
end
