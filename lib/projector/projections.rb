require 'json'

module Projector
  class Projections
    attr_reader :commands

    def initialize
      @commands = []
    end

    def load_file(path)
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
  end
end
