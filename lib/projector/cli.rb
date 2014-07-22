require 'projector'
require 'thor'

module Projector
  class CLI < Thor
    attr_accessor :projections

    def initialize(*)
      @projections = Projector::Projections.new
      super
    end

    desc 'edit <type> <file>', 'Edit the file for <type> named <file>'
    def edit(type, file)
    end
  end
end
