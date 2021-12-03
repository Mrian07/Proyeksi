

FactoryBot.define do
  factory :xml_viewpoint, class: 'OpenStruct' do
    uuid { SecureRandom.uuid }
    viewpoint_name { "full_viewpoint.bcfv" }
    viewpoint do
      file = ProyeksiApp::Bim::Engine.root.join("spec/fixtures/viewpoints/#{viewpoint_name}.xml")
      if file.readable?
        file.read
      else
        warn "Viewpoint name #{viewpoint_name} doesn't map to a viewpoint fixture"
      end
    end
  end
end
