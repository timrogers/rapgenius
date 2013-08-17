require 'spec_helper'

class ScraperTester
  include RapGenius::Scraper
end

describe RapGenius::Scraper do

  let(:scraper) { ScraperTester.new }
  let(:successful_request) { stub(body: "<body></body>", code: 200) }
  let(:failed_request) { stub(body: "<html></html>", code: 404) }

  it "stores a base URL" do
    RapGenius::Scraper::BASE_URL.should be_a String
  end

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

  describe "#fetch" do
    it "uses HTTParty's .get method" do
      HTTParty.expects(:get).with("http://foo.bar").
        once.returns(successful_request)

      scraper.send(:fetch, "http://foo.bar")
    end

    it "raises an exception if it doesn't get a 200 response" do
      HTTParty.expects(:get).with("http://foo.bar").returns(failed_request)

      expect{ scraper.send(:fetch, "http://foo.bar") }.
        to raise_error RapGenius::ScraperError
    end
  end

  describe "#document" do

    before do
      HTTParty.expects(:get).with("http://foo.bar").
        once.returns(successful_request)
      scraper.url = "http://foo.bar"
    end
    
    it "returns a Nokogiri object" do
      scraper.document.should be_a Nokogiri::HTML::Document
    end

    it "contains the tags in page received back from the HTTP request" do
      scraper.document.css('body').length.should eq 1
    end


  end

end