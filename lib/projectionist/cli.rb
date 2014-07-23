require 'projectionist'
require 'thor'

module Projectionist
  class CLI < Thor
    attr_accessor :projections

    def initialize(*)
      @projections = Projectionist::Projections.new
      super
    end

    desc 'edit <type> <file>', 'Edit the file for <type> named <file>'
    option :editor
    def edit(type, file)
      editor = options[:editor] || ENV['EDITOR'] || `which vim`
      file = @projections.file_for type, file
      exec editor, file
    end

    desc 'list <type>', 'List all files for <type>'
    def list(type)
      puts @projections.files_for(type).join("\n")
    end
  end
end
