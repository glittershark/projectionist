$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'projector'
require 'json'
require 'fileutils'

def fixture_folder
  File.expand_path('../fixtures', __FILE__)
end

def fixture_file
  File.expand_path(File.join(fixture_folder, '.projections.json'), __FILE__)
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
  FileUtils.rm_rf Dir.glob("#{fixture_folder}/*")
end
