require 'projectionist'
require 'thor'

module Projectionist
  class CLI < Thor
    attr_accessor :projections

    def initialize(*)
      @projections = Projectionist::Projections.new
      super
    rescue Projectionist::ProjectionError => error
      $stderr.puts "ERROR: #{error.message}"
      exit 1
    end

    desc 'edit <type> [<file>]', 'Edit the file for <type> named <file>'
    option :editor
    def edit(type, file='')
      file = @projections.file_for type, file
      exec "#{editor} #{file}"
    end

    desc 'list [-v|--verbose] <type>', 'List all files for <type>'
    option :verbose, type: :boolean, aliases: '-v',
      desc: "List full file paths instead of file names"
    def list(type)
      puts @projections.files_for(type, verbose: options[:verbose]).join("\n")
    end

    desc 'types', 'List all types'
    def types
      puts @projections.types.join("\n")
    end

    no_commands do
      def editor
        editor = options[:editor] || ENV['VISUAL'] || ENV['EDITOR'] || 'vim'
        editor.empty? ? 'vim' : editor
      end
    end
  end
end
