

require 'spec_helper'

describe QueryPolicy, type: :controller do
  let(:user)    { FactoryBot.build_stubbed(:user) }
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:query)   { FactoryBot.build_stubbed(:query, project: project, user: user) }

  describe '#allowed?' do
    let(:subject) { described_class.new(user) }

    before do
      # Allow everything by default so that it is spotted
      # if any other permission influences the outcome.
      allow(user).to receive(:allowed_to?).and_return true
    end

    shared_examples 'viewing queries' do |global|
      context (global ? 'in global context' : 'in project context').to_s do
        let(:other_user) { FactoryBot.build_stubbed(:user) }
        if global
          let(:project) { nil }
        end

        it 'is true if the query is public and another user views it' do
          query.is_public = true
          query.user = other_user
          expect(subject.allowed?(query, :show)).to be_truthy
        end

        context 'query belongs to a different user' do
          let(:query) do
            FactoryBot.build_stubbed(:query,
                                     project: project,
                                     user: user,
                                     is_public: false)
          end

          it 'is true if the query is private and the owner views it' do
            expect(subject.allowed?(query, :show)).to be_truthy
          end

          it 'is false if the query is private and another user views it' do
            query.user = other_user
            expect(subject.allowed?(query, :show)).to be_falsy
          end
        end
      end
    end

    shared_examples 'action on persisted' do |action, global|
      context "for #{action} #{global ? 'in global context' : 'in project context'}" do
        if global
          let(:project) { nil }
        end

        before do
          allow(query).to receive(:new_record?).and_return false
          allow(query).to receive(:persisted?).and_return true
        end

        it 'is false if the user has no permission in the project' do
          allow(user).to receive(:allowed_to?).and_return false

          expect(subject.allowed?(query, action)).to be_falsy
        end

        it 'is false if the user has the save_query permission in the project ' +
           'AND the query is not persisted' do
          allow(user).to receive(:allowed_to?).with(:save_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true
          allow(query).to receive(:persisted?).and_return false

          expect(subject.allowed?(query, action)).to be_falsy
        end

        it 'is true if the user has the save_query permission in the project ' +
           'AND it is his query' do
          allow(user).to receive(:allowed_to?).with(:save_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true
          query.user = user

          expect(subject.allowed?(query, action)).to be_truthy
        end

        it 'is false if the user has the save_query permission in the project ' +
           'AND it is not his query' do
          allow(user).to receive(:allowed_to?).with(:save_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true

          query.user = FactoryBot.build_stubbed(:user)

          expect(subject.allowed?(query, action)).to be_falsy
        end

        it 'is false if the user lacks the save_query permission in the project ' +
           'AND it is his query' do
          allow(user).to receive(:allowed_to?).with(:save_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return false

          query.user = user

          expect(subject.allowed?(query, action)).to be_falsy
        end

        it 'is true if the user has the manage_public_query permission in the project ' +
           'AND it is anothers query ' +
           'AND the query is public' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true
          query.user = FactoryBot.build_stubbed(:user)
          query.is_public = true

          expect(subject.allowed?(query, action)).to be_truthy
        end

        it 'is false if the user lacks the manage_public_query permission in the project ' +
           'AND it is anothers query ' +
           'AND the query is public' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return false
          query.user = FactoryBot.build_stubbed(:user)
          query.is_public = true

          expect(subject.allowed?(query, action)).to be_falsy
        end

        it 'is false if the user has the manage_public_query permission in the project ' +
           'AND it is anothers query ' +
           'AND the query is not public' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true
          query.user = FactoryBot.build_stubbed(:user)
          query.is_public = false

          expect(subject.allowed?(query, action)).to be_falsy
        end
      end
    end

    shared_examples 'action on unpersisted' do |action, global|
      context "for #{action} #{global ? 'in global context' : 'in project context'}" do
        if global
          let(:project) { nil }
        end

        before do
          allow(query).to receive(:new_record?).and_return true
          allow(query).to receive(:persisted?).and_return false
        end

        it 'is false if the user has no permission in the project' do
          allow(user).to receive(:allowed_to?).and_return false

          expect(subject.allowed?(query, action)).to be_falsy
        end

        it 'is true if the user has the save_query permission in the project' do
          allow(user).to receive(:allowed_to?).with(:save_queries,
                                                    project,
                                                    global: global)
            .and_return true

          expect(subject.allowed?(query, action)).to be_truthy
        end

        it 'is false if the user has the save_query permission in the project ' +
           'AND the query is persisted' do
          allow(user).to receive(:allowed_to?).with(:save_queries,
                                                    project,
                                                    global: global)
            .and_return true

          allow(query).to receive(:new_record?).and_return false

          expect(subject.allowed?(query, action)).to be_falsy
        end
      end
    end

    shared_examples 'publicize' do |global|
      context (global ? 'in global context' : 'in project context').to_s do
        if global
          let(:project) { nil }
        end

        it 'is false if the user has no permission in the project' do
          allow(user).to receive(:allowed_to?).and_return false

          expect(subject.allowed?(query, :publicize)).to be_falsy
        end

        it 'is true if the user has the manage_public_query permission in the project ' +
           'AND it is his query' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true

          expect(subject.allowed?(query, :publicize)).to be_truthy
        end

        it 'is false if the user has the manage_public_query permission in the project ' +
           'AND the query is not public ' +
           'AND it is not his query' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true
          query.user = FactoryBot.build_stubbed(:user)
          query.is_public = false

          expect(subject.allowed?(query, :publicize)).to be_falsy
        end
      end
    end

    shared_examples 'depublicize' do |global|
      context (global ? 'in global context' : 'in project context').to_s do
        if global
          let(:project) { nil }
        end

        it 'is false if the user has no permission in the project' do
          allow(user).to receive(:allowed_to?).and_return false

          expect(subject.allowed?(query, :depublicize)).to be_falsy
        end

        it 'is true if the user has the manage_public_query permission in the project ' +
           'AND the query belongs to another user' +
           'AND the query is public' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true

          query.user = FactoryBot.build_stubbed(:user)
          query.is_public = true

          expect(subject.allowed?(query, :depublicize)).to be_truthy
        end

        it 'is false if the user has the manage_public_query permission in the project ' +
           'AND the query is not public' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
            .and_return true
          query.is_public = false

          expect(subject.allowed?(query, :depublicize)).to be_falsy
        end
      end
    end

    shared_examples 'star' do |global|
      context (global ? 'in global context' : 'in project context').to_s do
        if global
          let(:project) { nil }
        end

        it 'is false if the user has no permission in the project' do
          allow(user).to receive(:allowed_to?).and_return false

          expect(subject.allowed?(query, :star)).to be_falsy
        end
      end
    end

    shared_examples 'update ordered_work_packages' do |global|
      context (global ? 'in global context' : 'in project context').to_s do
        if global
          let(:project) { nil }
        end

        it 'is false if the user has no permission in the project' do
          allow(user).to receive(:allowed_to?).and_return false

          expect(subject.allowed?(query, :reorder_work_packages)).to be_falsy
        end

        it 'is true if the user has the edit_work_packages permission in the project AND it public' do
          allow(user).to receive(:allowed_to?).with(:edit_work_packages,
                                                    project,
                                                    global: project.nil?)
                           .and_return true

          query.is_public = true
          expect(subject.allowed?(query, :reorder_work_packages)).to be_truthy
        end

        it 'is false if the user has the edit_work_packages permission in the project AND it is not his' do
          allow(user).to receive(:allowed_to?).with(:edit_work_packages,
                                                    project,
                                                    global: project.nil?)
                           .and_return true

          query.user = FactoryBot.build_stubbed(:user)
          query.is_public = false
          expect(subject.allowed?(query, :reorder_work_packages)).to be_falsey
        end

        it 'is true if the user has the save_queries permission in the project AND it is his query' do
          allow(user).to receive(:allowed_to?).with(:save_queries,
                                                    project,
                                                    global: project.nil?)
                           .and_return true

          expect(subject.allowed?(query, :reorder_work_packages)).to be_truthy
        end

        it 'is true if the user has the manage_public_query permission in the project ' +
           'AND it is a public query' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
                           .and_return true

          query.is_public = true
          expect(subject.allowed?(query, :reorder_work_packages)).to be_truthy
        end

        it 'is false if the user has the manage_public_query permission in the project ' +
           'AND the query is not public ' +
           'AND it is not his query' do
          allow(user).to receive(:allowed_to?).with(:manage_public_queries,
                                                    project,
                                                    global: project.nil?)
                           .and_return true
          query.user = FactoryBot.build_stubbed(:user)
          query.is_public = false

          expect(subject.allowed?(query, :reorder_work_packages)).to be_falsey
        end
      end
    end

    it_should_behave_like 'action on persisted', :update, global: true
    it_should_behave_like 'action on persisted', :update, global: false
    it_should_behave_like 'action on persisted', :destroy, global: true
    it_should_behave_like 'action on persisted', :destroy, global: false
    it_should_behave_like 'action on unpersisted', :create, global: true
    it_should_behave_like 'action on unpersisted', :create, global: false
    it_should_behave_like 'publicize', global: false
    it_should_behave_like 'publicize', global: true
    it_should_behave_like 'depublicize', global: false
    it_should_behave_like 'depublicize', global: true
    it_should_behave_like 'action on persisted', :star, global: false
    it_should_behave_like 'action on persisted', :star, global: true
    it_should_behave_like 'action on persisted', :unstar, global: false
    it_should_behave_like 'action on persisted', :unstar, global: true
    it_should_behave_like 'viewing queries', global: true
    it_should_behave_like 'viewing queries', global: false
  end
end
