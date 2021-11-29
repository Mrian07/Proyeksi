#-- encoding: UTF-8



namespace :redmine do
  desc 'List all permissions and the actions registered with them'
  task permissions: :environment do
    puts 'Permission Name - controller/action pairs'
    OpenProject::AccessControl.permissions.sort { |a, b| a.name.to_s <=> b.name.to_s }.each do |permission|
      puts ":#{permission.name} - #{permission.controller_actions.join(', ')}"
    end
  end
end
