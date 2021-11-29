#-- encoding: UTF-8



# Do not place any patches within this file. Add a file to lib/open_project/patches
require 'open_project/patches'

# Whatever ruby file is placed in lib/open_project/patches is required
Dir.glob(File.expand_path('../../lib/open_project/patches/*.rb', __dir__)).each do |path|
  require path
end
