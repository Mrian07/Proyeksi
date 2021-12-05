---
  title: ProyeksiApp 6.1.0
  sidebar_navigation:
      title: 6.1.0
  release_version: 6.1.0
  release_date: 2016-11-07
---


# ProyeksiApp 6.1.0

ProyeksiApp 6.1.0 contains several new features, including an enhanced
project member table and improved work package relations.  

## Enhanced project member table

ProyeksiApp 6.1 improves the project member table and adds filters to
the project member
list ([\#22859](https://community.proyeksiapp.com/work_packages/22859/activity)).

This provides an easy way to quickly find, remove or edit the
permissions of project members in large projects.



## Improved work package relations

The work package relations tab has been improved: It has a clearer
structure, allows to add existing children to a work package and adds
new relation types
([\#23709](https://community.proyeksiapp.com/work_packages/23709/activity)).

Hierarchical relationships are immediately clear through a
tree-structure.



## Improved performance for work packages

The work package list is now loaded more quickly and changes can be made
faster
([\#23780](https://community.proyeksiapp.com/work_packages/23780/activity)).

## Add meetings to calendar

The meeting agenda now has a button to send iCalendar invitations to
participants.
<span class="explanatory-dictionary-highlight" data-definition="explanatory-dictionary-definition-62">Meetings</span>
can therefore easily added to you calendar.

## API for users and relations

The ProyeksiApp API v3 has been extended by user endpoints. It is now
possible to create, read, update and delete user information.  
In addition, we added the relations API.  
For more information take a look at the [API
documentation](../../api/).

## Upgrade to Rails 5.0

The technology underlying ProyeksiApp (Ruby on Rails) has been updated
to provide the highest level of security.

## Improved design

ProyeksiApp 6.1 includes several design improvements. For example work
package attributes are now displayed in two columns instead of one if
there is enough space.

## Substantial number of bug fixes

ProyeksiApp 6.1 contains a large number of bugs fixes.

For an extensive overview of bug fixes please refer to the [following
list](https://community.proyeksiapp.com/projects/proyeksiapp/work_packages?query_props=%7B%22c%22:%5B%22id%22,%22subject%22,%22type%22,%22status%22,%22assignee%22%5D,%22p%22:%22proyeksiapp%22,%22t%22:%22parent:desc%22,%22f%22:%5B%7B%22n%22:%22version%22,%22o%22:%22%253D%22,%22t%22:%22list_optional%22,%22v%22:%22667%22%7D,%7B%22n%22:%22type%22,%22o%22:%22%253D%22,%22t%22:%22list_model%22,%22v%22:%5B%221%22%5D%7D,%7B%22n%22:%22subprojectId%22,%22o%22:%22*%22,%22t%22:%22list_subprojects%22%7D%5D,%22pa%22:1,%22pp%22:20%7D).


