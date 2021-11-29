#-- encoding: UTF-8



# Since Rails 5, rake commands like db:create load the whole application.
# As initializers and other parts of the boot sequence rely on calls accessing
# the DB, the null db gem is used to fake the existence of a database in cases where
# the db has not been created yet.

OpenProject::NullDbFallback.fallback
