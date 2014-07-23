$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'projectionist'
require 'json'
require 'fileutils'
require 'tmpdir'

RSpec.configure do |config|
  config.before(:suite) { $tmpdir = Dir.mktmpdir }
  config.after(:suite)  { FileUtils.remove_entry_secure $tmpdir }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_folder
  $tmpdir
end

def fixture_file
  File.join(fixture_folder, '.projections.json')
end

def read_fixtures
  File.open(fixture_file, 'r') { |f| JSON.parse(f.read) }
end

def write_fixtures(hash)
  File.open(fixture_file, 'w') { |f| f.write(hash.to_json) }
end

def delete_fixtures
  File.delete fixture_file if File.exist? fixture_file
end

def empty_fixtures
  FileUtils.rm_rf Dir.glob("#{fixture_folder}/*", File::FNM_DOTMATCH)
end
