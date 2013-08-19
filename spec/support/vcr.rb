require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = {
    record: :new_episodes,
    re_record_interval: 24 * 60 * 60
  }
  c.cassette_library_dir = File.expand_path('../cassettes/', __FILE__)
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
