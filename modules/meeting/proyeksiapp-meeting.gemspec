# encoding: UTF-8

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'proyeksiapp-meeting'
  s.version     = '1.0.0'
  s.authors     = 'ProyeksiApp GmbH'
  s.email       = 'info@proyeksiapp.com'
  s.summary     = 'ProyeksiApp Meeting'
  s.description = "This module adds functions to support project meetings to ProyeksiApp. Meetings
    can be scheduled selecting invitees from the same project to take part in the meeting. An agenda
    can be created and sent to the invitees. After the meeting, attendees can be selected and
    minutes can be created based on the agenda. Finally, the minutes can be sent to all attendees
    and invitees."
  s.license     = 'GPLv3'

  s.files = Dir['{app,config,db,lib,doc}/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'icalendar', '~> 2.7.0'
end
