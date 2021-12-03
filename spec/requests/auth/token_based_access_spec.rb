#-- encoding: UTF-8



require 'spec_helper'

describe 'Token based access', type: :rails_request, with_settings: { login_required?: false } do
  let(:work_package) { FactoryBot.create(:work_package) }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: work_package.project,
                      member_with_permissions: %i[view_work_packages])
  end
  let(:rss_key) { user.rss_key }

  it 'grants access but does not login the user' do
    # work_packages of a private project
    get "/work_packages/#{work_package.id}.atom"
    expect(response)
      .to redirect_to(signin_path(back_url: "http://www.example.com/work_packages/#{work_package.id}"))

    # access is possible with a token
    get "/work_packages/#{work_package.id}.atom?key=#{rss_key}"
    expect(response.body)
      .to include("<title>ProyeksiApp - #{work_package}</title>")

    # but for the next request, the user is not logged in
    get "/work_packages/#{work_package.id}"
    expect(response)
      .to redirect_to(signin_path(back_url: "http://www.example.com/work_packages/#{work_package.id}"))
  end
end
