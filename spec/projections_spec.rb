require 'helper'

describe Projectionist::Projections do
  let!(:old_cwd) { Dir.pwd }

  before do
    Dir.mkdir fixture_folder unless Dir.exist? fixture_folder
    write_fixtures('*/*' => { 'type' => 'test' })
    Dir.chdir fixture_folder
  end

  after { Dir.chdir old_cwd }

  it('exists') { is_expected.not_to be nil }

  describe '.types' do
    before do
      subject.load_file fixture_file
    end

    it 'loads the list of types' do
      expect(subject.types).to eq ['test']
    end

    it 'has a method to check if a given type exists' do
      expect(subject.type? 'test').to be true
      expect(subject.type? 'toast').to be false
    end

    it 'sets a flag that the file existed' do
      expect(subject.json_file_existed).to be true
    end
  end

  describe '#load_file' do
    context 'when in a child directory' do
      before do
        write_fixtures('*/*' => { 'type' => 'test' })
        dir = File.join(fixture_folder, 'otherdir')
        Dir.mkdir dir unless Dir.exist? dir
        Dir.chdir dir
        subject = Projectionist::Projections.new
        subject.load_file
      end

      it 'still loads the file' do
        expect(subject.types).to eq ['test']
      end

      it 'still sets a flag that the file existed' do
        expect(subject.json_file_existed).to be true
      end
    end

    context 'without a config file' do
      before do
        Dir.chdir fixture_folder
        delete_fixtures
        subject = Projectionist::Projections.new
        subject.load_file
      end

      it "sets a flag that the file didn't exist" do
        expect(subject.json_file_existed).to be false
      end
    end

    context 'with `**/*` in projections' do
      before { write_fixtures('test/**/*.rb' => { 'type' => 'disallowed' }) }
      it 'raises an error' do
        expect { subject.load_file }.to raise_error Projectionist::ProjectionError
      end
    end
  end

  describe '#files_for' do
    let(:test_dir)       { File.join(fixture_folder, 'test') }
    let(:test_files) do
      (1..10).map { |n| File.join(test_dir, "#{n}_test.rb") }
    end
    let(:test_filenames) { (1..10).map(&:to_s) }

    before do
      write_fixtures('test/*_test.rb' => { 'type' => 'test' })
      Dir.mkdir(test_dir) unless Dir.exist? test_dir

      test_files.each { |f| File.open(f, 'w') }

      # make bad test files as well
      5.times do |n|
        file = File.join(test_dir, "#{n}_bad.rb")
        File.open(file, 'w')
      end

      subject.load_file
    end

    context 'with a valid type' do
      it 'matches the correct files' do
        expect(subject.files_for 'test').to match_array(test_filenames)
      end
    end

    context 'with verbose: true' do
      it 'returns the full filepaths' do
        expect(subject.files_for 'test', verbose: true)
          .to match_array(test_files)
      end
    end

    context 'without a valid type' do
      it 'returns an empty array' do
        expect(subject.files_for 'toast').to eq []
      end
    end

    context 'with files in child directories' do
      let(:test_subdir)           { File.join(test_dir, 'subdir') }
      let(:test_file_subdir)      { File.join(test_subdir, 'subdir_test.rb') }
      let(:test_file_subdir_name) { 'subdir/subdir' }
      before do
        Dir.mkdir(test_subdir) unless Dir.exist? test_subdir
        File.open(test_file_subdir, 'w')
      end

      after { File.delete test_file_subdir }

      it 'includes the correct file' do
        expect(subject.files_for('test')).to include test_file_subdir_name
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
        subject.load_file
      end

      context 'with a valid type' do
        it 'returns the correct file anyway' do
          expect(subject.file_for('test', 'file')).to eq test_file
        end
      end

      context 'without a valid type' do
        it 'returns nil' do
          expect(subject.file_for('toast', 'file')).to be_nil
        end
      end

      context "with a file that doesn't exist" do
        it 'returns the correct file' do
          expect(subject.file_for('test', 'nonexistent')).to eq File.join(test_dir, 'nonexistent.rb')
        end
      end

      context 'with other files in the directory' do
        let(:other_test_file) { File.join(test_dir, 'abc.rb') }
        before do
          File.open(other_test_file, 'w')
        end

        it 'matches the other file' do
          expect(subject.file_for('test', 'abc')).to eq other_test_file
        end

        it 'matches the old file' do
          expect(subject.file_for('test', 'file')).to eq test_file
        end
      end

      context 'with files in child directories' do
        let(:test_subdir)      { File.join(test_dir, 'subdir') }
        let(:test_file_subdir) { File.join(test_subdir, 'file.rb') }
        before do
          Dir.mkdir(test_subdir) unless Dir.exist? test_subdir
          File.open(test_file_subdir, 'w')
        end

        it 'returns the correct file' do
          expect(subject.file_for('test', 'subdir/file')).to eq test_file_subdir
        end
      end

      context 'in a child directory' do
        before { Dir.chdir test_dir }
        it 'returns the correct file' do
          expect(subject.file_for 'test', 'file').to eq test_file
        end
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
        subject.load_file
      end

      it 'returns the correct file path' do
        expect(subject.file_for 'test', 'foobar/file').to eq test_file
      end
    end

    context 'with singleton projections' do
      let(:singleton_file) { File.join(fixture_folder, 'README.md') }
      before do
        write_fixtures('README.md' => { 'type' => 'readme' })
        File.open(singleton_file, 'w')
        Dir.chdir fixture_folder
        subject.load_file
      end

      it 'returns the correct file path' do
        expect(subject.file_for 'readme').to eq singleton_file
      end
    end
  end
end
