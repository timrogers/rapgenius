require 'spec_helper'

describe RapGenius::Annotation do

  let(:annotation) { described_class.new(id: "1234") }
  subject { annotation }

  before do
    RapGenius::Annotation.any_instance.stubs(:fetch).
      returns(
        File.read(File.expand_path("../../support/annotation.html", __FILE__))
      )
  end

  describe ".find" do
    subject { described_class.find("9999") }

    its(:id) { should eq "9999"}

    it "should fetch the document to get annotation details" do
      subject.expects(:fetch).once.returns(
        File.read(File.expand_path("../../support/annotation.html", __FILE__))
      )
      
      subject.explanation
    end
  end

  its(:id) { should eq "1234" }
  its(:url) { should eq "http://rapgenius.com/1234" }

  describe "#lyric" do
    subject { annotation.lyric }
    it "only calls fetch the first time" do
      annotation.expects(:fetch).once.returns(
        File.read(File.expand_path("../../support/annotation.html", __FILE__))
      )

      2.times { annotation.lyric }
    end

    it { should eq "You gon' get this rain like it's May weather," }
  end

  describe "#explanation" do
    subject { annotation.explanation }
    it "only calls fetch the first time" do
      annotation.expects(:fetch).once.returns(
        File.read(File.expand_path("../../support/annotation.html", __FILE__))
      )

      2.times { annotation.explanation }
    end

    it { should include "making it rain" }
  end

  its(:song) { should be_a RapGenius::Song }
  its("song.url") { should eq "http://rapgenius.com/Big-sean-control-lyrics" }

  context "with additional parameters passed into the constructor" do
    let(:annotation) { described_class.new(id: "5678", lyric: "foo") }
    
    its(:id) { should eq "5678" }
    its(:lyric) { should eq "foo" }
  end

end
