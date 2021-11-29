

FactoryBot.define do
  factory :ifc_model, class: '::Bim::IfcModels::IfcModel' do
    sequence(:title) { |n| "Unconverted IFC model #{n}" }
    project factory: :project
    uploader factory: :user
    is_default { true }
    transient do
      ifc_attachment do
        Rack::Test::UploadedFile.new(
          File.join(Rails.root, "modules/bim/spec/fixtures/files/minimal.ifc"),
          'application/binary'
        )
      end

      callback(:after_create) do |model, evaluator|
        User.system.run_given do
          model.ifc_attachment = evaluator.ifc_attachment
        end
      end
    end

    factory :ifc_model_minimal_converted do
      sequence(:title) { |n| "Converted IFC model #{n}" }
      project factory: :project
      uploader factory: :user
      is_default { true }
      transient do
        xkt_attachment do
          Rack::Test::UploadedFile.new(
            File.join(Rails.root, "modules/bim/spec/fixtures/files/minimal.xkt"),
            'application/binary'
          )
        end
      end

      callback(:after_create) do |model, evaluator|
        User.system.run_given do
          model.xkt_attachment = evaluator.xkt_attachment
        end
      end
    end
  end

  factory :ifc_model_without_ifc_attachment, class: '::Bim::IfcModels::IfcModel' do
    sequence(:title) { |n| "Model without ifc_attachment #{n}" }
    project factory: :project
    uploader factory: :user
    is_default { true }
  end
end
