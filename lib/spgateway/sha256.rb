module Spgateway
  module SHA256
    def self.hash(
      data,
      hash_key: Spgateway.config.hash_key,
      hash_iv: Spgateway.config.hash_iv,
      hash_iv_first: false
    )
      if hash_iv_first
        Digest::SHA256.hexdigest("HashIV=#{hash_iv}&#{data}&HashKey=#{hash_key}").upcase
      else
        Digest::SHA256.hexdigest("HashKey=#{hash_key}&#{data}&HashIV=#{hash_iv}").upcase
      end
    end
  end
end
