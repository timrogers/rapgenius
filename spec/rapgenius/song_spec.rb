require 'spec_helper'

describe RapGenius::Song do
  context "Migos's Versace", vcr: { cassette_name: "song-176872" } do
    subject(:song) { described_class.find(176872) }

    let(:access_token) { 'my-access-token' }
    before { RapGenius::Client.access_token = access_token }

    its(:url) { should eq "http://genius.com/Migos-versace-lyrics" }
    its(:title) { should eq "Versace" }

    its(:description) { should include "the song blew up" }

    context "#artist" do
      subject { song.artist }
      it { should be_a RapGenius::Artist }
      its(:name) { should eq "Migos" }
    end

    context "#featured_artists" do
      subject { song.featured_artists }
      its(:length) { should eq 1 }
      its("first.name") { should eq "Drake" }
      its(:first) { should be_a RapGenius::Artist }
    end

    context "#producer_artists" do
      subject { song.producer_artists }
      its(:length) { should eq 1 }
      its("first.name") { should eq "Zaytoven" }
      its(:first) { should be_a RapGenius::Artist }
    end

    context "#media" do
      subject { song.media }
      its(:length) { should eq 2 }
      its(:first) { should be_a RapGenius::Media }
      its("first.provider") { should eq "soundcloud" }
    end

    context "#lines" do
      subject { song.lines }
      its(:count) { should eq 81 }
      its(:first) { should be_a RapGenius::Line }
      its("first.id") { should eq "1983907" }
      its("first.lyric") { should eq "[Verse 1: Drake]" }
      its("first.explanations.first") { should include "Versace used his verse in this runway show" }
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
