#-- encoding: UTF-8



module ProyeksiApp
  module Patches
    module String #:nodoc:
      # Parses hours format and returns a float
      def to_hours
        s = dup
        s.strip!
        if s =~ %r{^(\d+([.,]\d+)?)h?$}
          s = $1
        else
          # 230: 2.5
          s.gsub!(%r{^(\d+):(\d+)$}) { $1.to_i + $2.to_i / 60.0 }
          # 2h30, 2h, 30m => 2.5, 2, 0.5
          s.gsub!(%r{^((\d+)\s*(h|hours?))?\s*((\d+)\s*(m|min)?)?$}) { |m| $1 || $4 ? ($2.to_i + $5.to_i / 60.0) : m[0] }
        end
        # 2,5 => 2.5
        s.gsub!(',', '.')
        begin; Kernel.Float(s); rescue StandardError; nil; end
      end

      # TODO: Check if this can be deleted
      def with_leading_slash
        starts_with?('/') ? self : "/#{self}"
      end
    end
  end
end

String.include ProyeksiApp::Patches::String
String.include Redmine::Diff::Diffable
