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
      glob = @types[type]['glob']
      specific_glob = glob.gsub(/(.*)\*(.*)/, "\\1#{file}\\2")
      file = Dir.glob(specific_glob)[0]
      File.expand_path(file.nil? ? specific_glob : file)
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
  end
end
