#-- encoding: UTF-8



# Be sure to restart your server when you modify this file.

# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.
# Rails.backtrace_cleaner.add_silencer { |line| line =~ /my_noisy_library/ }

##
# Remove the default backtrace silencer to allow other app paths
# to be matched (e.g., the ones in modules)
Rails.backtrace_cleaner.remove_silencers!

# compare this with APP_DIRS_PATTERN in railties/lib/rails/backtrace_cleaner.rb
fixed_dirs_patterns = /^\/?(app|config|lib|test|modules|\(\w*\))/
Rails.backtrace_cleaner.add_silencer { |line| !fixed_dirs_patterns.match?(line) }
