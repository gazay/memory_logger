# frozen_string_literal: true

class Mnemonic
  module Metric
    class HashMetric
      class Submetric < Base
        attr_reader :kind

        def initialize(parent:, key:, kind:, **)
          @parent = parent
          @key = key
          @name = "#{parent.name}(#{key.inspect})"
          @kind = kind
          super
        end

        private

        def current_value
          @parent[@key]
        end
      end

      def initialize(keys: [])
        @current_hash_value = {}
        kind_table = self.class.const_get(:KIND_TABLE)
        keys &= kind_table.keys
        keys = kind_table.keys if keys.empty?
        @submetrics = keys.map { |key| Submetric.new(parent: self, key: key, kind: kind_table[key]) }
      end

      def start!
        refresh_hash!
        @submetrics.each(&:start!)
      end

      def refresh!
        refresh_hash!
        @submetrics.each(&:refresh!)
      end

      def update!
        refresh_hash!
        @submetrics.each(&:update!)
      end

      def each_submetric(&block)
        @submetrics.each(&block)
      end

      def [](key)
        @current_hash_value[key]
      end

      private

      def refresh_hash!
        raise NotImplementedError
      end
    end
  end
end
