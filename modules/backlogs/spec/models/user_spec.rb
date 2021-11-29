

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User, type: :model do
  describe 'backlogs_preference' do
    describe 'task_color' do
      it 'reads from and writes to a user preference' do
        u = FactoryBot.create(:user)
        u.backlogs_preference(:task_color, '#FFCC33')

        expect(u.backlogs_preference(:task_color)).to eq('#FFCC33')
        u.reload
        expect(u.backlogs_preference(:task_color)).to eq('#FFCC33')
      end

      it 'computes a random color and persists it, when none is set' do
        u = FactoryBot.create(:user)
        u.backlogs_preference(:task_color, nil)
        u.save!

        generated_task_color = u.backlogs_preference(:task_color)
        expect(generated_task_color).to match(/^#[0-9A-F]{6}$/)
        u.save!
        u.reload
        expect(u.backlogs_preference(:task_color)).to eq(generated_task_color)
      end
    end
  end
end
