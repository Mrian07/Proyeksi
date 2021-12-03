#-- encoding: UTF-8



# Do not place any patches within this file. Add a file to lib/proyeksi_app/patches
require 'proyeksi_app/patches'

# Whatever ruby file is placed in lib/proyeksi_app/patches is required
Dir.glob(File.expand_path('../../lib/proyeksi_app/patches/*.rb', __dir__)).each do |path|
  require path
end
