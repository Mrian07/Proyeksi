

#-- encoding: UTF-8

require File.dirname(__FILE__) + '/lib/acts_as_attachable'
ActiveRecord::Base.include Redmine::Acts::Attachable
