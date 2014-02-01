require 'spec_helper'

module RapGenius
  describe Artist do
    context "given Drake", vcr: { cassette_name: "artist-130" } do
      subject(:artist) { described_class.find(130) }

      its(:url) { should eq "http://rapgenius.com/artists/Drake" }
      its(:name) { should eq "Drake" }
      its(:image) { should eq "http://images.rapgenius.com/2b3fa8326a5277fa31f2012a7b581e2e.500x319x11.gif" }
      its(:description) { should include "Drake is part of a generation of new rappers" }

      context "#songs" do
        subject { artist.songs }

        its(:count) { should eq 25 }
        its(:last) { should be_a Song }
        its("last.title") { should eq "Bitch Is Crazy" }

        context "pagination" do
          subject { artist.songs(page: 3) }

          its(:last) { should be_a Song }
          its(:count) { should eq 25 }
          its("last.title") { should eq "Versace" }
        end
      end

      context "a non-existent artist ID" do
        subject(:artist) { described_class.find("bahahaha") }

        it "raises an exception" do
          expect { artist }.to raise_exception
        end
      end
    end
  end
end
