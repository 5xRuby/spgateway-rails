# frozen_string_literal: true
module Spgateway
  module AttrKeyHelper
    def convert_to_attr_key(term)
      term.to_s.gsub(/(^|_)(url|id|[a-z0-9])/) { Regexp.last_match[2].upcase }
    end
  end
end
