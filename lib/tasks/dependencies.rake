

require 'open3'

namespace :openproject do
  namespace :dependencies do
    desc 'Updates everything that is updatable automatically especially dependencies'
    task update: %w[openproject:dependencies:update:gems]

    namespace :update do
      def parse_capture(capture, &block)
        capture
          .split("\n")
          .map do |line|
          block.call(line)
        end.compact
      end


      desc 'Update gems to the extend the Gemfile allows in individual commits'
      task :gems do
        out, _process = Open3.capture3('bundle', 'outdated', '--parseable')

        parsed = parse_capture(out) do |line|
          line.match(/(\S+) \(newest ([0-9.]+), installed ([0-9.]+)(?:, requested .{0,2} ([0-9.]+))?\)/).to_a[1..4]
        end

        parsed.map(&:first).each do |gem|
          puts "Updating #{gem}"
          _out, error = Open3.capture3('bundle', 'update', gem)

          if error.present?
            puts "Attempted to update #{gem} but failed: #{error}"
          else
            out, _process = Open3.capture3('git', 'diff', 'Gemfile.lock')

            parsed = parse_capture(out) do |line|
              line.match(/\A\+\s{4}(\S+) \(([0-9.]+)\)\z/).to_a[1..2]
            end

            parsed.each do |gem, version|
              puts "  #{gem}: #{version}"
            end

            Open3.capture3('git', 'add', 'Gemfile.lock')
            Open3.capture3('git', 'commit', '-m', "bump #{parsed.map(&:first).join(' & ')}")
          end
        end
      end
    end
  end
end
