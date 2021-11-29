#-- encoding: UTF-8



shared_context 'eager loaded work package representer' do
  before do
    allow(::API::V3::WorkPackages::WorkPackageEagerLoadingWrapper)
      .to receive(:wrap_one) do |work_package, _user|
      allow(work_package)
        .to receive(:cache_checksum)
        .and_return(srand)

      work_package
    end
  end
end
