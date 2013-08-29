require 'spec_helper'

module RapGenius
  describe Song do
    context "given Big Sean's Control", vcr: {cassette_name: "big-sean-control-lyrics"} do
      subject { described_class.new("Big-sean-control-lyrics") }

      its(:url)         { should eq "http://rapgenius.com/Big-sean-control-lyrics" }
      its(:title)       { should eq "Control" }
      its(:artist)      { should eq "Big Sean" }
      its(:description) { should include "blew up the Internet" }
      its(:full_artist) { should include "(Ft. Jay Electronica & Kendrick Lamar)"}

      describe "#images" do
        it "should be an Array" do
          subject.images.should be_an Array
        end

        it "should include Big Sean's picture" do
          subject.images.should include "http://s3.amazonaws.com/rapgenius/1375029260_Big%20Sean.png"
        end
      end

      describe "#annotations" do
        it "should be an Array of Annotation objects" do
          subject.annotations.should be_an Array
          subject.annotations.first.should be_a Annotation
        end

        it "should be of a valid length" do
          # Annotations get added and removed from the live site; we want our
          # count to be somewhat accurate, within reason.
          subject.annotations.length.should be_within(15).of(130)
        end
      end
    end

    describe '.find' do
      it "returns a new instance at the specified path" do
        i = described_class.find("foobar")
        i.should be_a Song
        i.url.should eq 'http://rapgenius.com/foobar'
      end
    end

    describe '.search', vcr: {cassette_name: 'song-search-big-sean-control'} do
      let(:results) { described_class.search('Big Sean Control') }

      it "returns an Array of Songs" do
        results.should be_an Array
        results.first.should be_a Song
      end

      describe 'assigned attributes' do
        subject { results.first }

        its(:url)    { should eq "http://rapgenius.com/Big-sean-control-lyrics" }
        its(:artist) { should eq "Big Sean (Ft. Jay Electronica & Kendrick Lamar)" }
        its(:title)  { should eq "Control" }
      end
    end
  end
end
