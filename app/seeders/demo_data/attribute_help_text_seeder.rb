#-- encoding: UTF-8


module DemoData
  class AttributeHelpTextSeeder < Seeder
    def initialize; end

    def seed_data!
      print_status '    ↳ Creating attribute help texts' do
        seed_attribute_help_texts
      end
    end

    private

    def seed_attribute_help_texts
      help_texts = demo_data_for('attribute_help_texts')
      if help_texts.present?
        help_texts.each do |help_text_attr|
          print_status '.'
          create_attribute_help_text help_text_attr
        end
      end
    end

    def create_attribute_help_text(help_text_attr)
      help_text_attr[:type] = AttributeHelpText::WorkPackage

      attribute_help_text = AttributeHelpText.new help_text_attr
      attribute_help_text.save
    end
  end
end
