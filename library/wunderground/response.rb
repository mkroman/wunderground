# encoding: utf-8

module Wunderground
  class Response
    attr_accessor :headers, :document

    # Returns if this response contains multiple results.
    def single?
      @headers["results"].nil?
    end

    # Returns whether or not this response contains multiple results.
    def multiple?
      not single?
    end

    # Returns a node from the response data.
    def [] name
      @document[name]
    end

    def initialize document
      @headers = document["response"]
      @document = document.reject{|k,v| k == "response" }
    end

    def results
      @headers["results"]
    end

  private

    def method_missing name, *args
      @document[name.to_s]
    end
  end
end