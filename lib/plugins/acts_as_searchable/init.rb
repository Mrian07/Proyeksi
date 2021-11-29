

#-- encoding: UTF-8

require File.dirname(__FILE__) + '/lib/acts_as_searchable'
ActiveRecord::Base.include Redmine::Acts::Searchable
