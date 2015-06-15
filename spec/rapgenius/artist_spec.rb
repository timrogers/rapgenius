require 'spec_helper'

describe RapGenius::Artist do
  let(:access_token) { 'my-access-token' }
  before { RapGenius::Client.access_token = access_token }

  context "Drake", vcr: { cassette_name: "artist-130" } do
    subject(:artist) { described_class.find(130) }

    its(:url) { should eq "http://genius.com/artists/Drake" }
    its(:name) { should eq "Drake" }
    its(:image) { should eq "http://images.rapgenius.com/6e996fe91d484c626f1b36686cb27d7c.450x253x70.gif" }
    its(:description) { should include "Drake is part of a generation of new rappers" }

    context "#songs" do
      subject { artist.songs }

      its(:count) { should eq 20 }
      its(:last) { should be_a RapGenius::Song }
      its("last.title") { should eq "Amen" }

      context "pagination" do
        subject { artist.songs(page: 3) }

        its(:last) { should be_a RapGenius::Song }
        its(:count) { should eq 20 }
        its("last.title") { should eq "Champion" }
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
