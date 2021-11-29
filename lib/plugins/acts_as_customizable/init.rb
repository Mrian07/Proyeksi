

#-- encoding: UTF-8

require File.dirname(__FILE__) + '/lib/acts_as_customizable'
require File.dirname(__FILE__) + '/lib/human_attribute_name'
ActiveRecord::Base.include Redmine::Acts::Customizable
