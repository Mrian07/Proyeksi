#-- encoding: UTF-8

module Exports
  class Register
    class << self
      attr_reader :lists, :singles, :formatters

      def register(&block)
        instance_exec(&block)
      end

      def list(model, exporter)
        @lists ||= Hash.new do |hash, model_key|
          hash[model_key] = []
        end

        @lists[model.to_s] << exporter unless @lists[model.to_s].include?(exporter)
      end

      def list_formats(model)
        lists[model.to_s].map(&:key)
      end

      def single(model, exporter)
        @singles ||= Hash.new do |hash, model_key|
          hash[model_key] = []
        end

        @singles[model.to_s] << exporter unless @singles[model.to_s].include?(exporter)
      end

      def single_formats(model)
        singles[model.to_s].map(&:key)
      end

      def formatter(model, formatter)
        @formatters ||= Hash.new do |hash, model_key|
          hash[model_key] = []
        end

        @formatters[model.to_s] << formatter
      end

      def list_exporter(model, format)
        lists[model.to_s].detect { |exporter| exporter.key == format }
      end

      def single_exporter(model, format)
        singles[model.to_s].detect { |exporter| exporter.key == format }
      end

      def formatter_for(model, attribute)
        formatter = formatters[model.to_s].find { |f| f.apply? attribute } || ::Exports::Formatters::Default
        formatter.new(attribute)
      end
    end
  end
end
