#!/usr/bin/env ruby
#-- encoding: UTF-8



warn <<~EOS
    [DEPRECATION] The functionality provided by reposman.rb has been integrated into OpenProject.
    Please remove any existing cronjobs that still use this script.
  #{'  '}
    You can create repositories explicitly on the filesystem using managed repositories.
    Enable managed repositories for each SCM vendor individually using the templates
    defined in configuration.yml.
  #{'  '}
    If you want to convert existing repositories previously created (by reposman.rb or manually)
    into managed repositories, use the following command:
  #{'  '}
        $ bundle exec rake scm:migrate:managed[URL prefix (, URL prefix, ...)]
    Where URL prefix denotes a common prefix of repositories whose status should be upgraded to :managed.
    Example:
  #{'  '}
    If you have executed reposman.rb with the following parameters:
  #{'  '}
      $ reposman.rb [...] --svn-dir "/opt/svn" --url "file:///opt/svn"
  #{'  '}
    Then you can pass a URL prefix of 'file:///opt/svn' and the rake task will migrate all repositories
    matching this prefix to :managed.
    You may pass more than one URL prefix to the task.
EOS
