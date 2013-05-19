# encoding: utf-8
require 'helper'

describe Wunderground::Client do
  before do
    @client = Wunderground::Client.new "my_api_key"
  end

  def search_request
    @client.request "conditions", "aarhus"
  end

  describe "#initialize" do
    it { expect(@client.settings).to eq({}) }
    it { expect(@client.api_key).to eq "my_api_key" }
  end

  describe "#request" do
    context "with invalid api key" do
      it { expect { search_request }.to raise_error Wunderground::APIKeyError }
    end

    context "with valid api key" do
      before :all do
        @valid_client = Wunderground::Client.new ENV['API_KEY']
        @response = @valid_client.request "conditions", "zmw:00000.1.06075"
      end

      it "should have API_KEY set" do
        expect(ENV["API_KEY"]).to be_an_instance_of String
      end

      it { expect(@response.document).to have_key "current_observation" }
    end
  end

  describe "#serialized_settings" do
    it "should serialize one setting" do
      @client.settings = { :lang => :FR }

      expect(@client.get_serialized_settings).to eq "lang:FR"
    end

    it "should serialize two settings" do
      @client.settings = { :lang => :FR, :pws => 0 }

      expect(@client.get_serialized_settings).to eq "lang:FR/pws:0"
    end

    it "should serialize n settings" do
      @client.settings = { :lang => :FR, :pws => 0, :option => :value, :abc => :def }

      expect(@client.get_serialized_settings).to eq "lang:FR/pws:0/option:value/abc:def"
    end
  end
end

# describe Wunderground::Client, "#request" do
#   before :all do
#     @client = Wunderground::Client.new "my_api_key"
#   end

#   it "serializes settings with only a single setting" do
#     @client.settings = { lang: :FR }
#     @client.get_settings_string.should eq "lang:FR"
#   end

#   it "serializes settings with only two settings" do
#     @client.settings = { lang: :FR, pws: 0 }
#     @client.get_settings_string.should eq "lang:FR/pws:0"
#   end

#     it "serializes settings with an arbitrary number of settings" do
#     @client.settings = { lang: :FR, pws: 0, setting: "hello", msg: :world }
#     @client.get_settings_string.should eq "lang:FR/pws:0/setting:hello/msg:world"
#   end
# end