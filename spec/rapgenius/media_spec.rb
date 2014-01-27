require 'spec_helper'

module RapGenius
  describe Media do

    subject(:media) do
      Media.new(
        type: "foo",
        url: "foo",
        provider: "foo"
      )
    end

    its(:type) { should eq "foo" }
    its(:url) { should eq "foo" }
    its(:provider) { should eq "foo" }

  end
end