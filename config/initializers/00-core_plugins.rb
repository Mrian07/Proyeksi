#-- encoding: UTF-8



# Loads the core plugins located in lib/plugins
Dir.glob(File.join(Rails.root, 'lib/plugins/*')).sort.each do |directory|
  if File.directory?(directory)
    lib = File.join(directory, 'lib')

    $:.unshift lib
    Rails.configuration.paths.add lib, eager_load: true, glob: "**[^test]/*"

    initializer = File.join(directory, 'init.rb')
    if File.file?(initializer)
      eval(File.read(initializer), binding, initializer)
    end
  end
end
