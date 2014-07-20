$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'projector'
require 'json'

def fixture_path()
  File.expand_path("../fixtures/projections.json", __FILE__)
end

def read_fixtures()
  File.open(fixture_path, 'r') { |f| JSON.parse(f.read) }
end

def write_fixtures(hash)
  File.open(fixture_path, 'w') { |f| f.write(hash.to_json) }
end


