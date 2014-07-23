require 'json'

module Projector
  class Projections
    attr_reader :types
    attr_reader :json_file_existed

    def initialize
      @types = {}
      load_file
    end

    def load_file(path = nil)
      @json = get_json path
      @json.each do |glob, options|
        next unless options.key? 'type'
        @types[options['type']] = options.merge('glob' => glob)
      end
    end

    def type?(type)
      @types.key?(type)
    end

    def file_for(type, file)
      return nil unless type? type

      glob = build_glob(@types[type]['glob'], file)
      file = Dir.glob(glob)[0]
      File.expand_path(file.nil? ? glob : file)
    end

    def files_for(type)
      return [] unless type? type
      Dir.glob(@types[type]['glob']).map { |p| File.expand_path p }
    end

    private

    def get_json(path)
      if path.nil?
        path = projections_path
        if path.nil?
          @json_file_existed = false
          return {}
        end
      end
      @json_file_existed = true
      File.open(path, 'r') { |f| JSON.parse(f.read) }
    end

    def projections_path
      path = File.expand_path './.projections.json'
      until File.exist? path
        return nil if [false, '/'].include?(File.dirname path)
        path = File.expand_path('../../.projections.json', path)
      end
      path
    end

    def build_glob(glob, file)
      # Split the passed file by `/`, then replace all globs that use `*` or `**` with
      # components of the passed file, in order
      file_components = file.split('/')
      glob_components = glob.split(/\*+/)
      glob_components.zip(file_components).flatten.compact.join('')
    end
  end
end
