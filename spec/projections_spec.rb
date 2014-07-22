require 'helper'

describe Projector do
  it 'has a version number' do
    expect(Projector::VERSION).not_to be nil
  end

  describe 'Projections' do
    before do
      write_fixtures('*/*' => { 'type' => 'test' })
      Dir.chdir fixture_folder
      @projections = Projector::Projections.new
    end

    it 'exists' do
      expect(@projections).not_to be nil
    end

    describe 'Command handling' do
      before do
        @projections.load_file fixture_path
      end

      it 'loads the list of commands' do
        expect(@projections.commands).to eq ['test']
      end

      it 'has a method to check if a given command exists' do
        expect(@projections.command? 'test').to be true
        expect(@projections.command? 'toast').to be false
      end

      it 'sets a flag that the file existed' do
        expect(@projections.json_file_existed).to be true
      end
    end

    context 'when in a child directory' do
      before do
        write_fixtures('*/*' => { 'type' => 'test' })

        dir = File.join(fixture_folder, 'otherdir')
        Dir.mkdir dir unless Dir.exist? dir
        Dir.chdir dir
        @projections = Projector::Projections.new
        @projections.load_file
      end

      it 'still loads the file' do
        expect(@projections.commands).to eq ['test']
      end

      it 'still sets a flag that the file existed' do
        expect(@projections.json_file_existed).to be true
      end
    end

    context 'without a config file' do
      before do
        delete_fixtures
        Dir.chdir fixture_folder
        @projections = Projector::Projections.new
        @projections.load_file
      end

      it "sets a flag that the file didn't exist" do
        expect(@projections.json_file_existed).to be false
      end
    end
  end
end
