require 'helper'

describe Projectionist::Projections do
  before do
    @original_dir = Dir.pwd
    write_fixtures('*/*' => { 'type' => 'test' })
    Dir.mkdir fixture_folder unless Dir.exist? fixture_folder
    Dir.chdir fixture_folder
    @projections = Projectionist::Projections.new
  end

  after { Dir.chdir @original_dir }

  it 'exists' do
    expect(@projections).not_to be nil
  end

  describe '.types' do
    before do
      @projections.load_file fixture_file
    end

    it 'loads the list of types' do
      expect(@projections.types.keys).to eq ['test']
    end

    it 'has a method to check if a given type exists' do
      expect(@projections.type? 'test').to be true
      expect(@projections.type? 'toast').to be false
    end

    it 'sets a flag that the file existed' do
      expect(@projections.json_file_existed).to be true
    end
  end

  describe '#load_file' do
    context 'when in a child directory' do
      before do
        write_fixtures('*/*' => { 'type' => 'test' })
        dir = File.join(fixture_folder, 'otherdir')
        Dir.mkdir dir unless Dir.exist? dir
        Dir.chdir dir
        @projections = Projectionist::Projections.new
        @projections.load_file
      end

      it 'still loads the file' do
        expect(@projections.types.keys).to eq ['test']
      end

      it 'still sets a flag that the file existed' do
        expect(@projections.json_file_existed).to be true
      end
    end

    context 'without a config file' do
      before do
        Dir.chdir fixture_folder
        delete_fixtures
        @projections = Projectionist::Projections.new
        @projections.load_file
      end

      it "sets a flag that the file didn't exist" do
        expect(@projections.json_file_existed).to be false
      end
    end

    context 'with `**/*` in projections' do
      before { write_fixtures('test/**/*.rb' => { 'type' => 'disallowed' }) }
      it 'raises an error' do
        expect { @projections.load_file }.to raise_error Projectionist::ProjectionError
      end
    end
  end

  describe '#files_for' do
    let(:test_dir)   { File.join(fixture_folder, 'test') }
    let(:test_files) { (1..10).map { |n| File.join(test_dir, "test_#{n}.rb") } }

    before do
      write_fixtures('test/test_*.rb' => { 'type' => 'test' })
      Dir.mkdir(test_dir) unless Dir.exist? test_dir

      test_files.each { |f| File.open(f, 'w') }

      # make bad test files as well
      5.times do |n|
        file = File.join(test_dir, "bad_#{n}.rb")
        File.open(file, 'w')
      end

      @projections.load_file
    end

    context 'with a valid type' do
      it 'matches the correct files' do
        expect(@projections.files_for 'test').to match_array(test_files)
      end
    end

    context 'without a valid type' do
      it 'returns an empty array' do
        expect(@projections.files_for 'toast').to eq []
      end
    end
  end

  describe '#file_for' do
    context 'with simple globs' do
      let(:test_dir)  { File.join(fixture_folder, 'test') }
      let(:test_file) { File.join(test_dir, 'file.rb') }
      before do
        write_fixtures('test/*.rb' => { 'type' => 'test' })
        Dir.mkdir(test_dir) unless Dir.exist? test_dir
        File.open(test_file, 'w')
        Dir.chdir fixture_folder
        @projections.load_file
      end

      context 'with a valid type' do
        subject { @projections.file_for('test', 'file') }
        it { is_expected.to eq test_file }
      end

      context 'without a valid type' do
        subject { @projections.file_for('toast', 'file') }
        it { is_expected.to be_nil }
      end

      context "with a file that doesn't exist" do
        subject { @projections.file_for('test', 'nonexistent') }
        it { is_expected.to eq File.join(test_dir, 'nonexistent.rb') }
      end

      context 'with other files in the directory' do
        let(:other_test_file) { File.join(test_dir, 'abc.rb') }
        before do
          File.open(other_test_file, 'w')
        end

        it 'matches the other file' do
          expect(@projections.file_for('test', 'abc')).to eq other_test_file
        end

        it 'matches the old file' do
          expect(@projections.file_for('test', 'file')).to eq test_file
        end
      end

      context 'with files in child directories' do
        let(:test_subdir)      { File.join(test_dir, 'subdir') }
        let(:test_file_subdir) { File.join(test_subdir, 'file.rb') }
        before do
          Dir.mkdir(test_subdir) unless Dir.exist? test_subdir
          File.open(test_file_subdir, 'w')
        end

        subject { @projections.file_for('test', 'subdir/file') }
        it { is_expected.to eq test_file_subdir }
      end

      context 'in a child directory' do
        before { Dir.chdir test_dir }
        subject { @projections.file_for('test', 'file') }
        it { is_expected.to eq test_file }
      end
    end

    context 'with advanced globs' do
      let(:test_dir)  { File.join(fixture_folder, 'test', 'foobar') }
      let(:test_file) { File.join(test_dir, 'test_file.rb') }
      before do
        write_fixtures('test/**/test_*.rb' => { 'type' => 'test' })
        FileUtils.mkdir_p test_dir unless Dir.exist? test_dir
        File.open(test_file, 'w')
        Dir.chdir fixture_folder
        @projections.load_file
      end

      subject { @projections.file_for 'test', 'foobar/file' }
      it { is_expected.to eq test_file }
    end
  end
end
