require 'spec_helper'

module RapGenius
  describe Song do
    context "given Migos's Versace", vcr: { cassette_name: "song-176872" } do
      subject(:song) { described_class.find(176872) }

      its(:url) { should eq "http://genius.com/Migos-versace-lyrics" }
      its(:title) { should eq "Versace" }

      its(:description) { should include "the song blew up" }

      context "#artist" do
        subject { song.artist }
        it { should be_a Artist }
        its(:name) { should eq "Migos" }
      end

      context "#featured_artists" do
        subject { song.featured_artists }
        its(:length) { should eq 1 }
        its("first.name") { should eq "Drake" }
        its(:first) { should be_a Artist }
      end

      context "#producer_artists" do
        subject { song.producer_artists }
        its(:length) { should eq 1 }
        its("first.name") { should eq "Zaytoven" }
        its(:first) { should be_a Artist }
      end

      context "#media" do
        subject { song.media }
        its(:length) { should eq 2 }
        its(:first) { should be_a Media }
        its("first.provider") { should eq "soundcloud" }
      end

      its(:images) { should include "http://s3.amazonaws.com/rapgenius/Zaytoven_1-7-2011.jpg" }
      its(:pyongs) { should eq 166 }
      its(:hot?) { should eq false }
      its(:views) { should eq 2159953 }
      its(:concurrent_viewers) { should be_nil }


      context "a non-existent song ID" do
        subject(:song) { described_class.find("bahahaha") }

        it "raises an exception" do
          expect { song }.to raise_exception
        end
      end
    end
  end
end
