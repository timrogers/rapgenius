require 'spec_helper'

module RapGenius
  describe Song do
    context "given Migos's Versace", vcr: { cassette_name: "song-176872" } do
      subject(:song) { described_class.find(176872) }

      its(:url) { should eq "http://rapgenius.com/Migos-versace-lyrics" }
      its(:title) { should eq "Versace" }
  
      its(:description) { should include "they absolutely killed it" }

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

      context "#lines" do
        subject { song.lines }
        its(:count) { should eq 81 }
        its(:first) { should be_a Line }
        its("first.id") { should eq "1983907" }
        its("first.lyric") { should eq "[Verse 1: Drake]" }
        its("first.explanations.first") { should include "Versace used his verse in this runway show" }
      end

      its(:images) { should include "http://images.rapgenius.com/2b3fa8326a5277fa31f2012a7b581e2e.500x319x11.gif" }
      its(:pyongs) { should eq 22 }
      its(:hot?) { should eq false }
      its(:views) { should eq 1834811 }
      its(:concurrent_viewers) { should eq 9 }
    

      context "a non-existent song ID" do
        subject(:song) { described_class.find("bahahaha") }

        it "raises an exception" do
          expect { song }.to raise_exception
        end
      end
    end
  end
end
