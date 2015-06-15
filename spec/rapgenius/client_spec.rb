require 'spec_helper'

class ClientTester
  # On other classes, we don't expose this as we'd rather use this attribute
  # for the URL of the song itself
  attr_reader :url

  include RapGenius::Client
end

describe RapGenius::Client do
  let(:client) { ClientTester.new }

  let(:access_token) { 'my-access-token' }
  before { RapGenius::Client.access_token = access_token }

  describe "#url=" do
    it "forms the URL with the base URL, if the current path is relative" do
      client.url = "foobar"
      client.url.should include RapGenius::Client::BASE_URL
    end

    it "leaves the URL as it is if already complete" do
      client.url = "http://foobar.com/baz"
      client.url.should eq "http://foobar.com/baz"
    end
  end

  describe '.access_token=' do
    before do
      stub_request(:get, 'https://api.rapgenius.com/hello?text_format=dom,plain').
        with(headers: {'Authorization' => "Bearer #{access_token}",
                       'User-Agent' => "rapgenius.rb v#{RapGenius::VERSION}"})
    end

    it 'should send the header' do
      client.fetch('/hello')
      assert_requested(:get, 'https://api.rapgenius.com/hello?text_format=dom,plain')
    end
  end

  describe "#document" do
    before { client.url = "http://foo.bar" }

    context "no access token" do
      let(:access_token) { nil }

      it "raises a MissingAccessToken error" do
        expect { client.document }.to raise_error(RapGenius::MissingAccessTokenError)
      end
    end

    context "with a 404 response" do
      before do
        stub_request(:get, "http://foo.bar").with(query: { text_format: "dom,plain" }).
          to_return({body: '', status: 404})
      end

      it "raises a ScraperError" do
        expect { client.document }.to raise_error(RapGenius::NotFoundError)
      end
    end

    context "with an authentication failure" do
      before do
        stub_request(:get, "http://foo.bar").with(query: { text_format: "dom,plain" }).
          to_return({body: '', status: 401})
      end

      it "raises a ScraperError" do
        expect { client.document }.to raise_error(RapGenius::AuthenticationError)
      end
    end
  end
end
