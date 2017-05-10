require "spgateway/version"
require "spgateway/config"
require "spgateway/engine"
require "spgateway/sha256"

module Spgateway
  def self.configure
    yield config
  end

  def self.config
    @config ||= Config.new
  end
end
