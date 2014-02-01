require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path('../cassettes/', __FILE__)
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
