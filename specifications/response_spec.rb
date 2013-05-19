# encoding: utf-8
require 'helper'

ResponseDataSingle = {
  "response" => {
           "version" => "0.1",
          "features" => {},
    "termsofService" => "http://www.wunderground.com/weather/api/d/terms.html"
  },
  "data" => {}
}

ResponseDataMultiple = {
  "response" => {
           "version" => "0.1",
           "results" => [
          {
        "l" => "zwm:2222.2"
      }
    ],
          "features" => {},
    "termsofService" => "http://www.wunderground.com/weather/api/d/terms.html"
  }
}

def single_response &block
  context "single response" do
    let(:response) { Wunderground::Response.new ResponseDataSingle }

    instance_eval &block
  end
end

def multiple_responses &block
  context "multiple responses" do
    let(:response) { Wunderground::Response.new ResponseDataMultiple }

    instance_eval &block
  end
end

describe Wunderground::Response do
  describe '#initialize' do
    let(:response) { Wunderground::Response.new ResponseDataSingle }

    it { expect(response).to respond_to :headers }
    it { expect(response).to respond_to :document }
  end

  describe '#headers' do
    single_response do
      it { expect(response.headers).to_not be_empty }
      it { expect(response.headers).to include "version" }
    end

    multiple_responses do
      it { expect(response.headers).to_not be_empty }
      it { expect(response.headers).to include "version", "results" }
    end
  end

  describe '#single?' do
    single_response do
      it { expect(response.single?).to be_true }
    end

    multiple_responses do
      it { expect(response.single?).to be_false }
    end
  end

  describe '#multiple?' do
    single_response do
      it { expect(response.multiple?).to be_false }
    end

    multiple_responses do
      it { expect(response.multiple?).to be_true }
    end
  end

  describe '#[]' do
    let(:response) { Wunderground::Response.new ResponseDataSingle }

    it { expect(response["version"]).to be_nil }
    it { expect(response["data"]).to be ResponseDataSingle["data"] }
  end

  describe '#results' do
    single_response do
      it { expect(response.results).to be_nil }
    end

    multiple_responses do
      it { expect(response.results).to be_an_instance_of Array }
      it { expect(response.results).to_not be_empty }
    end
  end

#   describe 'valid response' do
#     it "should have multiple results" do
#       response.multiple?.should be_true
#     end

#     it "should do a single request from multiple results" do
#       response.results.should_not be_empty

#       result = response.results.first
#       result["zmw"].should match(/[\d\.]+/)

#       response = @client.request "conditions", "zmw:#{result['zmw']}"
#       response["current_observation"].should be
#     end

#     it "should now be a single result" do
#       response.single?.should be_true
#     end

#     it "should have #current_observation data" do
#       response["current_observation"].should be
#     end

#     it "should have a full display location" do
#       current = response.current_observation

#       current["display_location"].should be
#       current["display_location"]["full"].should eq "Aarhus, Denmark"
#     end
#   end
end