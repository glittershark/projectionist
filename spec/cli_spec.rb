require 'helper'

describe Projectionist::CLI do
  let(:test_dir)  { File.join(fixture_folder, 'test') }
  let(:test_file) { File.join(test_dir, 'file.rb') }
  let!(:old_cwd)  { Dir.pwd }

  before do
    FileUtils.rm_rf fixture_folder
    Dir.mkdir fixture_folder
    write_fixtures('test/*.rb' => { 'type' => 'test' })
    Dir.mkdir test_dir
    File.open(test_file, 'w')
    Dir.chdir fixture_folder
  end

  after { Dir.chdir old_cwd }

  describe '#edit' do
    context 'with options[:editor] and $EDITOR set' do
      before do
        subject.options = { editor: '/use/this/one' }
        ENV['EDITOR'] = '/this/is/test/two'
      end

      it 'edits the file with options[:editor]' do
        expect(subject).to receive(:exec).with("/use/this/one #{test_file}")
        subject.edit 'test', 'file'
      end
    end

    context 'with $VISUAL and $EDITOR set, but not options[:editor]' do
      before do
        subject.options = {}
        ENV['VISUAL'] = '/this/is/test/one'
        ENV['EDITOR'] = '/this/is/test/two'
      end

      it 'edits the file with $VISUAL' do
        expect(subject).to receive(:exec).with("/this/is/test/one #{test_file}")
        subject.edit 'test', 'file'
      end
    end

    context 'with $EDITOR set but not $VISUAL or options[:editor]' do
      before do
        subject.options = {}
        ENV.delete('VISUAL')
        ENV['EDITOR'] = '/this/is/a/test'
      end

      it 'edits the file with $EDITOR' do
        expect(subject).to receive(:exec).with("/this/is/a/test #{test_file}")
        subject.edit 'test', 'file'
      end
    end

    context 'with none of options[:editor], $VISUAL, or $EDITOR set' do
      before do
        subject.options = {}
        ENV.delete('VISUAL')
        ENV.delete('EDITOR')
      end

      it 'edits the file with `vim`' do
        expect(subject).to receive(:exec).with("vim #{test_file}")
        subject.edit 'test', 'file'
      end
    end

    context 'with empty strings for the environment variables' do
      before do
        subject.options = {}
        ENV['VISUAL'] = ''
        ENV['EDITOR'] = ''
      end

      it 'edits the file with `vim`' do
        expect(subject).to receive(:exec).with("vim #{test_file}")
        subject.edit 'test', 'file'
      end
    end
  end

  describe '#list' do
    context 'with options[:verbose]=false' do
      before do
        subject.options = { verbose: false }
      end

      it 'prints out the files for the given type, one per line' do
        expect { subject.list 'test' }.to output("file\n").to_stdout
      end
    end

    context 'with options[:verbose]=true' do
      before do
        subject.options = { verbose: true }
      end

      it 'prints out the full paths for the given type, one per line' do
        expect { subject.list 'test' }.to output("#{test_file}\n").to_stdout
      end
    end
  end
end
