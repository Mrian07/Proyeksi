#-- encoding: UTF-8



ProyeksiApp::Activity.map do |activity|
  activity.register :work_packages, class_name: '::Activities::WorkPackageActivityProvider'
  activity.register :changesets, class_name: 'Activities::ChangesetActivityProvider'
  activity.register :news, class_name: 'Activities::NewsActivityProvider',
                           default: false
  activity.register :wiki_edits, class_name: 'Activities::WikiContentActivityProvider',
                                 default: false
  activity.register :messages, class_name: 'Activities::MessageActivityProvider',
                               default: false
end

Project.register_latest_project_activity on: 'WorkPackage',
                                         attribute: :updated_at

Project.register_latest_project_activity on: 'News',
                                         attribute: :updated_at

Project.register_latest_project_activity on: 'Changeset',
                                         chain: 'Repository',
                                         attribute: :committed_on

Project.register_latest_project_activity on: 'WikiContent',
                                         chain: %w(Wiki WikiPage),
                                         attribute: :updated_at

Project.register_latest_project_activity on: 'Message',
                                         chain: 'Forum',
                                         attribute: :updated_at
