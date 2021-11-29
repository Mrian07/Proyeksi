#-- encoding: UTF-8



##
# Create a temporary +vendor+ repository from the stored fixture.
# Automatically extracts and destroys said repository,
# however does not provide single example isolation
# due to performance.
# As we do not write to the repository, we don't need this kind
# of isolation.
def with_filesystem_repository(vendor, command = nil, &block)
  repo_dir = Dir.mktmpdir("#{vendor}_repository")
  fixture = File.join(Rails.root, "spec/fixtures/repositories/#{vendor}_repository.tar.gz")

  ['tar', command].compact.each do |cmd|
    # Avoid `which`, as it's not POSIX
    Open3.capture2e(cmd, '--version')
  rescue Errno::ENOENT
    skip "#{cmd} was not found in PATH. Skipping local repository specs"
  end

  after(:all) do
    FileUtils.remove_dir repo_dir
  end

  system "tar -xzf #{fixture} -C #{repo_dir}"
  block.call(repo_dir)
end

def with_subversion_repository(&block)
  with_filesystem_repository('subversion', 'svn', &block)
end

def with_git_repository(&block)
  with_filesystem_repository('git', 'git', &block)
end

##
# Many specs required any repository to be available,
# often Filesystem adapter was used, even though
# no actual filesystem access occurred.
# Instead, we wrap these repository specs in a virtual
# subversion repository which does not exist on disk.
def with_virtual_subversion_repository(&block)
  let(:repository) { FactoryBot.create(:repository_subversion) }

  before do
    allow(Setting).to receive(:enabled_scm).and_return(['subversion'])
  end

  block.call
end
