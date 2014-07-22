require 'json'

module Projector
  class Projections
    attr_reader :commands
    attr_reader :json_file_existed

    def initialize
      @commands = []
    end

    def load_file(path = nil)
      @json = get_json path

      @json.each do |_regex, options|
        @commands.push(options['type']) if options.key? 'type'
      end
    end

    def command?(command)
      @commands.include?(command)
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
