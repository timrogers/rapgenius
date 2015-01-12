require 'spec_helper'

class ClientTester
  # On other classes, we don't expose this as we'd rather use this attribute
  # for the URL of the song itself
  attr_reader :url

  include RapGenius::Client
end

module RapGenius
  describe Client do

    let(:client) { ClientTester.new }

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

    describe "#document" do
      before { client.url = "http://foo.bar" }

      context "with a failed request" do
        before do
          stub_request(:get, "http://foo.bar").with(query: { text_format: "dom,plain" }).
            to_return({body: '', status: 404})
        end

        it "raises a ScraperError" do
          expect { client.document }.to raise_error(RapGenius::Error)
        end
      end
    end
  end
end
