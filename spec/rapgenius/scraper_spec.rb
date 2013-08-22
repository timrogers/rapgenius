require 'spec_helper'

class ScraperTester
  include RapGenius::Scraper
end

module RapGenius
  describe Scraper do

    let(:scraper) { ScraperTester.new }

    describe "#url=" do
      it "forms the URL with the base URL, if the current path is relative" do
        scraper.url = "foobar"
        scraper.url.should include RapGenius::Scraper::BASE_URL
      end

      it "leaves the URL as it is if already complete" do
        scraper.url = "http://foobar.com/baz"
        scraper.url.should eq "http://foobar.com/baz"
      end
    end

    describe "#document" do
      before do
        scraper.url = "http://foo.bar/"
      end

      context "with a successful request" do
        before do
          stub_request(:get, "http://foo.bar").to_return({body: 'ok', status: 200})
        end

        it "returns a Nokogiri document object" do
          scraper.document.should be_a Nokogiri::HTML::Document
        end

        it "contains the tags in page received back from the HTTP request" do
          scraper.document.css('body').length.should eq 1
        end
      end

      context "with a failed request" do
        before do
          stub_request(:get, "http://foo.bar").to_return({body: '', status: 404})
        end

        it "raises a ScraperError" do
          expect { scraper.document }.to raise_error(RapGenius::ScraperError)
        end
      end
    end
  end
end
