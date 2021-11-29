#-- encoding: UTF-8


shared_context 'with tmpdir' do
  around do |example|
    Dir.mktmpdir do |dir|
      @tmpdir = dir
      example.run
    end
  end
  attr_reader :tmpdir
end
