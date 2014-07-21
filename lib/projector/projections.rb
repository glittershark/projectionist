require 'json'

module Projector
  class Projections
    attr_reader :commands

    def initialize
      @commands = []
    end

    def load_file(path = nil)
      if path == nil then
        path = get_path
        if path == nil then return end
      end
      @json = get_json path

      @json.each do |regex, options|
        if options.key? 'type' then
          @commands.push options['type']
        end
      end
    end

    def has_command?(command)
      @commands.include? command
    end

    private
    def get_json(path)
      File.open(path, 'r') { |f| JSON.parse(f.read) }
    end

    def get_path
      path = File.expand_path './.projections.json'
      while !File.exists? path
        if [false, '/'].include? File.dirname path then return nil end
        path = File.expand_path '../../.projections.json', path
      end

      path
    end
  end
end
