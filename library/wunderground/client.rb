# encoding: utf-8

module Wunderground
  class APIError < StandardError; end
  class APIKeyError < StandardError; end
  class FeatureError < StandardError; end

  class Client
    attr_accessor :api_key, :settings

    def initialize api_key, settings = {}
      @api_key = api_key
      @settings = settings
    end

    def request feature, query
      response = RestClient.get "http://api.wunderground.com/api/#@api_key/#{feature}/#{serialized_settings}/q/#{query}.json"
      document = JSON.parse response

      return unless response = document["response"]

      # Handle errors if found.
      if error = response["error"]
        case error["type"]
        when "keynotfound"
          raise APIKeyError, error["description"]
        when "unknownfeature"
          raise FeatureError, "feature #{feature} is unknown"
        else
          raise APIError, error["description"]
        end
      end

      # Check to see that the API supports the requested feature.
      unless features = response["features"] and features.key?(feature)
        raise FeatureError, "unsupported feature? (the server didn't send an explicit error)"
      end

      Response.new document
    end

  private

    def serialized_settings
      @settings.to_a.map{|k| k.join ?: }.join ?/
    end
  end
end