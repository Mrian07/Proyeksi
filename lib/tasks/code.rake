#-- encoding: UTF-8



namespace :code do
  desc 'Fix line endings of all source files'
  task :fix_line_endings do
    Dir.chdir(File.join(File.dirname(__FILE__), '../..')) do
      files = Dir['**/**{.rb,.html.erb,.rhtml,.rjs,.plain.erb,.rxml,.yml,.rake,.eml}']
      files.reject! do |f|
        f.include?('lib/plugins') ||
          f.include?('lib/diff')
      end

      # handle files in chunks of 50 to avoid too long command lines
      while (slice = files.slice!(0, 50)).present?
        system('ruby', '-i', '-pe', 'gsub(/\s+\z/,"\n")', *slice)
      end
    end
  end

  desc 'Set the magic encoding comment everywhere to UTF-8'
  task :source_encoding do
    shebang = '\s*#!.*?(\n|\r\n)'
    magic_regex = /\A(#{shebang})?\s*(#\W*(en)?coding:.*?$)/mi

    magic_comment = '#-- encoding: UTF-8'

    (Dir['script/**/**'] + Dir['**/**{.rb,.rake}']).each do |file_name|
      next unless File.file?(file_name)

      # We don't skip code here, as we need ALL code files to have UTF-8
      # source encoding
      file_content = File.read(file_name)
      if file_content =~ magic_regex
        file_content.gsub!(magic_regex, "\\1#{magic_comment}")
      elsif file_content.start_with?('#!')
        file_content.sub!(/(\n|\r\n)/, "\\1#{magic_comment}\\1")
      # We have a shebang. Encoding comment is to put on the second line
      else
        file_content = magic_comment + "\n" + file_content
      end

      File.open(file_name, 'w') do |file|
        file.write file_content
      end
    end
  end
end
