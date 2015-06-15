require 'spec_helper'

describe RapGenius::Media do
  subject(:media) { described_class.new(type: "foo", url: "foo", provider: "foo") }

  its(:type) { should eq "foo" }
  its(:url) { should eq "foo" }
  its(:provider) { should eq "foo" }

end
