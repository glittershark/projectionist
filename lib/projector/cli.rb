require 'projector'
require 'thor'

module Projector
  class CLI < Thor
    attr_accessor :projections

    def initialize(*)
      @projections = Projector::Projections.new
      @projections.load_file
      super
    end

    desc 'edit <type> <file>', 'Edit the file for <type> named <file>'
    def edit(type, file)
      editor = ENV['EDITOR'] || `which vim`
      file = @projections.file_for type, file
      Kernel.exec(editor, file)
    end
  end
end
