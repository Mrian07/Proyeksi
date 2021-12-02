

FactoryBot.define do
  factory :bcf_viewpoint, class: '::Bim::Bcf::Viewpoint' do
    new_uuid = SecureRandom.uuid
    uuid { new_uuid }
    viewpoint_name { "full_viewpoint.bcfv" }
    json_viewpoint do
      file = ProyeksiApp::Bim::Engine.root.join("spec/fixtures/viewpoints/#{viewpoint_name}.json")
      if file.readable?
        JSON.parse(file.read)
      else
        warn "Viewpoint name #{viewpoint_name} doesn't map to a viewpoint fixture"
      end
    end

    transient do
      snapshot { nil }
    end

    after(:create) do |viewpoint, evaluator|
      unless evaluator.snapshot == false
        create(:bcf_viewpoint_attachment, container: viewpoint)
      end
    end
  end
end
