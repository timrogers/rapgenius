require 'spec_helper'

module RapGenius
  describe Annotation, vcr: {cassette_name: "big-sean-annotation"} do

    let(:annotation) { described_class.new(id: "2092393") }
    subject { annotation }

    its(:id)       { should eq "2092393" }
    its(:url)      { should eq "http://rapgenius.com/2092393" }
    its(:song)     { should be_a Song }
    its(:song_url) { should eq "http://rapgenius.com/Big-sean-control-lyrics" }

    describe "#lyric" do
      it "should have the correct lyric" do
        annotation.lyric.should match "You gon' get this rain like it's May weather"
      end
    end

    describe "#explanation" do
      it "should have the correct explanation" do
        annotation.explanation.should include "making it rain"
      end
    end

    describe '.find' do
      it "returns a new instance at the specified path" do
        i = described_class.find("foobar")
        i.should be_an Annotation
        i.id.should eq "foobar"
      end
    end

    context "with additional parameters passed into the constructor" do
      let(:annotation) { described_class.new(id: "5678", lyric: "foo") }

      its(:id)    { should eq "5678" }
      its(:lyric) { should eq "foo" }
    end
  end
end
