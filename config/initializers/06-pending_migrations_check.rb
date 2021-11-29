#-- encoding: UTF-8



# We want to abort booting when there are missing migrations by default
# since it can lead to runtime schema cache issues.
# Refusing to boot will encourage admins to fix missing migrations.

exceptions = %w(
  db:create db:drop db:migrate db:structure:load db:schema:load
  assets:precompile assets:clean
)
is_console = Rails.const_defined? 'Console'

if Rails.env.production? && !is_console && (exceptions & ARGV).empty?
  ActiveRecord::Migration.check_pending! # will raise an exception and abort boot
end
