require 'helper'

describe Projector::CLI do
  before do
    @cli = Projector::CLI.new
    @old_stderr = $stderr
    $stderr = StringIO.new
    @old_stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stderr = @old_stderr
    $stdout = @old_stdout
  end

  describe '#edit' do
    before do
      @cli.edit
    end
  end
end
