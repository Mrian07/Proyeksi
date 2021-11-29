

require 'spec_helper'

describe WorkPackage, 'acts_as_customizable', type: :model do
  let(:type) { FactoryBot.create(:type_standard) }
  let(:project) { FactoryBot.create(:project, types: [type]) }
  let(:user) { FactoryBot.create(:user) }
  let(:status) { FactoryBot.create(:status) }
  let(:priority) { FactoryBot.create(:priority) }

  let(:work_package) { FactoryBot.create(:work_package, project: project, type: type) }
  let(:new_work_package) do
    WorkPackage.new type: type,
                    project: project,
                    author: user,
                    status: status,
                    priority: priority,
                    subject: 'some subject'
  end

  def setup_custom_field(cf)
    project.work_package_custom_fields << cf
    type.custom_fields << cf
  end

  describe '#custom_field_values=' do
    context 'with an unpersisted work package and a version custom field' do
      subject(:wp_with_assignee_cf) do
        setup_custom_field(version_cf)
        new_work_package.custom_field_values = { version_cf.id.to_s => version }
        new_work_package
      end

      let(:version) { FactoryBot.create(:version, project: project) }
      let(:version_cf) { FactoryBot.create(:version_wp_custom_field, is_required: true) }

      it 'results in a valid work package' do
        expect(wp_with_assignee_cf)
          .to be_valid
      end

      it 'sets the value' do
        expect(wp_with_assignee_cf.send(version_cf.accessor_name))
          .to eql version
      end
    end
  end

  describe '#custom_field_:id' do
    let(:included_cf) { FactoryBot.build(:work_package_custom_field) }
    let(:other_cf) { FactoryBot.build(:work_package_custom_field) }

    before do
      included_cf.save
      other_cf.save

      setup_custom_field(included_cf)
    end

    it 'says to respond to valid custom field accessors' do
      expect(work_package.respond_to?(included_cf.accessor_name)).to be_truthy
    end

    it 'really responds to valid custom field accessors' do
      expect(work_package.send(included_cf.accessor_name)).to eql(nil)
    end

    it 'says to not respond to foreign custom field accessors' do
      expect(work_package.respond_to?(other_cf.accessor_name)).to be_falsey
    end

    it 'does really not respond to foreign custom field accessors' do
      expect { work_package.send(other_cf.accessor_name) }.to raise_error(NoMethodError)
    end
  end

  describe '#valid?' do
    let(:cf1) { FactoryBot.create(:work_package_custom_field, is_required: true) }
    let(:cf2) { FactoryBot.create(:work_package_custom_field, is_required: true) }

    it 'does not duplicate error messages when invalid' do
      # create work_package with one required custom field
      work_package = new_work_package
      #work_package.reload
      setup_custom_field(cf1)

      # set that custom field with a value, should be fine
      work_package.custom_field_values = { cf1.id => 'test' }
      work_package.save!
      work_package.reload

      # now give the work_package another required custom field, but don't assign a value
      setup_custom_field(cf2)
      work_package.custom_field_values # #custom_field_values needs to be touched

      # that should not be valid
      expect(work_package).not_to be_valid

      # assert that there is only one error
      expect(work_package.errors.size).to eq 1
      expect(work_package.errors["custom_field_#{cf2.id}"].size).to eq 1
    end
  end
end
