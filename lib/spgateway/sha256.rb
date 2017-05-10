module Spgateway
  module SHA256
    def self.hash(data, hash_key: Spgateway.config.hash_key, hash_iv: Spgateway.config.hash_iv)
      Digest::SHA256.hexdigest("HashKey=#{hash_key}&#{data}&HashIV=#{hash_iv}").upcase
    end
  end
end
