$:.unshift File.expand_path('../../library', __FILE__)
require 'wunderground'

# Expand Wunderground::Client.
module Wunderground
  class Client
    def get_serialized_settings
      serialized_settings
    end
  end
end